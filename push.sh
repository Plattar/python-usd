#!/bin/sh

# push a local build into dockerhub
docker tag plattar/python-usd:latest plattar/python-usd:$1
docker push plattar/python-usd:$1

# revert for future use
docker tag plattar/python-usd:$1 plattar/python-usd:latest