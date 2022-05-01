FROM python:3.8.13-buster as builder

RUN apt-get update
RUN apt-get -y install cmake python3-pip python3-dev build-essential zlib1g-dev libopenmpi-dev ffmpeg

COPY requirements.txt /tmp/requirements.txt
RUN pip wheel --requirement /tmp/requirements.txt \
              --wheel-dir /wheelhouse \
              --disable-pip-version-check

FROM openai:${VERSION}

RUN apt-get update
RUN apt-get -y install cmake python3-pip python3-dev build-essential zlib1g-dev libopenmpi-dev ffmpeg

COPY --from=builder /wheelhouse /wheelhouse
COPY --from=builder /tmp/requirements.txt /tmp/requirements.txt

RUN pip install --no-index --find-links=/wheelhouse -r /tmp/requirements.txt

COPY . /usr/src/app
WORKDIR /usr/src/app

CMD ["python", "ai_learns_playing_sonic/ai_learns_playing_sonic.py"]
