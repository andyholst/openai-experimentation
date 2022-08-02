#!/usr/bin/env bash

ROCM_PYTORCH_NAME="$(find build/pytorch/dist -name "*.whl" | xargs -n 1 basename)"
ROCM_PYTORCH_FILE="$(find build/pytorch/dist -name "*.whl" | xargs -n 1)"

export ROCM_PYTORCH_NAME ROCM_PYTORCH_FILE
