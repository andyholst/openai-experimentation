#!/usr/bin/env bash

if [ ! -z "$ROCM_ARCH" ]; then
  export MAKEFLAGS="-j$(nproc)"
  export MAX_JOBS=$(nproc)
  export NINJAFLAGS="-j$(nproc)"

  cd pytorch || exit 1
  python3.7 tools/amd_build/build_amd.py || exit 1

  USE_ROCM=1 PYTORCH_ROCM_ARCH="$ROCM_ARCH" python3.7 setup.py bdist_wheel
  python3.7 -m twine upload -r local dist/* || exit 1
fi
