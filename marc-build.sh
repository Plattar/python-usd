docker buildx create --name python-usd-buildx
docker buildx use python-usd-buildx
docker buildx build --push --tag plattar/python-usd:version-$1-slim-bookworm --platform linux/amd64,linux/arm64 --file Dockerfile .