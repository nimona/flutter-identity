package mobileapi

import (
	"encoding/json"
	"errors"
	"fmt"

	bip39 "github.com/tyler-smith/go-bip39"

	"nimona.io/pkg/crypto"
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
	fmt.Println(">>> !!!!!!!")
	k, _ := crypto.GenerateEd25519PrivateKey()
	m, _ := bip39.NewMnemonic(k.Bytes())
	id := Identity{
		PrivateKey:         k.String(),
		PrivateKeyMnemonic: m,
		PublicKey:          k.PublicKey().String(),
		// Name:               name,
	}
	b, _ := json.Marshal(id)
	return string(b)
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
