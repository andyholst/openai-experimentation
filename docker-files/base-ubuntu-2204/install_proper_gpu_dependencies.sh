#!/usr/bin/env bash

lspci | grep -i amd

if [ $? -eq 0 ]; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y libnuma-dev wget gnupg2 || exit 1

  wget https://repo.radeon.com/amdgpu-install/22.10.3/ubuntu/focal/amdgpu-install_22.10.3.50103-1_all.deb || exit
  DEBIAN_FRONTEND=noninteractive apt-get install -y ./amdgpu-install_22.10.3.50103-1_all.deb || exit 1
  yes | DEBIAN_FRONTEND=noninteractive amdgpu-install -y --no-dkms || exit 1
  rm -rf /var/lib/apt/lists/*
  ln -s /opt/rocm/bin/rocminfo /usr/bin/rocminfo
fi

lspci | grep -i nvidia

if [ $? -eq 0 ]; then
  apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub || exit 1
  wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin || exit 1
  mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 || exit 1
  add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" || exit 1

  apt update
  DEBIAN_FRONTEND=noninteractive apt-get install -y cuda
  rm -rf /var/lib/apt/lists/*
fi
