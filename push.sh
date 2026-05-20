#!/bin/sh

# Push a local build to GHCR. Usage: ./push.sh <usd-version>
# Requires `docker login ghcr.io` first.

set -eu

if [ "$#" -ne 1 ]; then
	echo "usage: $0 <usd-version>" >&2
	exit 1
fi

USD_VERSION="$1"
IMAGE="ghcr.io/plattar/python-usd"

docker tag "${IMAGE}:latest" "${IMAGE}:version-${USD_VERSION}"
docker push "${IMAGE}:version-${USD_VERSION}"
docker tag  "${IMAGE}:version-${USD_VERSION}" "${IMAGE}:latest"
