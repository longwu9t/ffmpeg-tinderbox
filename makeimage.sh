#!/bin/bash
set -xe
cd "$(dirname "$0")"
source util/vars.sh

export DOCKER_BUILDKIT=1

docker build --tag "$TARGET_IMAGE" "images/base-${TARGET}"

./generate.sh "$TARGET" "$VARIANT" "${ADDINS[@]}"

exec docker build --tag "$IMAGE" .
