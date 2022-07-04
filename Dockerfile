# This docker container serves as a base with a compiled version
# of Pixar USD toolchain. This is a separate container as the USD
# tools take several hours to build and are not updated very frequently.
# PLATTAR uses this base for other open source projects such as the
# xrutils toolchain.
# For more info on USD tools, visit https://github.com/PixarAnimationStudios/USD
FROM python:3.9-slim-bullseye

LABEL MAINTAINER PLATTAR(www.plattar.com)

# our binary versions where applicable
ENV USD_VERSION="22.05b"

# Update the environment path for Pixar USD
ENV USD_BUILD_PATH="/usr/src/app/xrutils/usd"
ENV USD_PLUGIN_PATH="/usr/src/app/xrutils/usd/plugin/usd"
ENV USD_BIN_PATH="${USD_BUILD_PATH}/bin"
ENV USD_LIB_PATH="${USD_BUILD_PATH}/lib"
ENV PATH="${PATH}:${USD_BIN_PATH}"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${USD_LIB_PATH}"
ENV PYTHONPATH="${PYTHONPATH}:${USD_LIB_PATH}/python"

WORKDIR /usr/src/app

# Required for compiling the USD source
RUN apt-get update && apt-get install -y --no-install-recommends \
	git \
	build-essential \
	cmake \
	nasm \
	libxrandr-dev \
	libxcursor-dev \
	libxinerama-dev \
	libxi-dev && \
	# this is needed for generating usdGenSchema
	pip3 install -U Jinja2 argparse pillow numpy && \
	# Clone, setup and compile the Pixar USD Converter. This is required
	# for converting GLTF2->USDZ
	# More info @ https://github.com/PixarAnimationStudios/USD
	mkdir -p xrutils && \
	git clone --branch "v${USD_VERSION}" --depth 1 https://github.com/PixarAnimationStudios/USD.git usdsrc && \
	python3 usdsrc/build_scripts/build_usd.py --no-examples --no-tutorials --no-imaging --no-usdview --no-draco ${USD_BUILD_PATH} && \
	rm -rf usdsrc && \
	# remove build files we no longer need to save space
	rm -rf ${USD_BUILD_PATH}/build && \
	rm -rf ${USD_BUILD_PATH}/cmake && \
	rm -rf ${USD_BUILD_PATH}/pxrConfig.cmake && \
	rm -rf ${USD_BUILD_PATH}/share && \
	rm -rf ${USD_BUILD_PATH}/src