#!/usr/bin/env bash

PYTORCH_NAME="$(find build/pytorch/dist -name "*.whl" | xargs -n 1 basename)"
PYTORCH_FILE="$(find build/pytorch/dist -name "*.whl" | xargs -n 1)"

export PYTORCH_NAME PYTORCH_FILE
