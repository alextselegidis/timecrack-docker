#!/bin/bash

# -----------------------------------------------------------------------------
# Timecrack - Online Time Tracker
#
# @package     Timecrack
# @author      A.Tselegidis <alextselegidis@gmail.com>
# @copyright   Copyright (c) Alex Tselegidis
# @license     https://opensource.org/licenses/GPL-3.0 - GPLv3
# @link        https://timecrack.org
# -----------------------------------------------------------------------------

##
# Point the "latest" tag to an already published Timecrack release.
#
# This copies the manifest of the version tag instead of building again, so that "latest" is byte for byte
# the image that was published with "docker-publish.sh".
#
# Usage:
#
#  ./docker-publish-latest.sh <version>
#
# Example:
#
#   ./docker-publish-latest.sh 1.5.0
#

DEFAULT_VERSION=1.5.0

VERSION="${1:-$DEFAULT_VERSION}"

docker buildx imagetools create -t alextselegidis/timecrack:latest alextselegidis/timecrack:${VERSION}
