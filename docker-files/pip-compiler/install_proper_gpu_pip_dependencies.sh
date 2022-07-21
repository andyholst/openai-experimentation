#!/usr/bin/env bash

EXTRA_INDEX_URL=""
IN_REQUIREMENTS=$1

if [ ! -z $ROCM_ARCH ]; then
    if [ $ROCM_ARCH == "gfx803" ]; then
      sed -i '/torch.*/d' "${IN_REQUIREMENTS}"
      uri="https://docondee.jfrog.io/artifactory/api/pypi/docondee-rocm-pypi/simple"
      TORCH_VERSION=$(curl "$uri"/torch/ | sed 's/<\/*[^>]*>//g' | grep torch | sed 's/-cp.*//g' | grep -i "$ROCM_VERSION" | head -1)
      TORCH_PACKAGE_VERSION=$(echo $TORCH_VERSION | sed 's/torch-/torch==/g')
      echo "${TORCH_PACKAGE_VERSION}" >> "${IN_REQUIREMENTS}"
      EXTRA_INDEX_URL="--pre --extra-index-url $uri"
    else
      EXTRA_INDEX_URL="--pre --extra-index-url https://download.pytorch.org/whl/nightly/rocm5.1.1/"
    fi
elif [ ! -z $CUDA_ARCH ]; then
  CUDA_VERSION="$(nvcc --version | grep "release" | awk '{print $6}' | cut -c2-)"
  if [ $CUDA_VERSION >= "11.3" ]; then
    EXTRA_INDEX_URL="--pre --extra-index-url https://download.pytorch.org/whl/cu113"
  else
    EXTRA_INDEX_URL="--pre --extra-index-url https://download.pytorch.org/whl/nightly/cu102"
  fi
fi

if [ -z "$EXTRA_INDEX_URL" ]; then
    EXTRA_INDEX_URL="--extra-index-url https://download.pytorch.org/whl/cpu"
fi

export EXTRA_INDEX_URL
