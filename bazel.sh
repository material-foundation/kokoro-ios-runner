#!/bin/bash
#
# Copyright 2017-present The Kokoro iOS Runner Authors. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Build script for kokoro.
#
# This script will clean, build, and run tests against each installation of Xcode available on the
# machine using bazel.
#
# Arguments:
#   1. BUILD target.
#
# Example usage:
#   bazel.sh //:CatalogByConvention

# Fail on any error.
set -e

# Display commands to stderr.
set -x

script_version="v2.1.0"
echo "bazel_build_and_test version $script_version"

target="$1"

# Dependencies

if [ -z "$KOKORO_BUILD_NUMBER" ]; then
  : # Local run - nothing to do.
else
  # Move into our cloned repo
  cd github/repo
fi

# Runs our tests on every available Xcode 8 or 9 installation.
ls /Applications/ | grep "Xcode" | while read -r xcode_path; do
  xcode_version=$(cat /Applications/$xcode_path/Contents/version.plist \
    | grep "CFBundleShortVersionString" -A1 \
    | grep string \
    | cut -d'>' -f2 \
    | cut -d'<' -f1)
  echo "🏗️  clean building $target with Xcode $xcode_version..."
  bazel clean
  bazel build $target --xcode_version $xcode_version
done
