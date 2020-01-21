#!/bin/sh

# Nukes all built docker images
docker stop plattar-usd
docker rm -v plattar-usd
docker rmi plattar/python-usd:latest --force