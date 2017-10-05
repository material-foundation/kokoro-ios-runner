# 2.1.0

This minor release adds command logging to the kokoro builds.

## New features

Commands are now output to stderr along with their results.

## Source changes

* [Display commands to stderr. (#3)](https://github.com/material-foundation/kokoro-ios-runner/commit/823b51e5f08a57e971667a3608439c886fcf214d) (featherless)

# 2.0.0

This release introduces support for the [bazel](https://bazel.build/) toolchain.

## Breaking changes

- `build_and_test.sh` has been renamed to `xcodebuild.sh`

## New features

- The new `bazel.sh` script supports running bazel builds against all local Xcode installs.

## Source changes

* [Add support for bazel builds. (#2)](https://github.com/material-foundation/kokoro-ios-runner/commit/e8930a547675494b6f3bfe784baab2e374d4318f) (featherless)

# 1.0.0

Includes the build_and_test.sh script. The script supports building and testing arbitrary xcodeproj
schemes. The script will run against each Xcode 8 and 9 installation available on the device. It's
also possible to filter which simulators the script runs against.

## Source changes

* [Add initial version of the build_and_test script. (#1)](https://github.com/material-foundation/kokoro-ios-runner/commit/bbeaab3c0786d87346181fcc1ceb54211bcb8f31) (featherless)
