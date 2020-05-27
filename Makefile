VERSION = $(shell yq r pubspec.yaml 'version')

CERT_NAME := Developer ID Application: George Antoniadis (LNCQ7FYZE7)
APPLE_USERNAME := george@noodles.gr
APPLE_PASSWORD := @keychain:AC_PASSWORD

GOMOBILE_PKG := identity.io
APP_PATH := $(CURDIR)

.PHONY: build
build:
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
		./go/build/outputs/darwin-bundle/identity-$(VERSION).app
	@rm -f ./artifacts/identity-$(VERSION).app.zip
	@echo "Zipping..."
	@ditto \
		-c \
		-k \
		--keepParent \
		./go/build/outputs/darwin-bundle/identity-$(VERSION).app \
		./artifacts/identity-$(VERSION).app.zip
	@echo "Notarizing..."
	@xcrun altool \
		--notarize-app \
		--primary-bundle-id "io.nimona.identity" \
		--username "$(APPLE_USERNAME)" \
		--password "$(APPLE_PASSWORD)" \
		--file ./artifacts/identity-$(VERSION).app.zip
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