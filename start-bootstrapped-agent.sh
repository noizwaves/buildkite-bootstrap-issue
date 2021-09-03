#!/bin/bash
# Usage: BUILDKITE_AGENT_TOKEN=<xyz> ./start-bootstrapped-agent.sh

# https://stackoverflow.com/a/246128
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

docker rm buildkite-bootstrap-issue

docker run \
  --name buildkite-bootstrap-issue \
  --rm \
  -e BUILDKITE_AGENT_TOKEN \
  -e BUILDKITE_AGENT_NAME="bootstrapped-agent" \
  -e BUILDKITE_AGENT_TAGS="queue=bootstrap-issue" \
  -e BUILDKITE_BOOTSTRAP_SCRIPT_PATH="/etc/buildkite-agent/bootstrap.sh" \
  -v "${SCRIPT_DIR}/bootstrap.sh:/etc/buildkite-agent/bootstrap.sh:ro" \
  buildkite/agent:3.27
