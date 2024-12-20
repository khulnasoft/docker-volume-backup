#!/bin/sh

set -e

cd "$(dirname "$0")"
. ../util.sh
current_test=$(basename $(pwd))

export LOCAL_DIR=$(mktemp -d)

export BASE_VERSION="${TEST_VERSION:-canary}"
export TEST_VERSION="${TEST_VERSION:-canary}-with-rsync"

docker build . -t khulnasoft/docker-volume-backup:$TEST_VERSION --build-arg version=$BASE_VERSION

docker compose up -d --quiet-pull
sleep 5

docker compose exec backup backup

sleep 5

expect_running_containers "2"

if [ ! -f "$LOCAL_DIR/app_data/khulnasoft.db" ]; then
  fail "Could not find expected file in untared archive."
fi
