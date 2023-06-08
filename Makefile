cwd := $(shell pwd)
android_path := android
ios_path := ios
env_file := .env
get_last_version = $(shell git describe --tags $$(git rev-list --tags --max-count=1))

create_keystore:
	echo "keyAlias=upload" >> key.properties
	echo "storePassword=111111" >> key.properties
	echo "keyPassword=111111" >> key.properties
	echo "storePassword=111111" >> key.properties

deploy_android:
	cd $(cwd)/$(android_path); \
	$(call create_keystore)	\
	fastlane beta version:$(get_last_version);	\
	cd ..

deploy_ios:
	cd ${cwd}/${ios_path}; \
	fastlane beta version:$(get_last_version);	\
	cd ..

deploy_start:
	$(call deploy_android)	\
	$(call deploy_ios)