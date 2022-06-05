ARG VERSION="${VERSION}"
FROM base-ubuntu-2204:${VERSION}

WORKDIR "/usr/src/app"

COPY install_proper_gpu_pip_dependencies.sh /tmp/install_proper_gpu_pip_dependencies.sh

CMD ["bash", "-c", "source /tmp/install_proper_gpu_pip_dependencies.sh ${IN_REQUIREMENTS} && \
  pip-compile --verbose ${EXTRA_INDEX_URL} --rebuild --upgrade ${IN_REQUIREMENTS}"]
