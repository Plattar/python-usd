# Base Docker Image with Compiled Pixar USD Toolchain

# This Docker image serves as a base with a precompiled version
# of the Pixar USD toolchain. It is a separate image because
# USD tools take a significant amount of time to build and
# are not updated frequently. PLATTAR uses this base for various
# open-source projects, including the xrutils toolchain.

# For more information on USD tools, visit https://github.com/PixarAnimationStudios/USD
FROM python:3.10-slim-bookworm

LABEL MAINTAINER PLATTAR(www.plattar.com)

# our binary versions where applicable
ENV USD_VERSION="23.11"

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
	rm -rf /var/lib/apt/lists/* && \
	# this is needed for generating usdGenSchema
	pip3 install -U Jinja2 argparse pillow numpy && \
	# Clone, setup and compile the Pixar USD Converter. This is required
	# for converting GLTF2->USDZ
	# More info @ https://github.com/PixarAnimationStudios/USD
	mkdir -p xrutils && \
	git clone --branch "v${USD_VERSION}" --depth 1 https://github.com/PixarAnimationStudios/USD.git usdsrc && \
	python3 usdsrc/build_scripts/build_usd.py --no-examples --no-tutorials --no-imaging --no-usdview --no-draco --no-materialx ${USD_BUILD_PATH} && \
	rm -rf usdsrc && \
	# remove build files we no longer need to save space
	rm -rf ${USD_BUILD_PATH}/build && \
	rm -rf ${USD_BUILD_PATH}/cmake && \
	rm -rf ${USD_BUILD_PATH}/pxrConfig.cmake && \
	rm -rf ${USD_BUILD_PATH}/share && \
	rm -rf ${USD_BUILD_PATH}/src && \
	# remove packages we no longer need/require
	# this keeps the container as small as possible
	# if others need them, they can install when extending
	apt-get purge -y git \
	build-essential \
	cmake \
	nasm \
	libxrandr-dev \
	libxinerama-dev \
	libxi-dev && \
	apt autoremove -y && \
	apt-get autoclean -y