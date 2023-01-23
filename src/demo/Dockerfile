ARG VERSION="${VERSION}"
FROM base-ubuntu-2204:${VERSION} as builder

COPY requirements.txt /tmp/requirements.txt
RUN python3.7 -m pip wheel --requirement /tmp/requirements.txt \
              --wheel-dir /wheelhouse \
              --disable-pip-version-check \
              --quiet

FROM openai:${VERSION}

COPY --from=builder /wheelhouse /wheelhouse
COPY --from=builder /tmp/requirements.txt /tmp/requirements.txt

RUN python3.7 -m pip install --no-index --find-links=/wheelhouse --quiet -r /tmp/requirements.txt

COPY . /usr/src/app
WORKDIR /usr/src/app

CMD ["python3.7", "ai_learns_playing_sonic/ai_learns_playing_sonic.py"]
