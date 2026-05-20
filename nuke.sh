#!/bin/sh

# Nukes the local python-usd container and image
docker stop plattar-usd 2>/dev/null || true
docker rm -v plattar-usd 2>/dev/null || true
docker rmi ghcr.io/plattar/python-usd:latest --force
