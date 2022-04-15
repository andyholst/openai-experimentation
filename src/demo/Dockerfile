FROM python:3.9.12-slim-buster as builder


COPY requirements.txt /tmp/requirements.txt
RUN pip wheel --requirement /tmp/requirements.txt \
              --wheel-dir /wheelhouse \
              --disable-pip-version-check \
              --quiet

FROM python:3.9.12-slim-buster

COPY --from=builder /wheelhouse /wheelhouse
COPY --from=builder /tmp/requirements.txt /tmp/requirements.txt

RUN pip install --no-index --find-links=/wheelhouse --quiet -r /tmp/requirements.txt

COPY . /usr/src/app
WORKDIR /usr/src/app

CMD ["python", "demo/hello_world.py"]
