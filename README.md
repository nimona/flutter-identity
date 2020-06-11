# Identity

## Development

The websocket datastore you will to run it using `hover`.
For this you'll need a couple of things.

* xcode, git
* golang (v1.14)
* [flutter](https://flutter.dev/docs/get-started/install/macos) (master channel)
* [hover](https://github.com/go-flutter-desktop/hover)

```sh
git clone git@github.com:nimona/flutter-identity.git
cd flutter-identity
flutter clean
flutter channel beta
flutter upgrade --force
flutter doctor
```

```sh
LOG_LEVEL=debug hover run
```