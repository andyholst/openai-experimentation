FROM python:3.8.13-buster

RUN apt-get update
RUN apt-get -y install python-pip python-dev build-essential

WORKDIR "/usr/src/app"

CMD pip-compile --verbose --rebuild --upgrade "${IN_REQUIREMENTS}"
