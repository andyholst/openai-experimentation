ARG VERSION="${VERSION}"
FROM base-ubuntu-2204:${VERSION}

ARG ROCM_ARCH="${ROCM_ARCH}"
ENV ROCM_ARCH="${ROCM_ARCH}"

COPY roms/SONIC_W.68K /tmp/roms/SONIC_W.68K
COPY import_roms.sh /tmp/import_roms.sh
COPY requirements.txt /tmp/requirements.txt
COPY compile_pytorch_from_source_if_gfx803.sh /tmp/compile_pytorch_from_source_if_gfx803.sh

WORKDIR /usr/src

RUN source $HOME/.bashrc && /tmp/compile_pytorch_from_source_if_gfx803.sh

WORKDIR /tmp
RUN ls -lh /usr/src
RUN rm -fr /usr/src/pytorch

RUN python3.7 -m pip install --requirement /tmp/requirements.txt --disable-pip-version-check
RUN echo -e "import retro" | python3.7
RUN ls -lh /tmp/roms
RUN bash /tmp/import_roms.sh

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

COPY verify_pytorch_is_installed.py /tmp/verify_pytorch_is_installed.py
