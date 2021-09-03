#!/bin/bash
# Usage: BUILDKITE_AGENT_TOKEN=<xyz> ./start-default-agent.sh

docker rm buildkite-bootstrap-issue

docker run \
  --name buildkite-bootstrap-issue \
  --rm \
  -e BUILDKITE_AGENT_TOKEN \
  -e BUILDKITE_AGENT_NAME="default-agent" \
  -e BUILDKITE_AGENT_TAGS="queue=bootstrap-issue" \
  -e BUILDKITE_AGENT_DEBUG="true" \
  buildkite/agent:3.27
