FROM python:3.7.13-buster

RUN apt-get update
RUN apt-get -y install python3-pip python3-dev build-essential pciutils
RUN rm -rf /var/lib/apt/lists/*
RUN pip install pip-tools

WORKDIR "/usr/src/app"

CMD source /tmp/install_proper_gpu_pip_dependencies.sh && pip-compile --verbose \
  "${EXTRA_INDEX_URL}" --rebuild --upgrade "${IN_REQUIREMENTS}"
