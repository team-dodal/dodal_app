keystore_path="$(pwd)/android/app/keystore"
env_file_path="$(pwd)/.env"
get_last_version=$(git describe --tags $(git rev-list --tags --max-count=1))
bot_name="앱 배포 알림봇"
msg1="도달의 새로운 버전이 배포되었습니다"
msg2="배포되는데 시간이 조금 걸릴수 있어 10분정도 뒤에 테스트해보세요!"

create_keystore () {
    rm -rf "$keystore_path/key.properties"
    touch "$keystore_path/key.properties"

    echo "debugStoreFile=./keystore/debug.keystore" >> "$keystore_path/key.properties"
    echo "releaseStoreFile=./keystore/release.keystore" >> "$keystore_path/key.properties"
    echo "debugKeyAlias=debug-keystore" >> "$keystore_path/key.properties"
    echo "releaseKeyAlias=release-keystore" >> "$keystore_path/key.properties"
    echo "keyPassword=$KEY_PASSWORD" >> "$keystore_path/key.properties"
    echo "storePassword=$STORE_PASSWORD" >> "$keystore_path/key.properties"
}

deploy_android () {
    source $env_file_path
    create_keystore
    cd $(pwd)/android
    fastlane beta version:$get_last_version
    cd ..
    source $(pwd)/deploy.history
    curl -H "Content-Type: application/json" \
         -d "{\"username\": \"$bot_name\", \"content\": \"**$msg1**\n> 대상: 안드로이드\n> 버전: $get_last_version\n> 빌드 넘버: $ANDROID_BUILD_NUMBER\n> $PLAY_STORE_ADDRESS\n$msg2\"}" \
         "$DISCORD_URL"
    rm $(pwd)/deploy.history
}

deploy_ios () {
    source $env_file_path
    cd $(pwd)/ios
    fastlane beta version:$get_last_version password:$KEY_PASSWORD
    cd ..
    curl -H "Content-Type: application/json" \
         -d "{\"username\": \"$bot_name\", \"content\": \"**$msg1**\n> 대상: IOS\n> 버전: $get_last_version\n> 빌드 넘버: $build_number\n$msg2\"}" \
         "$DISCORD_URL"
    rm $(pwd)/deploy.history
}

PLATFORM=$1
case "$PLATFORM" in
    "android")
    deploy_android
    ;;
    "ios")
    deploy_ios
    ;;
    "start")
    deploy_android
    deploy_ios
    ;;
esac