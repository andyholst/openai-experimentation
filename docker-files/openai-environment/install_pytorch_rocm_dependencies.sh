#!/usr/bin/env bash

if [ "$ROCM_ARCH" ]; then
  python3.7 -m pip install astunparse numpy ninja pyyaml setuptools cmake cffi typing_extensions future six \
  requests dataclasses cython pillow h5py sklearn matplotlib editdistance pandas portpicker typing enum34 \
  hypothesis mkl mkl-include || exit 1

  apt update

  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3.7-dev || exit 1

  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libopencv-highgui4.2 libopenblas-dev lua5.1 git zlib1g-dev libopenmpi-dev curl ssh apt-utils \
      libncurses5-dev make libnuma-dev libgoogle-glog-dev libgflags-dev g++-9 libomp-9-dev \
      asciidoc docbook-xml docbook-xsl xsltproc libffi-dev libbz2-dev libreadline-dev libncursesw5-dev \
      libgdbm-dev libsqlite3-dev uuid-dev tk-dev gfortran apt-transport-https autoconf automake \
      libyaml-dev libz-dev libjpeg-dev libasound2-dev libsndfile-dev libstdc++-9-dev libgcc-9-dev || exit 1

  update-alternatives --install /usr/bin/clang clang /opt/rocm/llvm/bin/clang 50 || exit 1
  update-alternatives --install /usr/bin/clang++ clang++ /opt/rocm/llvm/bin/clang++ 50 || exit 1

  clang_lib="/opt/rocm/llvm/lib/clang/14.0.0/lib/linux" && echo "$clang_lib" > /etc/ld.so.conf.d/clang.conf && \
      ldconfig

  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 50 || exit 1
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 50 || exit 1
  update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-9 50 || exit 1
fi
