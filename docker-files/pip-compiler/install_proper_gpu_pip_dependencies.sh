#!/usr/bin/env bash

EXTRA_INDEX_URL=""
IN_REQUIREMENTS=$1

if [ -n "${ROCM_ARCH}" ]; then
    sed -i '/torch.*/d' "${IN_REQUIREMENTS}"
    if [ "${PYPI_PLACE}" == "artifactory" ]; then
    uri="https://${PYPI_USERNAME}:${PYPI_PASSWORD}@docondee.jfrog.io/artifactory/api/pypi/docondee-rocm-pypi/simple"
    TORCH_VERSION=$(curl "$uri"/torch/ | sed 's/<\/*[^>]*>//g' | grep torch | sed 's/-cp.*//g' | grep -i "$ROCM_VERSION" | head -1)
    TORCH_PACKAGE_VERSION=$(echo $TORCH_VERSION | sed 's/torch-/torch==/g')
    echo "${TORCH_PACKAGE_VERSION}" >> "${IN_REQUIREMENTS}"
    EXTRA_INDEX_URL="--pre --extra-index-url $uri"
    else
      uri="https://github.com/andyholst/openai-experimentation/releases"
      torch_file=$(curl $uri | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep -i releases/download/torch | grep -i "$ROCM_VERSION" | head -1)
      uri="https://github.com"
      echo "${uri}${torch_file}" >> "${IN_REQUIREMENTS}"
    fi
elif [ -n $CUDA_ARCH ]; then
  CUDA_VERSION="$(nvcc --version | grep "release" | awk '{print $6}' | cut -c2-)"
  if [ $CUDA_VERSION >= "11.3" ]; then
    EXTRA_INDEX_URL="--pre --extra-index-url https://download.pytorch.org/whl/cu113"
  else
    EXTRA_INDEX_URL="--pre --extra-index-url https://download.pytorch.org/whl/nightly/cu102"
  fi
fi

if [ -z "$EXTRA_INDEX_URL" ]; then
    if [ "${PYPI_PLACE}" == "artifactory" ]; then
      EXTRA_INDEX_URL="--extra-index-url https://download.pytorch.org/whl/cpu"
    else
      uri="https://github.com/andyholst/openai-experimentation/releases"
      torch_file=$(curl $uri | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep -i releases/download/torch | grep -i "cpu" | head -1)
      uri="https://github.com"
      echo "${uri}${torch_file}" >> "${IN_REQUIREMENTS}"
    fi
fi

export EXTRA_INDEX_URL
