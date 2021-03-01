#!/bin/bash

set -ex
export DOCKER_BUILDKIT=1

./script/clean

DOCKER_COMPOSE_GITSHA="$(script/build/write-git-sha)"
docker build . \
    --target bin \
    --build-arg DISTRO=debian \
    --build-arg GIT_COMMIT="${DOCKER_COMPOSE_GITSHA}" \
    --build-arg TARGETOS="linux" \
    --build-arg TARGETARCH="arm64v8" \
    --output dist/
