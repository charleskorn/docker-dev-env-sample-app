#!/usr/bin/env bash

set -e

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GRADLE_CACHE_DIR=$SOURCE_DIR/_caches/gradle

# Create an image name based on the source directory so we know we're referring to the one that applies to this codebase
IMAGE_NAME=`echo "dev-env${SOURCE_DIR//\//-}" | awk '{print tolower($0)}'`
IMAGE_TAG="$IMAGE_NAME:latest"

function main {
  checkForDocker
  buildImage
  createCacheDirectories

  COMMAND=${@:-./gradlew build}
  runCommandInContainer $COMMAND
}

function checkForDocker {
  hash docker 2>/dev/null || { echo >&2 "This script requires Docker, but it's not installed or not on your PATH."; exit 1; }
}

function buildImage {
  echoWhiteText "Building development environment container image..."
  docker build --tag "$IMAGE_TAG" "$SOURCE_DIR/dev-env"
}

function createCacheDirectories {
  mkdir -p "$GRADLE_CACHE_DIR"
}

function runCommandInContainer {
  echoWhiteText "Running '$@' in container..."

  docker run --rm -it \
    -w /code \
    -v $SOURCE_DIR:/code \
    -v $GRADLE_CACHE_DIR:/root/.gradle \
    -e GRADLE_OPTS="-Dorg.gradle.daemon=false" \
    "$IMAGE_TAG" \
    $@
}

function echoWhiteText {
  RESET=$(tput sgr0)
  WHITE=$(tput setaf 7)

  echo "${WHITE}${@}${RESET}"
}

main "$@"
