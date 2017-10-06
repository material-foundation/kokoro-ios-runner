# Kokoro iOS runner

This repo contains a script for running iOS tests on a kokoro instance.

## Usage (xcodebuild)

An example script making use of the xcodebuild kokoro iOS runner:

```bash
#!/bin/bash

# Fail on any error.
set -e

if [ ! -d .kokoro-ios-runner ]; then
  git clone https://github.com/material-foundation/kokoro-ios-runner.git .kokoro-ios-runner
fi

pushd .kokoro-ios-runner
git fetch
git checkout v3.0.0
popd

./.kokoro-ios-runner/xcodebuild.sh "MotionInterchange/MotionInterchange.xcodeproj" MotionInterchange "iPhone SE"

bash <(curl -s https://codecov.io/bash)
```

## Usage (bazel)

> [Learn more about bazel for iOS](https://docs.bazel.build/versions/master/tutorial/ios-app.html).

An example script making use of the bazel kokoro iOS runner:

```bash
#!/bin/bash

# Fail on any error.
set -e

if [ ! -d .kokoro-ios-runner ]; then
  git clone https://github.com/material-foundation/kokoro-ios-runner.git .kokoro-ios-runner
fi

pushd .kokoro-ios-runner
git fetch
git checkout v3.0.0
popd

./.kokoro-ios-runner/bazel.sh build //:CatalogByConvention
./.kokoro-ios-runner/bazel.sh test //:CatalogByConventionTests
```
