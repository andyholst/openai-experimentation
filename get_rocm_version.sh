#!/usr/bin/env bash

ls /opt/rocm/lib/librocm-core.so.* > /dev/null

if [ $? -eq 0 ]; then
  ROCM_VERSION=$(ls /opt/rocm/lib/librocm-core.so.* | sed -r 's/.*librocm-core\.so\.1\.0\.([0-9]+)/\1/')
  ROCM_VERSION="$(echo $ROCM_VERSION | tr 0 .)"
  regexp='^([1-9]+\.[0-9]+)(\.\.)$'
  if [[ $ROCM_VERSION =~ $regexp ]]; then
    ROCM_VERSION=$(echo $ROCM_VERSION | sed -E "s/$regexp/\1.0/g")
  fi
  echo $ROCM_VERSION
else
  echo ""
fi
