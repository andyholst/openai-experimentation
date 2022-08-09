#!/usr/bin/env bash

export MAKEFLAGS="-j$(nproc)"
export MAX_JOBS=$(nproc)
export NINJAFLAGS="-j$(nproc)"

cd /app/src/build/pytorch || exit 1

PYTORCH_BUILD_VERSION="$(python3.7 -c 'from tools.generate_torch_version import get_torch_version; print(get_torch_version())')" || exit 1
PYTORCH_BUILD_NUMBER="1"

if [ -n "${ROCM_ARCH}" ] && [ "${PROCESSING_UNIT}" == "amd" ]; then
    python3.7 tools/amd_build/build_amd.py || exit 1
    USE_ROCM=1
    PYTORCH_BUILD_VERSION="${PYTORCH_BUILD_VERSION}-rocm-$(echo "$ROCM_VERSION" | tr . 0)"
    PYTORCH_ROCM_ARCH="${ROCM_ARCH}"

    export PYTORCH_BUILD_NUMBER PYTORCH_BUILD_VERSION PYTORCH_ROCM_ARCH USE_ROCM USE_MKLDNN=1
else
  PYTORCH_BUILD_VERSION="${PYTORCH_BUILD_VERSION}-cpu"
  export USE_CUDA=0 USE_CUDNN=0 USE_MKLDNN=1 USE_ROCM=0 PYTORCH_BUILD_VERSION PYTORCH_BUILD_NUMBER
fi

python3.7 setup.py bdist_wheel

if [ "${UPLOAD_TO_ARTIFACTORY}" == "True" ]; then
  python3.7 -m twine upload -r local dist/* || exit 1
fi
