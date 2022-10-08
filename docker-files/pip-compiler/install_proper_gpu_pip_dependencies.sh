#!/usr/bin/env bash

EXTRA_INDEX_URL=""
IN_REQUIREMENTS=$1

if [ ! -z "${ROCM_ARCH}" ]; then
    sed -i '/torch.*/d' "${IN_REQUIREMENTS}"
    if [ "${PYPI_PLACE}" == "artifactory" ]; then
      uri="https://${PYPI_USERNAME}:${PYPI_PASSWORD}@docondee.jfrog.io/artifactory/api/pypi/docondee-rocm-pypi/simple"
      TORCH_VERSION=$(curl "$uri"/torch/ | sed 's/<\/*[^>]*>//g' | grep torch | sed 's/-cp.*//g' | grep -i "$ROCM_VERSION" | head -1)
      TORCH_PACKAGE_VERSION=$(echo $TORCH_VERSION | sed 's/torch-/torch==/g')
      echo "${TORCH_PACKAGE_VERSION}" >> "${IN_REQUIREMENTS}"
      EXTRA_INDEX_URL="--pre --extra-index-url $uri"
    else
      uri="https://github.com/andyholst/openai-experimentation/releases"
      torch_link=$(curl $uri | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep -i releases/tag/torch | grep -i "$ROCM_VERSION" | head -1)
      torch_link_path=$(basename "$torch_link")

      uri="https://github.com"
      torch_file=$(basename $(curl $uri$torch_link | grep -o 'src=.*' | grep -i "$ROCM_VERSION" | sed -e 's/.*src=['"'"'"]//' -e 's/["'"'"'].*$//'))

      uri="https://github.com/andyholst/openai-experimentation/releases/download/"

      echo "${uri}${torch_link_path}/${torch_file}" >> "${IN_REQUIREMENTS}"
    fi
elif [ ! -z ${CUDA_ARCH} ]; then
  CUDA_VERSION="$(nvcc --version | grep "release" | awk '{print $6}' | cut -c2- || exit 1)"
  if [ $CUDA_VERSION >= "11.3" ]; then
    EXTRA_INDEX_URL="--pre --extra-index-url https://download.pytorch.org/whl/cu113"
  else
    EXTRA_INDEX_URL="--pre --extra-index-url https://download.pytorch.org/whl/nightly/cu102"
  fi
fi

if [ -z "$EXTRA_INDEX_URL" ] && [ -z "${ROCM_ARCH}" ] && [ -z ${CUDA_ARCH} ]; then
    if [ "${PYPI_PLACE}" == "artifactory" ]; then
      EXTRA_INDEX_URL="--extra-index-url https://download.pytorch.org/whl/cpu"
    else
      sed -i '/torch.*/d' "${IN_REQUIREMENTS}"
      uri="https://github.com/andyholst/openai-experimentation/releases"
      torch_link=$(curl $uri | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep -i releases/tag/torch | grep -i "cpu" | head -1)
      torch_link_path=$(basename "$torch_link")

      uri="https://github.com"
      torch_file=$(basename $(curl $uri$torch_link | grep -o 'src=.*' | grep -i "cpu" | sed -e 's/.*src=['"'"'"]//' -e 's/["'"'"'].*$//'))

      uri="https://github.com/andyholst/openai-experimentation/releases/download/"

      echo "${uri}${torch_link_path}/${torch_file}" >> "${IN_REQUIREMENTS}"
    fi
fi

export EXTRA_INDEX_URL
