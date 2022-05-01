FROM python:3.8.13-buster as builder

COPY requirements.txt /tmp/requirements.txt
RUN pip wheel --requirement /tmp/requirements.txt \
              --wheel-dir /wheelhouse \
              --disable-pip-version-check \
              --quiet

FROM python:3.8.13-buster

COPY --from=builder /wheelhouse /wheelhouse
COPY --from=builder /tmp /tmp

RUN pip install --find-links /wheelhouse \
                --no-index \
                --requirement /tmp/requirements.txt \
                --disable-pip-version-check \
                --quiet

WORKDIR /usr/src/unit-tests

ENTRYPOINT ["py.test", "-c", "setup.cfg", "-p", "no:cacheprovider"]
