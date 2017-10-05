# Kokoro iOS runner

This repo contains a script for running iOS tests on a kokoro instance, though it can be deployed
to any iOS testing infrastructure.

## Usage

An example script making use of the kokoro iOS runner:

```bash
#!/bin/bash

# Fail on any error.
set -e

if [ ! -d .kokoro-ios-runner ]; then
  git clone https://github.com/material-foundation/kokoro-ios-runner.git .kokoro-ios-runner
fi

pushd .kokoro-ios-runner
git fetch
git checkout v1.0.0
popd

./.kokoro-ios-runner/build_and_test.sh "MotionInterchange/MotionInterchange.xcodeproj" MotionInterchange "iPhone SE"

bash <(curl -s https://codecov.io/bash)
```
