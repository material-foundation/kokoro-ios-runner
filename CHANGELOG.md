# #develop#

 TODO: Enumerate changes.


# 3.1.0

This minor release adds support for specifying a minimum Xcode version and improved support for unit
test runs when using bazel.sh.

## New features

- It's now possible to specify a minimum Xcode version when running bazel commands.

## Source changes

* [Improved support for unit test runs (#7)](https://github.com/material-foundation/kokoro-ios-runner/commit/3f4c27c7af116ec72208beaffb7a11bd0366494b) (featherless)
* [Add support for specifying a minimum Xcode version. (#6)](https://github.com/material-foundation/kokoro-ios-runner/commit/0f07d8f376189dcce3715dca89d00f2eb4461d0b) (featherless)

# 3.0.0

This major release adds support for running arbitrary bazel commands (notably test) on targets.

## Breaking changes

- bazel.sh now accepts a bazel command as its first argument and the target as its second.

## New features

- Support for arbitrary bazel commands.

## Source changes

* [Add support for running bazel tests (#5)](https://github.com/material-foundation/kokoro-ios-runner/commit/d85ac6c5cd1a432004f490c95d29d1915ebfb297) (featherless)

# 2.1.1

This patch release fixes a bug where the runner scripts wouldn't think they were running in kokoro
during continuous integration builds.

## Source changes

* [Use KOKORO_BUILD_NUMBER to detect whether we're building on a kokoro instance rather than KOKORO_GITHUB_PULL_REQUEST_NUMBER. (#4)](https://github.com/material-foundation/kokoro-ios-runner/commit/34f423b57a55912bf3f08fb4f05ef5ad0ed9a878) (featherless)

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
