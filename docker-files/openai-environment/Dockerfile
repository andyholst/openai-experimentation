FROM python:3.8.13-buster

RUN apt-get update
RUN apt-get -y install cmake python3-pip python3-dev build-essential zlib1g-dev libopenmpi-dev ffmpeg swig wget \
    libosmesa6-dev libgl1-mesa-glx libglfw3 git cmake
RUN pip install pip-tools

RUN cd /tmp && git clone --recursive https://github.com/openai/retro.git gym-retro
RUN cd /tmp && pip install -e gym-retro

COPY import_roms.sh /tmp/import_roms.sh
COPY requirements.txt /tmp/requirements.txt
RUN pip install --requirement /tmp/requirements.txt --disable-pip-version-check
