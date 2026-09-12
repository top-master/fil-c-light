#!/bin/sh

# This script launches an interactive base system container using the 'fil-c-base-system' Docker image.
#
# It mounts your local 'Downloads' directory ($HOME/Downloads) to /root/Downloads inside the container
# for demonstration or file sharing purposes.
#
# Usage:
#   ./enter_container_base_system.sh
#
# For details about the base system environment, see 'Dockerfile-base-system'.

docker run \
  -it \
  --rm \
  --mount type=bind,source="${HOME}/Downloads",target="/root/Downloads" \
  --cap-add=NET_RAW \
  fil-c-base-system
