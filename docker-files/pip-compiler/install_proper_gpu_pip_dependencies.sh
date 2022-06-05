#!/usr/bin/env bash

lspci | grep -i amd

EXTRA_INDEX_URL=""

if [ $? -eq 0 ]; then
    export EXTRA_INDEX_URL="--extra-index-url https://download.pytorch.org/whl/rocm4.5.2"
fi

lspci | grep -i nvidia

if [ $? -eq 0 ]; then
  sed -i 's/torch==.*/torch==1.10.1+cu111/g' "${IN_REQUIREMENTS}"
  sed -i 's/torchvision==.*/torchvision==0.11.2+cu111/g' "${IN_REQUIREMENTS}"
fi
