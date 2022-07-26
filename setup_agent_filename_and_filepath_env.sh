#!/usr/bin/env bash

SONIC_AGENT_NAME="$(find tests/unit-tests -name "*.agent" | xargs -n 1 basename)"
SONIC_AGENT_FILE="$(find tests/unit-tests -name "*.agent" | xargs -n 1)"

echo "SONIC_AGENT_NAME is $SONIC_AGENT_NAME"
echo "SONIC_AGENT_FILE is $SONIC_AGENT_FILE"

export SONIC_AGENT_NAME SONIC_AGENT_FILE
