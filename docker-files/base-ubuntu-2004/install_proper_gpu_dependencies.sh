#!/usr/bin/env bash

if [ ! -z "$ROCM_ARCH" ]; then
  AMDGPU_VERSION=22.10.3
  ROCM_VERSION=$ROCM_VERSION

  echo "export AMDGPU_VERSION=$AMDGPU_VERSION" >> $HOME/.profile
  echo "export AMDGPU_VERSION=$AMDGPU_VERSION" >> $HOME/.bashrc
  echo "export AMDGPU_VERSION=$AMDGPU_VERSION" >> $HOME/.zshrc

  echo "export ROCM_VERSION=$ROCM_VERSION" >> $HOME/.profile
  echo "export ROCM_VERSION=$ROCM_VERSION" >> $HOME/.bashrc
  echo "export ROCM_VERSION=$ROCM_VERSION" >> $HOME/.zshrc

  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libstdc++-7-dev libgcc-7-dev || exit 1

  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl gnupg || exit 1
  curl -sL http://repo.radeon.com/rocm/rocm.gpg.key | apt-key add - || exit 1
  echo deb [arch=amd64] http://repo.radeon.com/rocm/apt/$ROCM_VERSION/ ubuntu main > /etc/apt/sources.list.d/rocm.list
  echo deb [arch=amd64] https://repo.radeon.com/amdgpu/$AMDGPU_VERSION/ubuntu focal main > /etc/apt/sources.list.d/amdgpu.list
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libdrm-amdgpu-common || exit 1
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends sudo \
  kmod file rocm-dev rocm-utils rocm-libs rocm-dev rocrand rocblas rocfft \
  hipsparse hip-base rocsparse rocm-cmake rocm-libs rocm-device-libs rccl || exit 1
  ln -s /opt/rocm/bin/rocminfo /usr/bin/rocminfo
fi

if [ ! -z "$CUDA_ARCH" ]; then
  apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub || exit 1
  wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin || exit 1
  mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 || exit 1
  add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" || exit 1

  apt update
  DEBIAN_FRONTEND=noninteractive apt-get install -y cuda
fi
