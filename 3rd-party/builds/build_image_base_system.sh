#!/bin/sh

# This script builds a Docker image named 'fil-c-base-system' containing a base system
# with essential programs (Coreutils, Binutils, Bash, curl, etc.) compiled using Fil-C.
#
# Usage:
#   ./build_image_base_system.sh
#
# The resulting Docker image provides a minimal environment with key utilities built by Fil-C.
# For details about the image contents and build process, see the 'Dockerfile-base-system'.
#
# Steps to build and use the base system container:
#
# 1. Build the Fil-C build environment image:
#      ./build_image_build_env.sh
# 2. Enter the build environment container:
#      ./enter_container_build_env.sh
# 3. Inside the container, build all components:
#      cd /opt/fil-c
#      ./build_all.sh
# 4. Exit the build environment container.
# 5. Build the base system image (this script):
#      ./build_image_base_system.sh
# 6. Enter the base system container:
#      ./enter_container_base_system.sh

docker build -t fil-c-base-system -f Dockerfile-base-system .
