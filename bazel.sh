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
#   1. bazel action (build or test, usually)
#   2. BUILD target.
#   3. Minimum Xcode version. E.g. "8" or "8.2.1"
#
# Example usage:
#   bazel.sh build //:CatalogByConvention
#   bazel.sh test //:CatalogByConventionTests

# Fail on any error.
set -e

# Display commands to stderr.
set -x

script_version="v3.0.0"
echo "bazel_build_and_test version $script_version"

version_as_number() {
  padded_version="${1%.}" # Strip any trailing dots
  # Pad with .0 until we get a M.m.p version string.
  while [ $(grep -o "\." <<< "$padded_version" | wc -l) -lt "2" ]; do
    padded_version=${padded_version}.0
  done
  echo "${padded_version//.}"
}

action="$1"
target="$2"
min_xcode_version="$(version_as_number $3)"

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
  if [ -z "$min_xcode_version" ]; then
    :
  else
    xcode_version_as_number="$(version_as_number $xcode_version)"

    # TODO: This doesn't work yet.
    if [ "$xcode_version_as_number" -lt "$min_xcode_version" ]; then
      continue
    fi
  fi

  set +x
  extra_args=""
  if [ "$action" == "build" ]; then
    echo "🏗️  $target with Xcode $xcode_version..."
  elif [ "$action" == "test" ]; then
    echo "🛠️  $target with Xcode $xcode_version..."
    extra_args="--test_output=errors"
  fi
  set -x

  bazel clean
  bazel $action $target --xcode_version $xcode_version $extra_args
done
