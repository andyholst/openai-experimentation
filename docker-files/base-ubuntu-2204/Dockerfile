FROM ubuntu:20.04

RUN dpkg --add-architecture i386
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y cmake python3-pip python3-dev pkg-config lua5.1 build-essential \
    ffmpeg git python3-opengl zlib1g-dev libopenmpi-dev pciutils software-properties-common curl
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3.7 python3.7-distutils
RUN rm -rf /var/lib/apt/lists/*
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.7 get-pip.py
RUN python3.7 -m pip install pip-tools

COPY install_proper_gpu_dependencies.sh /tmp/install_proper_gpu_dependencies.sh
RUN sh /tmp/install_proper_gpu_dependencies.sh
