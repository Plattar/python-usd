[![Twitter: @plattarglobal](https://img.shields.io/badge/contact-@plattarglobal-blue.svg?style=flat)](https://twitter.com/plattarglobal)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat)](LICENSE)

_Python USD_ is a Docker container that contains a pre-built version of the [Pixar OpenUSD](https://github.com/PixarAnimationStudios/OpenUSD) toolchain. Because building USD takes a significant amount of time, this container serves as a useful base image for other applications.

Pre-built images are published to the GitHub Container Registry: [`ghcr.io/plattar/python-usd`](https://github.com/Plattar/python-usd/pkgs/container/python-usd). Multi-arch manifests are produced for both `linux/amd64` and `linux/arm64`.

```sh
docker pull ghcr.io/plattar/python-usd:latest
# or pin a specific OpenUSD version
docker pull ghcr.io/plattar/python-usd:26.05
```

Looking for the _Python USD AR_ images with Apple USDZ Schema Definitions? Check out the [python-usd-ar](https://github.com/Plattar/python-usd-ar) repository.

### Building a new release

Builds are produced by `.github/workflows/publish.yml`. There are two ways to trigger a build:

1. **Manual dispatch** — run the workflow from the Actions tab and supply an `usd_version` (e.g. `26.05`). Optionally override `image_tag` or tick `tag_latest`. This is the recommended path for ad-hoc and future-version builds.
2. **Git tag** — pushing a tag (e.g. `git tag 26.05 && git push origin 26.05`) triggers a build that uses the tag name as both the OpenUSD version and the image tag, and also publishes `:latest`.

### Acknowledgements

This tool relies on the following open source projects.

-   [Pixar OpenUSD](https://github.com/PixarAnimationStudios/OpenUSD)
