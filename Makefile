cwd := $(shell pwd)
android_path := android
keystore_path := $(cwd)/$(android_path)/app/keystore
ios_path := ios
env_file := .env
get_last_version := $(shell git describe --tags $$(git rev-list --tags --max-count=1))
discord_channel := https://discord.com/api/webhooks/1115207690604523551/73M_d0AL1shoM_Pc6TmrlcN6-ZpVTwHOajkzGDm_17CG_cUcJNYt41LqsJ9FGWNHyFWW
bot_name := 앱 배포 알림봇
msg1 := 도달의 새로운 버전이 배포되었습니다
msg2 := 배포되는데 시간이 조금 걸릴수 있어 10분정도 뒤에 테스트해보세요!
play_store_address := https://play.google.com/apps/internaltest/4701572138827796274

get_debug_keystore:
	keytool -exportcert -alias debug-keystore -keystore ./android/app/keystore/debug.keystore | openssl sha1 -binary | openssl base64

get_release_keystore: 
	keytool -exportcert -alias release-keystore -keystore ./android/app/keystore/release.keystore | openssl sha1 -binary | openssl base64

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
	fastlane beta version:$(get_last_version) && \
	source $(cwd)/deploy.history && \
	curl \
  	-H "Content-Type: application/json" \
  	-d '{"username": "$(bot_name)", "content": "**$(msg1)**\n> 대상: 안드로이드\n> 버전: $(get_last_version)\n> 빌드 넘버: '$$ANDROID_BUILD_NUMBER'\n> $(play_store_address)\n$(msg2)"}' \
  	$(discord_channel) && \
	rm $(cwd)/deploy.history

deploy_ios:
	cd $(ios_path) && \
	fastlane beta version:$(get_last_version) && \
	source $(cwd)/deploy.history && \
	curl \
  	-H "Content-Type: application/json" \
  	-d '{"username": "$(bot_name)", "content": "**$(msg1)**\n> 대상: IOS\n> 버전: $(get_last_version)\n> 빌드 넘버: '$$IOS_BUILD_NUMBER'\n$(msg2)"}' \
  	$(discord_channel) && \
	rm $(cwd)/deploy.history
	
deploy_start: deploy_android deploy_ios