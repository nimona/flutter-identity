NAME = $(shell yq e '.name' pubspec.yaml)
VERSION = $(shell yq e '.version' pubspec.yaml)

CERT_NAME := LNCQ7FYZE7
APPLE_USERNAME := george@noodles.gr
APPLE_PASSWORD := @keychain:AC_PASSWORD

GOMOBILE_PKG := nimona.io/plugins/flutter
APP_PATH := $(CURDIR)

.PHONY: bump
bump:
	@cd ios; \
		fastlane run increment_build_number

.PHONE: bind-ios
bind-ios:
	cd go; gomobile bind -v -target ios \
		-o ${APP_PATH}/plugins/identity_mobile/ios/Frameworks/Mobileapi.framework \
		nimona.io/plugins/flutter

.PHONY: build-ios
build-ios:
	@echo "Building..."
	@flutter build ios --release --no-codesign
	@echo "All done!"

.PHONY: release-ios
release-ios:
	@echo "Building..."
	@flutter build ios --release --no-codesign
	@cd ios; fastlane beta
	@echo "All done!"

.PHONE: release-ios-verify
release-ios-verify:
	@xcrun altool \
		--username "$(APPLE_USERNAME)" \
		--password "$(APPLE_PASSWORD)" \
		--notarization-info $(REQ_ID)

.PHONY: build-macos
build-macos:
	@echo "Building $(VERSION)..."
	@hover build darwin-bundle
	@echo "Signing..."
	@codesign \
		-s "$(CERT_NAME)" \
		-fv \
		--entitlements entitlements.xml \
		--deep \
		--options runtime \
		--timestamp \
		./go/build/outputs/darwin-bundle-release/$(NAME)\ $(VERSION).app
	@rm -f ./artifacts/$(NAME)-$(VERSION).app.zip
	@echo "Zipping..."
	@ditto \
		-c \
		-k \
		--keepParent \
		./go/build/outputs/darwin-bundle-release/$(NAME)\ $(VERSION).app \
		./artifacts/$(NAME)-$(VERSION).app.zip
	@echo "Notarizing..."
	@xcrun altool \
		--notarize-app \
		--primary-bundle-id "io.nimona.$(NAME)" \
		--username "$(APPLE_USERNAME)" \
		--password "$(APPLE_PASSWORD)" \
		--file ./artifacts/$(NAME)-$(VERSION).app.zip
	@echo "All done!"
