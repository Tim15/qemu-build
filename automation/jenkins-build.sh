#!/bin/bash
set -e
set -o pipefail

if [ -z "$isPrivate" ]; then
	CURL_COMMAND="curl -SL https://codeload.github.com/$ACCOUNT/$REPO/tar.gz/v\$QEMU_VERSION -o qemu-\$QEMU_VERSION.tar.gz"
else
	CURL_COMMAND="curl -SL --user $DEV_ACCOUNT:$ACCESS_TOKEN  https://codeload.github.com/$ACCOUNT/$REPO/tar.gz/v\$QEMU_VERSION -o qemu-\$QEMU_VERSION.tar.gz"
fi

sed -e s~#{QEMU_VERSION}~"$QEMU_VERSION"~g \
	-e s~#{QEMU_SHA256}~"$QEMU_SHA256"~g \
	-e s~#{CURL_COMMAND}~"$CURL_COMMAND"~g Dockerfile.tpl > Dockerfile

docker build -t qemu-builder .

docker run --rm -e ACCOUNT=$ACCOUNT \
				-e REPO=$REPO \
				-e ACCESS_TOKEN=$ACCESS_TOKEN \
				-e TARGET=$TARGET \
				-e sourceBranch=$sourceBranch qemu-builder 
