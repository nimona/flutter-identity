module nimona.io/plugins/flutter

go 1.14

require (
	github.com/davecgh/go-spew v1.1.1
	github.com/fsnotify/fsnotify v1.4.8 // indirect
	github.com/gen2brain/dlgs v0.0.0-20200211102745-b9c2664df42f // indirect
	github.com/geoah/go-nimona-notifier v1.7.0
	github.com/go-flutter-desktop/go-flutter v0.42.0
	github.com/go-flutter-desktop/plugins/path_provider v0.4.0
	github.com/go-flutter-desktop/plugins/shared_preferences v0.4.3
	github.com/go-flutter-desktop/plugins/url_launcher v0.1.2
	github.com/go-gl/glfw/v3.3/glfw v0.0.0-20201108214237-06ea97f0c265
	github.com/gopherjs/gopherjs v0.0.0-20200217142428-fce0ec30dd00 // indirect
	github.com/gorilla/websocket v1.4.2
	github.com/jinzhu/gorm v1.9.12
	github.com/miguelpruivo/flutter_file_picker/go v0.0.0-20200324175432-e35b6aae601f
	github.com/nfnt/resize v0.0.0-20180221191011-83c6a9932646
	github.com/oliamb/cutter v0.2.2
	github.com/onsi/ginkgo v1.12.0 // indirect
	github.com/onsi/gomega v1.9.0 // indirect
	github.com/pkg/errors v0.9.1
	github.com/pkg/profile v1.4.0
	github.com/stretchr/testify v1.6.1
	github.com/tjarratt/babble v0.0.0-20191209142150-eecdf8c2339d
	github.com/tsdtsdtsd/identicon v0.3.2
	github.com/tyler-smith/go-bip39 v1.0.2
	github.com/zserge/metric v0.1.0
	golang.org/x/mobile v0.0.0-20200329125638-4c31acba0007 // indirect
	gopkg.in/fsnotify.v1 v1.4.7
	nimona.io v0.7.1-0.20200419003157-0e2e2b086ca5
)

// replace github.com/go-flutter-desktop/go-flutter => github.com/geoah/go-flutter v0.36.1-0.20200329185504-b6357ad7bb8d

// replace github.com/zserge/metric => ../../metric

// replace nimona.io => ../../../../nimona.io

// replace github.com/go-flutter-desktop/go-flutter => ../../go-flutter

// replace github.com/geoah/go-nimona-notifier => ../../go-nimona-notifier
