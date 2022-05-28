#!/bin/sh

# push a local build into dockerhub
docker tag plattar/python-usd:latest plattar/python-usd:version-$1-slim-buster
docker push plattar/python-usd:version-$1-slim-buster

# revert for future use
docker tag plattar/python-usd:version-$1-slim-buster plattar/python-usd:latest