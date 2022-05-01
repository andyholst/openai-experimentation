FROM python:3.8.13-slim-buster

RUN apt-get update
RUN apt-get -y install cmake python3-pip python3-dev pkg-config lua5.1 build-essential ffmpeg git
RUN pip install pip-tools

COPY import_roms.sh /tmp/import_roms.sh
COPY requirements.txt /tmp/requirements.txt
RUN pip install --requirement /tmp/requirements.txt --disable-pip-version-check
