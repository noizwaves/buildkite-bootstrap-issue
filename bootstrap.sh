#!/bin/bash

# Forward SIGTERM to PID
# https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash

_forward_signal() {
  # wait for PID so output continues to stream to tee
  wait "$PID"
}

trap "_forward_signal TERM" SIGTERM

# Run the tee in a subshell to we can background a process using process substitution and get PID
# Start tee in separate process group so job output continues to work during signal conditions
buildkite-agent bootstrap > >(setsid tee /tmp/buildkite-job-${BUILDKITE_JOB_ID}.log) &
PID=$!

wait "$PID"
EXIT_CODE=$?

# delete job logs after bootstrap is complete
rm -rf /tmp/buildkite-job-${BUILDKITE_JOB_ID}.log

# exit bootstrap script with PID's exit code
exit $EXIT_CODE
