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
# This script will clean, build, and run tests against each installation of Xcode 8 and 9 available
# on the machine.
#
# Arguments:
#   1. Path to xcodeproj
#   2. Scheme to build and test.
#   3. grep filter for iPhone simulator types [optional].
#
# Example usage:
#   xcodebuild.sh "MotionInterchange/MotionInterchange.xcodeproj" MotionInterchange "iPhone SE"

# Fail on any error.
set -e

# Display commands to stderr.
set -x

# Runs a clean build + tests using xcodebuild on the active Xcode installation.
run() {
  echo "🏗️  clean building $scheme in $project for simulator..."
  set -o pipefail && xcodebuild clean build \
    -project $project \
    -sdk "iphonesimulator" \
    -scheme "$scheme" \
  | xcpretty
  set +o pipefail

  # Outputs destination ID, OS version, and device name as comma-separated "key:value" pairs.
  destinations() {
    xcodebuild test \
      -project $project \
      -sdk "iphonesimulator" \
      -scheme "$scheme" \
      -destination 'platform=iOS Simulator' 2>&1 \
    | sed -n -e '/Available destinations/,$p' \
    | sed -e '/^$/,$d' \
    | grep "id:" \
    | cut -d',' -f2,3,4 \
    | cut -d':' -f2- \
    | cut -d'}' -f1
  }

  # Reads destination ids from stdin and executes tests on the corresponding simulator.
  run_test() {
    while read -r destination; do
      destination_id=$(echo $destination | cut -d',' -f1)
      destination_os=$(echo $destination | cut -d':' -f2 | cut -d',' -f1)
      destination_name=$(echo $destination | cut -d':' -f3 | cut -d',' -f1)

      echo "🔨  testing on $destination_name ($destination_os)..."
      set -o pipefail && xcodebuild test \
        -project $project \
        -sdk "iphonesimulator" \
        -scheme "$scheme" \
        -destination "id=$destination_id" \
      | xcpretty
      set +o pipefail

      if [ -z "$KOKORO_BUILD_NUMBER" ]; then
        :
      else
        # Avoid a buildup of active simulators.
        xcrun simctl shutdown $destination_id
      fi
    done
  }

  if xcodebuild test \
    -project $project \
    -sdk "iphonesimulator" \
    -scheme "$scheme" \
    -dry-run \
    -quiet >/dev/null 2>/dev/null; then
    if [ -z "$target_simulator_filter" ]; then
      # Run against all simulators
      destinations | run_test
    else
      destinations | grep "$target_simulator_filter" | run_test
    fi
  fi
}

script_version="v4.3.0"
echo "build_and_test version $script_version"

project="$1"
scheme="$2"
target_simulator_filter="$3"

# Dependencies

if [ -z "$KOKORO_BUILD_NUMBER" ]; then
  : # Local run - nothing to do.
else
  gem install xcpretty --no-rdoc --no-ri --no-document --quiet

  # Move into our cloned repo
  cd github/repo
fi

if [ -z "$KOKORO_BUILD_NUMBER" ]; then
  run # Run with the Xcode currently pointed to by xcode-select.
else
  # Runs our tests on every available Xcode 8 or 9 installation.
  ls /Applications/ | grep "Xcode" | grep -e "8." -e "9." | while read -r xcode_path; do
    sudo xcode-select --switch /Applications/$xcode_path/Contents/Developer
    xcodebuild -version

    run
  done
fi
