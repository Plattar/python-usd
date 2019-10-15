# This docker container serves as a base with a compiled version
# of Pixar USD toolchain. This is a separate container as the USD
# tools take several hours to build and are not updated very frequently.
# PLATTAR uses this base for other open source projects such as the
# xrutils toolchain.
# For more info on USD tools, visit https://github.com/PixarAnimationStudios/USD
FROM python:2.7.16-buster

# our binary versions where applicable
ENV USD_VERSION 18.11

WORKDIR /usr/src/app

# Required for compiling the USD source
RUN apt-get update && apt-get install -y \
	git \
	g++ \
	gcc \
	make \
	cmake \
	doxygen \
	graphviz

# Clone, setup and compile the Pixar USD Converter. This is required
# for converting GLTF2->USDZ
# More info @ https://github.com/PixarAnimationStudios/USD
RUN mkdir xrutils && \
	git clone https://github.com/PixarAnimationStudios/USD && \
	cd USD && git checkout tags/v${USD_VERSION} && cd ../ && \
	python USD/build_scripts/build_usd.py --build-args TBB,extra_inc=big_iron.inc --python --no-imaging --docs --no-usdview --build-monolithic xrutils/USDPython && \
	rm -rf USD