keystore_path="$(pwd)/android/app/keystore"
env_file_path="$(pwd)/.env"
get_last_version=$(git describe --tags $(git rev-list --tags --max-count=1))
bot_name="앱 배포 알림봇"
msg1="도달의 새로운 버전이 심사를 기다리고 있습니다"
msg2="심사에는 1~3일정도가 소요됩니다!"

create_keystore () {
    rm -rf "$keystore_path/key.properties"
    touch "$keystore_path/key.properties"

    echo "debugKeystore=./keystore/debug.keystore" >> "$keystore_path/key.properties"
    echo "uploadKeystore=./keystore/upload-keystore.jks" >> "$keystore_path/key.properties"
    echo "debugKeyAlias=debug-keystore" >> "$keystore_path/key.properties"
    echo "uploadKeyAlias=upload-keystore" >> "$keystore_path/key.properties"
    echo "keyPassword=$KEY_PASSWORD" >> "$keystore_path/key.properties"
    echo "storePassword=$STORE_PASSWORD" >> "$keystore_path/key.properties"
}

deploy_android () {
    source $env_file_path &&
    create_keystore &&
    cd $(pwd)/android &&
    fastlane release version:$get_last_version &&
    cd .. &&
    curl -H "Content-Type: application/json" \
         -d "{\"username\": \"$bot_name\", \"content\": \"**$msg1**\n> 대상: 안드로이드\n$msg2\"}" \
         "$DISCORD_URL"
}

deploy_ios () {
    source $env_file_path &&
    cd $(pwd)/ios &&
    fastlane release version:$get_last_version password:$KEY_PASSWORD &&
    cd .. &&
    curl -H "Content-Type: application/json" \
         -d "{\"username\": \"$bot_name\", \"content\": \"**$msg1**\n> 대상: IOS\n$msg2\"}" \
         "$DISCORD_URL"
}

increment_version() {
    local current_version=$1

    # 정규표현식을 사용하여 major, minor, patch를 추출
    regex="([0-9]+)\.([0-9]+)\.([0-9]+)"
    if [[ $current_version =~ $regex ]]; then
        local major="${BASH_REMATCH[1]}"
        local minor="${BASH_REMATCH[2]}"
        local patch="${BASH_REMATCH[3]}"
    else
        echo "올바른 버전 형식이 아닙니다."
        exit 1
    fi

    patch=$((patch + 1))

    local new_version="$major.$minor.$patch"
    git tag "$new_version"
    git push origin --tags
}

PLATFORM=$1
case "$PLATFORM" in
    "android")
    cp .env.production .env
    deploy_android
    cp .env.development .env
    ;;
    "ios")
    cp .env.production .env
    deploy_ios
    cp .env.development .env
    ;;
    "start")
    cp .env.production .env
    deploy_android
    deploy_ios
    increment_version "$git_last_version"
    cp .env.development .env
    ;;
esac