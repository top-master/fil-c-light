#!/bin/sh

# This script launches an interactive Fil-C development container using the 'fil-c-build' Docker image.
#
# It mounts your local Fil-C project directory ($HOME/projects/fil-c) to /opt/fil-c inside the container,
# enabling live editing, building, and testing of the project within a consistent environment.
#
# Usage:
#   ./enter_container_build_env.sh
#
# For details about the development environment, see 'Dockerfile-build-env'.

docker run \
  -it \
  --rm \
  --mount type=bind,source="${HOME}/projects/fil-c",target="/opt/fil-c" \
  fil-c-build
