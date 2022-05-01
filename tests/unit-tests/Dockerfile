FROM python:3.8.13-buster as builder

RUN apt-get update
RUN apt-get -y install cmake python3-pip python3-dev build-essential zlib1g-dev libopenmpi-dev ffmpeg

COPY requirements.txt /tmp/requirements.txt
RUN pip wheel --requirement /tmp/requirements.txt \
              --wheel-dir /wheelhouse \
              --disable-pip-version-check \

FROM python:3.8.13-buster

RUN apt-get update
RUN apt-get -y install cmake python3-pip python3-dev build-essential zlib1g-dev libopenmpi-dev ffmpeg

COPY --from=builder /wheelhouse /wheelhouse
COPY --from=builder /tmp /tmp

RUN pip install --find-links /wheelhouse \
                --no-index \
                --requirement /tmp/requirements.txt \
                --disable-pip-version-check \

WORKDIR /usr/src/unit-tests

ENTRYPOINT ["py.test", "-c", "setup.cfg", "-p", "no:cacheprovider"]
