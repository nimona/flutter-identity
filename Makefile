VERSION = $(shell yq r pubspec.yaml 'version')

CERT_NAME := Developer ID Application: George Antoniadis (LNCQ7FYZE7)
APPLE_USERNAME := george@noodles.gr
APPLE_PASSWORD := @keychain:AC_PASSWORD

GOMOBILE_PKG := identity.io
APP_PATH := $(CURDIR)

.PHONY: beta
beta:
	@echo "Building $(VERSION)..."
	@flutter build ios --release --no-codesign
	@cd ios; fastlane beta
	@echo "All done!"

.PHONY: release
release:
	@echo "Building $(VERSION)..."
	@flutter build ios --release --no-codesign
	@cd ios; fastlane release
	@echo "All done!"

.PHONE: build-verify
build-verify:
	@xcrun altool \
		--username "$(APPLE_USERNAME)" \
		--password "$(APPLE_PASSWORD)" \
		--notarization-info $(REQ_ID)

.PHONE: bind-ios
bind-ios:
	cd go; gomobile bind -v -target ios \
		-o ${APP_PATH}/plugins/identity_mobile/ios/Frameworks/Mobileapi.framework \
		identity.io/mobile