package main

import (
	"fmt"

	flutter "github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/go-flutter/plugin"
	nimonaFlutter "nimona.io/plugins/flutter"
)

func init() {
	options = append(options, flutter.AddPlugin(&NimonaFlutter{}))
}

const channelName = "identity_mobile"

type NimonaFlutter struct {
	codec plugin.StandardMessageCodec
}

func (p *NimonaFlutter) InitPlugin(messenger plugin.BinaryMessenger) error {
	channel := plugin.NewMethodChannel(messenger, channelName, plugin.StandardMethodCodec{})
	channel.HandleFunc("createNewIdentityString", p.handleCreateNewIdentity)
	channel.HandleFunc("importNewIdentityString", p.handleImportNewIdentity)
	// go func() {
	// 	i := 1
	// 	for {
	// 		time.Sleep(time.Second)
	// 		channel.InvokeMethod("foo", strconv.Itoa(i))
	// 		i++
	// 	}
	// }()
	return nil
}

func (p *NimonaFlutter) handleCreateNewIdentity(arguments interface{}) (reply interface{}, err error) {
	return nimonaFlutter.CreateNewIdentityString(), nil
}

func (p *NimonaFlutter) handleImportNewIdentity(arguments interface{}) (reply interface{}, err error) {
	argStrings, ok := arguments.([]interface{})
	if !ok {
		return nil, fmt.Errorf("incorrect argument")
	}
	if len(argStrings) == 0 {
		return nil, fmt.Errorf("incorrect number of arguments")
	}
	mnemonic, ok := argStrings[0].(string)
	if !ok {
		return nil, fmt.Errorf("incorrect mnemonic type")
	}
	id, err := nimonaFlutter.ImportNewIdentityString(mnemonic)
	if err != nil {
		return nil, err
	}
	return id, nil
}
