# This docker container serves as a base with a compiled version
# of Pixar USD toolchain. This is a separate container as the USD
# tools take several hours to build and are not updated very frequently.
# PLATTAR uses this base for other open source projects such as the
# xrutils toolchain.
# For more info on USD tools, visit https://github.com/PixarAnimationStudios/USD
FROM lambci/lambda:build-python3.8

LABEL MAINTAINER PLATTAR(www.plattar.com)

# our binary versions where applicable
ENV USD_VERSION="20.08"

# Update the environment path
ENV USD_BUILD_PATH="/usr/src/app/xrutils/usd"
ENV USD_BIN_PATH="${USD_BUILD_PATH}/bin"
ENV USD_LIB_PATH="${USD_BUILD_PATH}/lib"
ENV PATH="${PATH}:${USD_BIN_PATH}"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${USD_LIB_PATH}"
ENV PYTHONPATH="${PYTHONPATH}:${USD_LIB_PATH}/python"

WORKDIR /usr/src/app

# Required for compiling the USD source
RUN yum update -y && yum install -y \
	git \
	build-essential \
	cmake \
	nasm \
	libglew-dev \
	libxrandr-dev \
	libxcursor-dev \
	libxinerama-dev \
	libxi-dev \
	zlib1g-dev

RUN rm -rf /var/lib/apt/lists/*
# Clone, setup and compile the Pixar USD Converter. This is required
# for converting GLTF2->USDZ
# More info @ https://github.com/PixarAnimationStudios/USD
RUN mkdir xrutils && \
	git clone https://github.com/PixarAnimationStudios/USD usdsrc && \
	cd usdsrc && git checkout tags/v${USD_VERSION} && cd ../ && \
	python usdsrc/build_scripts/build_usd.py -v --no-usdview ${USD_BUILD_PATH} && \
	rm -rf usdsrc && \
	# remove build files we no longer need to save space
	rm -rf ${USD_BUILD_PATH}/build && \
	rm -rf ${USD_BUILD_PATH}/cmake && \
	rm -rf ${USD_BUILD_PATH}/pxrConfig.cmake && \
	rm -rf ${USD_BUILD_PATH}/share && \
	rm -rf ${USD_BUILD_PATH}/src
# remove packages we no longer need/require
# this keeps the container as small as possible
# if others need them, they can install when extending
RUN yum purge -y git \
	build-essential \
	cmake \
	nasm \
	libglew-dev \
	libxrandr-dev \
	libxinerama-dev \
	libxi-dev \
	zlib1g-dev && \
	apt autoremove -y && \
	yum autoclean -y