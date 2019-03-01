#!/bin/sh

docker stop python-usd
docker rm python-usd -v
docker rmi python-usd