#!/usr/bin/env bash

ls /opt/rocm/lib/librocm-core.so.* > /dev/null

if [ $? -eq 0 ]; then
  ROCM_VERSION=$(ls /opt/rocm/lib/librocm-core.so.* | sed -r 's/.*librocm-core\.so\.1\.0\.([0-9]+)/\1/')
  echo $ROCM_VERSION | tr 0 .
else
  echo ""
fi
