#!/bin/sh

# This script builds a Docker image named 'fil-c-build' for Fil-C project development and compilation.
#
# Usage:
#   ./build_image_build_env.sh
#
# The Docker image provides a consistent build environment for working with the Fil-C project.
# For details about the environment, see the 'Dockerfile-build-env' file in this directory.
#
# After building, you can use the image to run builds or testing tasks inside a container.
docker build -t fil-c-build -f Dockerfile-build-env .
