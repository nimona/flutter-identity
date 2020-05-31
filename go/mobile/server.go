package mobileapi

import (
	"encoding/json"
	"errors"
	"fmt"
	"regexp"
	"strings"
	"time"

	bip39 "github.com/tyler-smith/go-bip39"

	"nimona.io/pkg/context"
	"nimona.io/pkg/crypto"
	"nimona.io/pkg/exchange"
	"nimona.io/pkg/keychain"
	"nimona.io/pkg/object"
	"nimona.io/pkg/peer"
	"nimona.io/pkg/resolver"
)

var (
	charRegex  = regexp.MustCompile("[^a-zA-Z ]+")
	spaceRegex = regexp.MustCompile("\\s+")
)

type (
	Identity struct {
		PrivateKey         string `json:"privateKey"`
		PrivateKeyMnemonic string `json:"privateKeyMnemonic"`
		PublicKey          string `json:"publicKey"`
		Name               string `json:"name"`
	}
)

func StartDaemon() string {
	return "foo"
}

func CreateNewIdentity(name string) *Identity {
	k, _ := crypto.GenerateEd25519PrivateKey()
	m, _ := bip39.NewMnemonic(k.Bytes())
	return &Identity{
		PrivateKey:         k.String(),
		PrivateKeyMnemonic: m,
		PublicKey:          k.PublicKey().String(),
		Name:               name,
	}
}

func CreateNewIdentityString() string {
	k, _ := crypto.GenerateEd25519PrivateKey()
	m, _ := bip39.NewMnemonic(k.Bytes())
	id := Identity{
		PrivateKey:         k.String(),
		PrivateKeyMnemonic: m,
		PublicKey:          k.PublicKey().String(),
	}
	b, _ := json.Marshal(id)
	return string(b)
}

func ImportNewIdentityString(mnemonic string) (string, error) {
	mnemonicClean := mnemonic
	mnemonicClean = charRegex.ReplaceAllString(mnemonicClean, " ")
	mnemonicClean = spaceRegex.ReplaceAllString(mnemonicClean, " ")
	mnemonicClean = strings.TrimSpace(mnemonicClean)
	fmt.Println("...")
	fmt.Println("...")
	fmt.Println("...")
	fmt.Println("-", mnemonicClean)
	s, err := bip39.EntropyFromMnemonic(mnemonicClean)
	if err != nil {
		fmt.Println("!!!! ERR", err)
		fmt.Println("!!!! ERR", err)
		fmt.Println("!!!! ERR", err)
		fmt.Println("!!!! ERR", err)
		fmt.Println("!!!! ERR", err)
		return "error: " + err.Error(), err
	}
	k := crypto.NewPrivateKey(s)
	m, _ := bip39.NewMnemonic(k.Bytes())
	id := Identity{
		PrivateKey:         k.String(),
		PrivateKeyMnemonic: m,
		PublicKey:          k.PublicKey().String(),
	}
	b, _ := json.Marshal(id)
	return string(b), nil
}

var bs bool

func SignAuthorizationRequestString(key string, asr string) (string, error) {
	e, _ := crypto.GenerateEd25519PrivateKey()
	k := crypto.PrivateKey(key)
	keychain.Put(
		keychain.PrimaryPeerKey,
		e,
	)
	keychain.Put(
		keychain.IdentityKey,
		k,
	)
	// go func() {
	r := &peer.CertificateRequest{}
	m := map[string]interface{}{}
	if err := json.Unmarshal([]byte(asr), &m); err != nil {
		return "error: " + err.Error(), err
	}
	if err := r.FromObject(object.FromMap(m)); err != nil {
		return "error: " + err.Error(), err
	}

	c := peer.Certificate{
		Created: time.Now().Format(time.RFC3339),
		Expires: time.Now().Add(time.Hour * 24 * 365).Format(time.RFC3339),
		Owners:  keychain.ListPublicKeys(keychain.IdentityKey),
		Policy: object.Policy{
			Actions:   r.Actions,
			Effect:    "allow",
			Resources: r.Resources,
			Subjects: []string{
				r.Subject,
			},
		},
		Nonce: r.Nonce,
	}

	sig, _ := object.NewSignature(keychain.GetPrimaryPeerKey(), c.ToObject())
	c.Signatures = []object.Signature{sig}

	fmt.Println(">>> r", r)
	fmt.Println(">>> r.subject", r.Subject)
	fmt.Println(">>> key", key)

	// TODO remove, temp for tests
	// if r.Nonce == "" {
	// 	return "", fmt.Errorf("nonce missing")
	// }

	ctx := context.New()
	if !bs {
		if err := resolver.Bootstrap(ctx, []*peer.Peer{
			{
				Owners: []crypto.PublicKey{
					crypto.PublicKey("ed25519.Eq4y6LPB1cHX5pM8rgK9vbjFSt6e6hDW8rAwTu1TUaXW"),
				},
				Addresses: []string{
					"tcps:egan.bootstrap.nimona.io:21013",
				},
			}, {
				Owners: []crypto.PublicKey{
					crypto.PublicKey("ed25519.7GhQzPptXaBehoaq3DfcSfj1Z7X5tyjinEdx1R7mqfx8"),
				},
				Addresses: []string{
					"tcps:liu.bootstrap.nimona.io:21013",
				},
			}, {
				Owners: []crypto.PublicKey{
					crypto.PublicKey("ed25519.B6KNw8oyerJRpPKtHrf5YSCeBqELbAfWScxRLNdGbazG"),
				},
				Addresses: []string{
					"tcps:rajaniemi.bootstrap.nimona.io:21013",
				},
			},
		}...); err != nil {
			fmt.Println("> bootstrap error", err)
			return "error: " + err.Error(), err
		}
		bs = true
	}

	// return "", nil

	ps, err := resolver.Lookup(
		ctx,
		resolver.LookupByOwner(
			crypto.PublicKey(
				r.Subject,
			),
		),
	)
	if err != nil {
		fmt.Println("> lookup error", err)
		return "error: " + err.Error(), err
	}

	i := 0
	for p := range ps {
		i++
		fmt.Println(">>> found", p)
		if err := exchange.Send(
			ctx,
			c.ToObject(),
			p,
		); err != nil {
			fmt.Println("> send error", err)
			// return "error: "+err.Error(), err
		}
	}

	fmt.Println(">>> done", i)

	if i == 0 {
		return "", fmt.Errorf("sent to no one")
	}

	return "ok?", nil
}

type (
	// DataProcessor :
	DataProcessor struct {
		// add fields here
	}
)

// Increment : Increment the int received as an argument.
func (p *DataProcessor) Increment(data int) (int, error) {
	if data < 0 {
		// Return error if data is negative. This will
		// result exception in Android side.
		return data, errors.New("data can't be negative")
	}
	return (data + 1), nil
}
