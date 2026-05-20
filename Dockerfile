# syntax=docker/dockerfile:1.7

# Base Docker Image with Compiled Pixar OpenUSD Toolchain
#
# This Docker image serves as a base with a precompiled version
# of the Pixar OpenUSD toolchain. It is a separate image because
# USD tools take a significant amount of time to build and
# are not updated frequently. PLATTAR uses this base for various
# open-source projects, including the xrutils toolchain.
#
# For more information on OpenUSD, visit https://github.com/PixarAnimationStudios/OpenUSD
ARG PYTHON_BASE=python:3.12-slim-trixie
FROM ${PYTHON_BASE}

LABEL org.opencontainers.image.source="https://github.com/Plattar/python-usd"
LABEL org.opencontainers.image.description="Pre-built Pixar OpenUSD toolchain"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="Plattar"

# OpenUSD version to build. Override at build time with --build-arg USD_VERSION=26.05
ARG USD_VERSION=26.05
ENV USD_VERSION=${USD_VERSION}

# Update the environment path for Pixar OpenUSD
ENV USD_BUILD_PATH=/usr/src/app/xrutils/usd
ENV USD_PLUGIN_PATH=${USD_BUILD_PATH}/plugin/usd
ENV USD_BIN_PATH=${USD_BUILD_PATH}/bin
ENV USD_LIB_PATH=${USD_BUILD_PATH}/lib
ENV PATH=${PATH}:${USD_BIN_PATH}
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${USD_LIB_PATH}
ENV PYTHONPATH=${PYTHONPATH}:${USD_LIB_PATH}/python

WORKDIR /usr/src/app

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		git \
		ca-certificates \
		build-essential \
		cmake \
		nasm \
		libxrandr-dev \
		libxcursor-dev \
		libxinerama-dev \
		libxi-dev; \
	rm -rf /var/lib/apt/lists/*; \
	# Needed for generating usdGenSchema and numpy bindings used by pxr.Vt etc.
	pip3 install --no-cache-dir --upgrade Jinja2 numpy; \
	mkdir -p xrutils; \
	git clone --branch "v${USD_VERSION}" --depth 1 https://github.com/PixarAnimationStudios/OpenUSD.git usdsrc; \
	python3 usdsrc/build_scripts/build_usd.py \
		--no-examples \
		--no-tutorials \
		--no-imaging \
		--no-usdview \
		--no-draco \
		--no-materialx \
		${USD_BUILD_PATH}; \
	rm -rf usdsrc; \
	# Drop intermediate artifacts to keep the layer small
	rm -rf \
		${USD_BUILD_PATH}/build \
		${USD_BUILD_PATH}/cmake \
		${USD_BUILD_PATH}/pxrConfig.cmake \
		${USD_BUILD_PATH}/share \
		${USD_BUILD_PATH}/src; \
	# Strip build-only OS packages; consumers can reinstall when extending this image
	apt-get purge -y \
		git \
		build-essential \
		cmake \
		nasm \
		libxrandr-dev \
		libxcursor-dev \
		libxinerama-dev \
		libxi-dev; \
	apt-get autoremove -y; \
	apt-get autoclean -y; \
	rm -rf /var/lib/apt/lists/*
