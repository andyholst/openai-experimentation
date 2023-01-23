ARG VERSION="${VERSION}"
FROM base-ubuntu-2204:${VERSION}

ARG ROCM_ARCH="${ROCM_ARCH}"
ENV ROCM_ARCH="${ROCM_ARCH}"

ARG PROCESSING_UNIT="${PROCESSING_UNIT}"
ENV PROCESSING_UNIT="${PROCESSING_UNIT}"

COPY roms/SONIC_W.68K /tmp/roms/SONIC_W.68K
COPY import_roms.sh /tmp/import_roms.sh
COPY requirements.txt /tmp/requirements.txt
COPY install_pytorch_dependencies.sh /tmp/install_pytorch_dependencies.sh

WORKDIR /usr/src

WORKDIR /tmp
RUN ls -lh /usr/src
RUN rm -fr /usr/src/pytorch

RUN sh -c "bash /tmp/install_pytorch_dependencies.sh"
RUN python3.7 -m pip install --requirement /tmp/requirements.txt --disable-pip-version-check
RUN sh -c "bash echo -e 'import retro' | python3.7"
RUN ls -lh /tmp/roms
RUN bash /tmp/import_roms.sh

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

COPY verify_pytorch_is_installed.py /tmp/verify_pytorch_is_installed.py
