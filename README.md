# Identity

## Development

* xcode (12.3 or higher)
* golang (v1.15 or higher)
* [flutter](https://flutter.dev/docs/get-started/install/macos) (dev channel)
* [hover](https://github.com/go-flutter-desktop/hover)

### Initial setup

```sh
git clone git@github.com:nimona/flutter-identity.git
cd flutter-identity
flutter clean
flutter channel dev
flutter upgrade --force
flutter doctor -v
```

### Running locally

* MacOS/Windows/Linux: `hover run`
* iOS: `flutter run -d <device>`

### Build

* Golang plugin: `make bind-ios`
* MacOS: `make build-macos`
* Windows: `hover build windows`
* Linux: `hover build linux`
* iOS: `make build-ios`

### Bump version

You will need to install `pubumgo` using `go get gitlab.com/ad-on-is/pubumgo`.
Then run `make bump` and commit the changes.

### Release

Releases are handled by github actions.
In order to bump the build numbers please use one of the following:

* `make bump-patch`
* `make bump-minor`
* `make bump-major`
