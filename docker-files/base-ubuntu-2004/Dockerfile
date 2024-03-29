FROM ubuntu:20.04

ARG ROCM_VERSION="${ROCM_VERSION}"
ENV ROCM_VERSION="${ROCM_VERSION}"

ARG ROCM_ARCH="${ROCM_ARCH}"
ENV ROCM_ARCH="${ROCM_ARCH}"

ARG PROCESSING_UNIT="${PROCESSING_UNIT}"
ENV PROCESSING_UNIT="${PROCESSING_UNIT}"

RUN dpkg --add-architecture i386

RUN apt-get update
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y pkg-config build-essential \
    ffmpeg git python3-dev python3-opengl pciutils software-properties-common curl gettext-base

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF7F09730B3F0A4

RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null

RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y kitware-archive-keyring
RUN rm /etc/apt/trusted.gpg.d/kitware.gpg

RUN apt-get update

RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3.7 python3.7-distutils
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

RUN python3.7 get-pip.py
RUN python3.7 -m pip install pip-tools

COPY install_proper_gpu_dependencies.sh /tmp/install_proper_gpu_dependencies.sh

RUN sh -c "bash /tmp/install_proper_gpu_dependencies.sh"

COPY generate_pytoch_arch_env.sh /tmp/generate_pytoch_arch_env.sh

RUN echo "source /tmp/generate_pytoch_arch_env.sh" >> $HOME/.profile
RUN echo "source /tmp/generate_pytoch_arch_env.sh" >> $HOME/.bashrc
RUN echo "source /tmp/generate_pytoch_arch_env.sh" >> $HOME/.zshrc

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
