#!/bin/bash

# Forward SIGTERM to child
# https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash

_term() {
  # forward TERM signal to child
  kill -TERM "$child"

  # and wait for child to terminate
  wait "$child"
  TERM_EXIT_CODE=$?

  # delete job logs after bootstrap is complete
  rm -rf /tmp/buildkite-job-${BUILDKITE_JOB_ID}.log

  # exit bootstrap.sh with the child's exit code
  exit $TERM_EXIT_CODE
}

trap _term SIGTERM

# Run the tee in a subshell to we can background a process using redirects
# Start commands in new process groups to skip termination by Buildkite Agent
setsid buildkite-agent bootstrap > >(setsid tee /tmp/buildkite-job-${BUILDKITE_JOB_ID}.log) &
child=$!

wait "$child"
NON_TERM_EXIT_CODE=$?

# delete job logs after bootstrap is complete
rm -rf /tmp/buildkite-job-${BUILDKITE_JOB_ID}.log

# exit bootstrap script with the child's exit code
exit $NON_TERM_EXIT_CODE
