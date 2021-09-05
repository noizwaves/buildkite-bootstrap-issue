#!/bin/bash

# Forward SIGTERM to PID
# https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash

_forward_signal() {
  SIGNAL=$1

  # forward $SIGNAL to child
  kill -$SIGNAL "$PID"

  # and wait for PID to terminate
  wait "$PID"
  TERM_EXIT_CODE=$?

  # delete job logs after bootstrap is complete
  rm -rf /tmp/buildkite-job-${BUILDKITE_JOB_ID}.log

  # exit bootstrap.sh with the PID's exit code
  exit $TERM_EXIT_CODE
}

trap "_forward_signal TERM" SIGTERM

# Run the tee in a subshell to we can background a process using process substitution
# Start tee in separate process group so job output continues to work during signal conditions
buildkite-agent bootstrap > >(setsid tee /tmp/buildkite-job-${BUILDKITE_JOB_ID}.log) &
PID=$!

wait "$PID"
NON_TERM_EXIT_CODE=$?

# delete job logs after bootstrap is complete
rm -rf /tmp/buildkite-job-${BUILDKITE_JOB_ID}.log

# exit bootstrap script with the PID's exit code
exit $NON_TERM_EXIT_CODE
