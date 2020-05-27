package mobileapi

import (
	"encoding/json"
	"errors"
	"fmt"
	"regexp"
	"strings"

	bip39 "github.com/tyler-smith/go-bip39"

	"nimona.io/pkg/crypto"
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
		return "", err
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
