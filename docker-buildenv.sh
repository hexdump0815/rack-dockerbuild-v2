#!/bin/bash

cd docker-bookworm
docker build --no-cache -t vcvrack-buildenv-v2-bookworm .
