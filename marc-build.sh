docker buildx build --push --tag plattar/python-usd:version-$1 --platform linux/amd64,linux/arm64 --file Dockerfile .