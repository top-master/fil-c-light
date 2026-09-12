#!/bin/bash
#
# Copyright (c) 2025 Epic Games, Inc. All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY EPIC GAMES, INC. ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL EPIC GAMES, INC. OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

set -e

# Parse command-line options
MODE=rootless

print_help() {
    cat <<EOF
Usage: $0 [-o] [-p] [-n] [-h]

Delete the container image for this checkout, forcing a rebuild on next run.

Options:
  -o    Reset /opt/fil mode image (requires sudo)
  -p    Reset pizlix image (requires sudo)
  -n    Reset normal rootless image (this is the default)
  -h    Show this help message

EOF
    exit 0
}

while getopts "noph" opt; do
    case $opt in
        n)
            MODE=rootless
            ;;
        p)
            MODE=pizlix
            ;;
        o)
            MODE=optfil
            ;;
        h)
            print_help
            ;;
        \?)
            echo "Use -h for help" >&2
            exit 1
            ;;
    esac
done

# Check if rootful mode requires sudo
if [ $EUID -ne 0 ]; then
    case "$MODE" in
        rootless)
            :
            ;;
        pizlix)
            echo "Error: Pizlix mode (-p) requires running with sudo"
            echo "Run: sudo $0 -p"
            exit 1
            ;;
        optfil)
            echo "Error: /opt/fil mode (-o) requires running with sudo"
            echo "Run: sudo $0 -o"
            exit 1
            ;;
        *)
            echo "Bad mode = $MODE"
            exit 1
            ;;
    esac
fi

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect file owner UID/GID
FILE_OWNER_UID=$(stat -c %u "${SCRIPT_DIR}")
FILE_OWNER_GID=$(stat -c %g "${SCRIPT_DIR}")

# Check that rootless mode is run as the file owner
if [ "$MODE" = rootless ]; then
    CURRENT_UID=$(id -u)
    if [ "$CURRENT_UID" -ne "$FILE_OWNER_UID" ]; then
        FILE_OWNER_NAME=$(stat -c %U "${SCRIPT_DIR}")
        echo "Error: Rootless mode must be run as the checkout owner"
        echo "  Checkout owner: ${FILE_OWNER_NAME} (UID ${FILE_OWNER_UID})"
        echo "  Current user: $(whoami) (UID ${CURRENT_UID})"
        exit 1
    fi
fi

# Create the same image tag that enter_container.sh uses
CHECKOUT_HASH=$(echo -n "${SCRIPT_DIR}" | sha256sum | cut -c1-8)
IMAGE_NAME="fil-c-dev"

# Compute image tag based on mode (same logic as enter_container.sh)
case "$MODE" in
    pizlix)
        IMAGE_TAG="${CHECKOUT_HASH}-pizlix-uid${FILE_OWNER_UID}"
        ;;
    optfil)
        IMAGE_TAG="${CHECKOUT_HASH}-optfil-uid${FILE_OWNER_UID}"
        ;;
    rootless)
        IMAGE_TAG="${CHECKOUT_HASH}"
        ;;
    *)
        echo "Bad mode: $MODE"
        exit 1
esac

# enter_container.sh tags images "${IMAGE_NAME}:${IMAGE_TAG}" with a hash of
# the generated Dockerfile's contents appended, so that changes to the image
# definition produce a new tag instead of silently reusing a stale image.  We
# cannot know that hash here without generating the Dockerfile, so instead
# match every existing tag that is either exactly ${IMAGE_TAG} (the legacy
# spelling from before the hash was introduced) or
# ${IMAGE_TAG}-<8 lowercase hex digits> (any content-hash variant of this
# checkout and mode).  The anchor after ${IMAGE_TAG} keeps other modes' images
# (e.g. the -pizlix-... and -optfil-... tags, which share the checkout hash
# prefix) untouched, and the localhost/ prefix that podman reports for locally
# built images is stripped before matching.
MATCHING_IMAGES=$(podman images --format "{{.Repository}}:{{.Tag}}" \
    | sed 's|^localhost/||' \
    | grep -E "^${IMAGE_NAME}:${IMAGE_TAG}(-[0-9a-f]{8})?$" \
    || true)

if [ -n "$MATCHING_IMAGES" ]; then
    echo "Removing container image(s):"
    echo "$MATCHING_IMAGES"
    podman rmi $MATCHING_IMAGES
    echo "Image(s) removed successfully!"

    # Clean up the generated Dockerfiles that go with the removed images.
    for TAGGED_IMAGE in $MATCHING_IMAGES
    do
        TAG="${TAGGED_IMAGE#${IMAGE_NAME}:}"
        DOCKERFILE_PATH="${SCRIPT_DIR}/.dockerfile-${TAG}"
        if [ -f "${DOCKERFILE_PATH}" ]
        then
            echo "Removing generated Dockerfile ${DOCKERFILE_PATH}..."
            rm -f "${DOCKERFILE_PATH}"
        fi
    done
else
    echo "No ${IMAGE_NAME}:${IMAGE_TAG}* container image exists. Nothing to do."
fi
