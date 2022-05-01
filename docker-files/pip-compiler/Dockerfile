FROM python:3.8.13-buster

RUN apt-get update
RUN apt-get -y install python3-pip python3-dev build-essential
RUN pip install pip-tools

WORKDIR "/usr/src/app"

CMD pip-compile --verbose --rebuild --upgrade "${IN_REQUIREMENTS}"
