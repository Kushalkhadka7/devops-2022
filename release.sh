#!/bin/bash

set -e

apps=$(git diff --name-only | sort -u | grep -oP "apps\/.+?\/" | cat | uniq)

APP_DOCKER_REGISTRY="crkushal7"

if (( ${#apps[@]} != 0 )); then
  printf "Building docker images...\n$apps"

  for app in $apps; do
    app_name=${app/apps\//}
    app_name=${app_name::-1}

    printf "Building docker image: $app_name\n"

    git fetch --tags
    last_image_tag=$(git tag --sort=-version:refname | grep -P "^$app_name@\d+.\d+.\d+$" | head -n 1)

    last_version=${last_image_tag#*@}

    if [ -z "$last_version" ]; then
      new_app_version="1.0.0"
    else
      new_app_version=$(semver bump release "$last_version")
      new_app_version=$(semver bump patch "$last_version")
    fi

    printf "New image version: $new_app_version\n"

    github_tag="$app_name@$new_app_version"
    image_tag="$APP_DOCKER_REGISTRY/$app_name:$new_app_version"

    printf "New image tag: $github_tab\n"
    printf "New image: $image_tag\n"

    docker build -t $image_tag --target dev $app


    git tag -a $github_tag -m "my version 1.4"

    git push origin --tags

    docker login -u "crkushal7" -p "d45444eb-d5d9-4025-a482-d7482517e55a"

    docker push $image_tag
    printf "Successfully build docker images...\n"
  done
else
  printf "Skipping no changes detected...\n"
fi
