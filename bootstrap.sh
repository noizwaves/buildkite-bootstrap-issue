#!/bin/bash

_handle_signal() {
  # wait for PID so output continues to pipe to tee
  wait "$PID"
}

trap "_handle_signal" SIGTERM

# Background process so later we can wait for it to exit
# Run tee with process substitution; cannot use pipes because we want to background the process
# Start tee in separate process group so job output continues to work duringprocess group signal conditions
buildkite-agent bootstrap > >(setsid tee /tmp/buildkite-job-${BUILDKITE_JOB_ID}.log) &

# Save `buildkite-agent bootstrap`'s pid to PID
PID=$!

# Wait for PID to exit, so we can get it's exit code
wait "$PID"
EXIT_CODE=$?

# delete job log after PID exits
rm -rf /tmp/buildkite-job-${BUILDKITE_JOB_ID}.log

# exit this script with PID's actual exit code
exit $EXIT_CODE
