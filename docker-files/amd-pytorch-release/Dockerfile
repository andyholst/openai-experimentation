ARG VERSION="${VERSION}"
FROM base-ubuntu-2004:${VERSION}

ARG ROCM_VERSION="${ROCM_VERSION}"
ENV ROCM_VERSION="${ROCM_VERSION}"

ARG ROCM_ARCH="${ROCM_ARCH}"
ENV ROCM_ARCH="${ROCM_ARCH}"

ARG PYPI_ROCM_REPOSITORY="${PYPI_ROCM_REPOSITORY}"
ENV PYPI_ROCM_REPOSITORY="${PYPI_ROCM_REPOSITORY}"

ARG PYPI_USERNAME="${PYPI_USERNAME}"
ENV PYPI_USERNAME="${PYPI_USERNAME}"

ARG PYPI_PASSWORD="${PYPI_PASSWORD}"
ENV PYPI_PASSWORD="${PYPI_PASSWORD}"

RUN python3.7 -m pip install twine

COPY prepare_dependencies_and_source.sh /tmp/prepare_dependencies_and_source.sh
COPY build_and_release_pytorch_package_from_source.sh /tmp/build_and_release_pytorch_package_from_source.sh
COPY .pypirc /tmp/pypirc
RUN /bin/sh -c "envsubst < /tmp/pypirc" > /root/.pypirc
RUN rm /tmp/pypirc

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

RUN source $HOME/.bashrc && /tmp/prepare_dependencies_and_source.sh
RUN source $HOME/.bashrc && /tmp/build_and_release_pytorch_package_from_source.sh
