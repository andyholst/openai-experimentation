#!/usr/bin/env bash

lspci | grep -i amd

if [ $? -eq 0 ]; then
  if [ -z "${ROCM_ARCH}" ]; then
    rocminfo | grep gfx || exit 1
    ROCM_ARCH=$(rocminfo | grep -m1 gfx | awk '{print $2}')
  fi

  export ROCM_ARCH
  export PYTORCH_ROCM_ARCH="${ROCM_ARCH}"
  export PATH=/opt/rocm/bin:$PATH
  export ROCM_PATH=/opt/rocm
  export HIP_PATH=/opt/rocm/hip
fi

lspci | grep -i nvidia

if [ $? -eq 0 ]; then
  echo "Not implemented yet."
fi
