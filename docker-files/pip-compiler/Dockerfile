ARG VERSION="${VERSION}"
FROM base-ubuntu-2004:${VERSION}

ARG ROCM_VERSION="${ROCM_VERSION}"
ENV ROCM_VERSION="${ROCM_VERSION}"

ARG ROCM_ARCH="${ROCM_ARCH}"
ENV ROCM_ARCH="${ROCM_ARCH}"

ARG PROCESSING_UNIT="${PROCESSING_UNIT}"
ENV PROCESSING_UNIT="${PROCESSING_UNIT}"

ARG APP_NAME="${APP_NAME}"
ENV APP_NAME="${APP_NAME}"

WORKDIR "/usr/src/app"

COPY install_proper_gpu_pip_dependencies.sh /tmp/install_proper_gpu_pip_dependencies.sh

CMD ["bash", "-c", "source /tmp/install_proper_gpu_pip_dependencies.sh ${IN_REQUIREMENTS} && \
  pip-compile --verbose ${EXTRA_INDEX_URL} --rebuild --upgrade ${IN_REQUIREMENTS}"]
