#!/usr/bin/env bash

lspci | grep -i amd

HAS_AMD_CARD=$?

lspci | grep -i nvidia

HAS_NVIDIA_CARD=$?

EXTRA_INDEX_URL=""
ROCM_ARCH=""
IN_REQUIREMENTS=$1

if [ $HAS_AMD_CARD -eq 0 ]; then
  rocminfo | grep gfx
  if [ $? -eq 0 ]; then
    ROCM_ARCH=$(rocminfo | grep -m1 gfx | awk '{print $2}')
    if [ $ROCM_ARCH == "gfx803" ]; then
      sed -i '/torch.*/d' "${IN_REQUIREMENTS}"
      echo "git+https://github.com/ROCmSoftwarePlatform/pytorch@master#egg=torch" >> "${IN_REQUIREMENTS}"
    else
      EXTRA_INDEX_URL="--pre --extra-index-url https://download.pytorch.org/whl/nightly/rocm5.1.1/"
    fi
  fi
elif [ $HAS_NVIDIA_CARD -eq 0 ]; then
  CUDA_VERSION="$(nvcc --version | grep "release" | awk '{print $6}' | cut -c2-)"
  if [ $CUDA_VERSION >= "11.3" ]; then
    EXTRA_INDEX_URL="--pre --extra-index-url https://download.pytorch.org/whl/cu113"
  else
    EXTRA_INDEX_URL="--pre --extra-index-url https://download.pytorch.org/whl/nightly/cu102"
  fi
fi

echo "EXTRA_INDEX_URL is $EXTRA_INDEX_URL"

if [ -z "$EXTRA_INDEX_URL" ] && [ -z "$ROCM_ARCH" ]; then
    EXTRA_INDEX_URL="--extra-index-url https://download.pytorch.org/whl/cpu"
fi

export EXTRA_INDEX_URL
