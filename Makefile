cwd := $(shell pwd)
android_path := android
keystore_path := $(cwd)/$(android_path)/app/keystore
ios_path := ios
env_file := .env
get_last_version := $(shell git describe --tags $$(git rev-list --tags --max-count=1))

create_keystore:
	rm -rf $(keystore_path)/key.properties
	echo "debugStoreFile=./keystore/debug.keystore" >> $(keystore_path)/key.properties
	echo "releaseStoreFile=./keystore/release.keystore" >> $(keystore_path)/key.properties
	echo "debugKeyAlias=debug-keystore" >> $(keystore_path)/key.properties
	echo "releaseKeyAlias=release-keystore" >> $(keystore_path)/key.properties
	echo "keyPassword=111111" >> $(keystore_path)/key.properties
	echo "storePassword=111111" >> $(keystore_path)/key.properties

deploy_android: create_keystore
	cd $(cwd)/$(android_path) && \
	fastlane beta version:$(get_last_version)

deploy_ios:
	cd $(ios_path) && \
	fastlane beta version:$(get_last_version)

deploy_start: deploy_android deploy_ios