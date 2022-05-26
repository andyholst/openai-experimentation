FROM python:3.7.13-buster

RUN apt-get update
RUN apt-get -y install python3-pip python3-dev build-essential pciutils
RUN rm -rf /var/lib/apt/lists/*
RUN pip install pip-tools

WORKDIR "/usr/src/app"

COPY install_proper_gpu_pip_dependencies.sh /tmp/install_proper_gpu_pip_dependencies.sh

CMD sh /tmp/install_proper_gpu_pip_dependencies.sh && pip-compile --verbose --rebuild --upgrade "${IN_REQUIREMENTS}"
