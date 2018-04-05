# 4.2.1

Bazel builds will no longer force verbose output. Verbose output can be enabled by providing the -v
flag.

## Source changes

* [Don't always use verbose output when running on bazel.](https://github.com/material-foundation/kokoro-ios-runner/commit/845084d9b1c06a67e87270beb91569dafda1c3aa) (Jeff Verkoeyen)

# 4.2.0

Local runs of the bazel.sh script now only run against the currently selected Xcode install. This should hopefully alleviate flakiness on local builds.

## Source changes

* [Only run the selected Xcode on local runs (#19)](https://github.com/material-foundation/kokoro-ios-runner/commit/ff54f2459c04371226d4521643ffe5a9aff53b1c) (featherless)

# 4.1.1

This patch release fixes a bug in bazel argument expansion affecting arguments like
`"--ios_simulator_device=iPad Pro (12.9-inch)"`.

## Source changes

* [Use array expansion to add extra bazel args to the bazel invocation. (#17)](https://github.com/material-foundation/kokoro-ios-runner/commit/40d399e7f163b41bebf3a54200077689caf3fd0b) (featherless)
* [Remove unused header.](https://github.com/material-foundation/kokoro-ios-runner/commit/b4f3ada1d45288f5810c9c3db538f4accca647c9) (Jeff Verkoeyen)

# 4.1.0

This minor release introduces support for passing arbitrary flags to bazel invocations.

## New features

Any unrecognized arguments passed to bazel.sh will now be passed along to the bazel invocation. This
can be used to invoke the build against multiple architectures. For example:

```
./.kokoro-ios-runner/bazel.sh test //components/... \
    --min-xcode-version 8.2 \
    --ios_minimum_os=8.0 \
    --ios_multi_cpus=i386,x86_64
```

## Source changes

* [Add support for passing arbitrary bazel arguments along to bazel (#16)](https://github.com/material-foundation/kokoro-ios-runner/commit/bad93074045ad48b17d1ce325d38d725a848b3d8) (featherless)
* [Fix another typo in the README.](https://github.com/material-foundation/kokoro-ios-runner/commit/ffa1680bd8c82d7bf720a6e5bdb8f4e404154ea2) (Jeff Verkoeyen)
* [Fix typo in the docs.](https://github.com/material-foundation/kokoro-ios-runner/commit/52e4caa91d31a5a996ebd0c12d0c9012ac97e3bd) (Jeff Verkoeyen)

# 4.0.0

This major release introduces support for configuring bazel output verbosity.

## Breaking changes

The minimum Xcode version must now be provided as a flag.

```
// Old invocations:
bazel.sh build //:CatalogByConvention 8.2

// New invocations:
bazel.sh build //:CatalogByConvention --min-xcode-version 8.2
```

## New features

Local bazel builds no longer build with verbose output. To enable verbose output, pass the `-v` flag
to the bazel.sh script.

## Source changes

* [Add arguments for configuring verbosity to the bazel runner (#15)](https://github.com/material-foundation/kokoro-ios-runner/commit/e686ab44e1d31e1fbf981af306daff7cafca211b) (featherless)
* [Remove outdated comment (#12)](https://github.com/material-foundation/kokoro-ios-runner/commit/f4a5f341ced7c2016e9faa3d67eb9028f67df908) (featherless)

## API changes

bazel.sh now supports a `-v` argument for enabling verbosity on local builds. Verbose output is
always enabled on kokoro builds.

# 3.2.0

This minor release increases the amount of logging generated during bazel runs.

## Source changes

* [Add more build and test output during bazel runs. (#11)](https://github.com/material-foundation/kokoro-ios-runner/commit/db3aa9a2ae602533be0a51ce6cdde8297b6dfc41) (featherless)

# 3.1.1

This patch release fixes a bug on local runs of the bazel scripts where the simulator would crash
between different Xcode versions.

## Source changes

* [Run launchctl remove com.apple.CoreSimulator.CoreSimulatorService on local runs as well. (#8)](https://github.com/material-foundation/kokoro-ios-runner/commit/14ee009563082fb2eb74d976b0a4216e35651064) (featherless)

## Non-source changes

* [Update README.md (#9)](https://github.com/material-foundation/kokoro-ios-runner/commit/c7bee8406f90911bf0181eb36e4b013132032620) (ianegordon)

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
