#!/usr/bin/env bash

if [ ! -z "${ROCM_ARCH}" ]; then
  export MAKEFLAGS="-j$(nproc)"
  export MAX_JOBS=$(nproc)
  export NINJAFLAGS="-j$(nproc)"

  cd pytorch || exit 1
  python3.7 tools/amd_build/build_amd.py || exit 1

  PYTORCH_BUILD_VERSION="$(python3.7 -c 'from tools.generate_torch_version import get_torch_version; print(get_torch_version())')-rocm-" || exit 1
  PYTORCH_BUILD_NUMBER="1"
  PYTORCH_BUILD_VERSION="$PYTORCH_BUILD_VERSION$(echo "$ROCM_VERSION" | tr . 0)"
  PYTORCH_ROCM_ARCH="${ROCM_ARCH}"

  export PYTORCH_BUILD_NUMBER PYTORCH_BUILD_VERSION PYTORCH_ROCM_ARCH

  USE_ROCM=1 python3.7 setup.py bdist_wheel
  python3.7 -m twine upload -r local dist/* || exit 1
fi
