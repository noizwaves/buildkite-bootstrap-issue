#!/bin/bash
# Usage: BUILDKITE_AGENT_TOKEN=<xyz> ./start-default-agent.sh

# https://stackoverflow.com/a/246128
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

docker rm buildkite-bootstrap-issue

docker run \
  --name buildkite-bootstrap-issue \
  --rm \
  -e BUILDKITE_AGENT_TOKEN \
  -e BUILDKITE_AGENT_NAME="default-agent" \
  -e BUILDKITE_AGENT_TAGS="queue=bootstrap-issue" \
  -e BUILDKITE_AGENT_DEBUG="false" \
  -e BUILDKITE_HOOKS_PATH="/etc/buildkite-agent/hooks/" \
  -v "${SCRIPT_DIR}/pre-exit.sh:/etc/buildkite-agent/hooks/pre-exit:ro" \
  buildkite/agent:3.27
