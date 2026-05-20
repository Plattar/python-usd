#!/bin/sh

# Local multi-arch build helper. Usage: ./marc-build.sh <usd-version>
# Publishes to ghcr.io/plattar/python-usd. Requires `docker login ghcr.io` first.

set -eu

if [ "$#" -ne 1 ]; then
	echo "usage: $0 <usd-version>" >&2
	exit 1
fi

USD_VERSION="$1"
IMAGE="ghcr.io/plattar/python-usd:version-${USD_VERSION}"

docker buildx create --name python-usd-buildx --use 2>/dev/null || docker buildx use python-usd-buildx
docker buildx build \
	--push \
	--tag "${IMAGE}" \
	--build-arg "USD_VERSION=${USD_VERSION}" \
	--platform linux/amd64,linux/arm64 \
	--file Dockerfile .
