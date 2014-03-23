.PHONY: build clean uninstall install launch

PRODUCT_NAME=Cutter
APP_DIR=$$(pwd)
APP_BUILD_DIR=../build/Release
APP_INSTALL_DIR=/Applications
BUILD_TYPE=Deployment

build:
	cd $(APP_DIR)
	xcodebuild -project ../Cutter.xcodeproj -target Cutter -configuration ${BUILD_TYPE} clean build

clean:
	rm -rf $(APP_DIR)/build/UninstalledProducts

install: build
	cp -r $(APP_BUILD_DIR)/$(PRODUCT_NAME).app $(APP_INSTALL_DIR)

launch:
	open $(APP_INSTALL_DIR)/$(PRODUCT_NAME).app

uninstall:
	osascript -e 'tell application "$(PRODUCT_NAME)"' -e 'quit' -e 'end tell'
	rm -rf /Applications/$(PRODUCT_NAME).app
