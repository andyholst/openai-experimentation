FROM python:3.8.13-buster

RUN apt-get update
RUN apt-get -y install cmake python3-pip python3-dev build-essential zlib1g-dev libopenmpi-dev ffmpeg

COPY requirements.txt /tmp/requirements.txt
RUN pip install --requirement /tmp/requirements.txt --disable-pip-version-check
