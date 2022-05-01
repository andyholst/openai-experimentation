FROM ubuntu:22.04 as builder

RUN apt-get update
RUN apt-get --assume-yes install cmake python3 python3-pip git zlib1g-dev libopenmpi-dev ffmpeg
RUN apt-get update

COPY requirements.txt /tmp/requirements.txt
RUN pip3 wheel --requirement /tmp/requirements.txt \
              --wheel-dir /wheelhouse \
              --disable-pip-version-check \
              --quiet

FROM ubuntu:22.04

RUN apt-get update
RUN apt-get -y install cmake python3 python3-pip git zlib1g-dev libopenmpi-dev ffmpeg
RUN apt-get update

COPY --from=builder /wheelhouse /wheelhouse
COPY --from=builder /tmp/requirements.txt /tmp/requirements.txt

RUN pip3 install --no-index --find-links=/wheelhouse --quiet -r /tmp/requirements.txt

COPY . /usr/src/app
WORKDIR /usr/src/app

CMD ["python", "ai_learns_playing_sonic/ai_learns_playing_sonic.py"]
