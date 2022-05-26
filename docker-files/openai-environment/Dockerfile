ARG VERSION="${VERSION}"
FROM base-ubuntu-2204:${VERSION}

COPY roms/SONIC_W.68K /tmp/roms/SONIC_W.68K
COPY import_roms.sh /tmp/import_roms.sh
COPY requirements.txt /tmp/requirements.txt

RUN python3.7 -m pip install --requirement /tmp/requirements.txt --disable-pip-version-check
RUN sh /tmp/import_roms.sh
