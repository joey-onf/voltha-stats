#!/bin/bash

# https://registry.hub.docker.com/v1/repositories/$REPOSITORY/tags

REPOSITORY=openjdk # can be "<registry>/<image_name>" ("google/cloud-sdk" for example)
wget -q https://registry.hub.docker.com/v1/repositories/$REPOSITORY/tags -O - | \
    jq -r '.[].name'

