#!/usr/bin/env bash

ls /opt/rocm/bin/rocminfo > /dev/null

if [ $? -eq 0 ]; then
  ROCM_ARCH=$(rocminfo | grep -m1 gfx | awk '{print $2}')
  echo "${ROCM_ARCH}"
else
  echo ""
fi

