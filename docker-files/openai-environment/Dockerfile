ARG VERSION="${VERSION}"
FROM base-ubuntu-2204:${VERSION}

ARG ROCM_ARCH="${ROCM_ARCH}"
ENV ROCM_ARCH="${ROCM_ARCH}"

COPY roms/SONIC_W.68K /tmp/roms/SONIC_W.68K
COPY import_roms.sh /tmp/import_roms.sh
COPY requirements.txt /tmp/requirements.txt
COPY compile_pytorch_from_source_if_gfx803.sh /tmp/compile_pytorch_from_source_if_gfx803.sh


RUN source $HOME/.bashrc && /tmp/compile_pytorch_from_source_if_gfx803.sh
RUN python3.7 -m pip install --requirement /tmp/requirements.txt --disable-pip-version-check && /tmp/import_roms.sh"]
