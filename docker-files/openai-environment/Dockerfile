FROM python:3.7.13-buster

RUN apt-get update
RUN apt-get -y install cmake python3-pip python3-dev pkg-config lua5.1 build-essential ffmpeg git python3-opengl
RUN pip install pip-tools

COPY roms/SONIC_W.68K /tmp/roms/SONIC_W.68K
COPY import_roms.sh /tmp/import_roms.sh
COPY requirements.txt /tmp/requirements.txt

RUN pip install --requirement /tmp/requirements.txt --disable-pip-version-check
RUN sh /tmp/import_roms.sh
