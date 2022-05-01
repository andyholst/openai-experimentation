FROM archlinux/archlinux:base-20220315.0.50478 as builder

RUN pacman-key --init

RUN pacman -Syu --noconfirm

RUN pacman -S --noconfirm python-pip python38 python38-pip
RUN pip install pip-tools
RUN python3.8 -m pip install pip-tools

RUN pacman -S --noconfirm cmake zlib1g-dev libopenmpi-dev ffmpeg

COPY requirements.txt /tmp/requirements.txt
RUN python3.8 -m pip wheel --requirement /tmp/requirements.txt \
              --wheel-dir /wheelhouse \
              --disable-pip-version-check \
              --quiet

FROM ubuntu:22.04

RUN apt-get update
RUN apt-get -y install cmake python3 python3-pip git zlib1g-dev libopenmpi-dev ffmpeg python3.8 \
    python3.8-distutils

COPY --from=builder /wheelhouse /wheelhouse
COPY --from=builder /tmp/requirements.txt /tmp/requirements.txt

RUN python3.8 -m pip install --no-index --find-links=/wheelhouse --quiet -r /tmp/requirements.txt

COPY . /usr/src/app
WORKDIR /usr/src/app

CMD ["python3", "ai_learns_playing_sonic/ai_learns_playing_sonic.py"]
