ARG VERSION="${VERSION}"
FROM python:3.7.13-buster as builder

COPY requirements.txt /tmp/requirements.txt
RUN pip wheel --requirement /tmp/requirements.txt \
              --wheel-dir /wheelhouse \
              --disable-pip-version-check \
              --quiet

FROM openai:${VERSION}

COPY --from=builder /wheelhouse /wheelhouse
COPY --from=builder /tmp/requirements.txt /tmp/requirements.txt

RUN pip install --no-index --find-links=/wheelhouse --quiet -r /tmp/requirements.txt

COPY . /usr/src/app
WORKDIR /usr/src/app

CMD ["python", "demo/ai_learns_playing_sonic/ai_learns_playing_sonic.py"]
