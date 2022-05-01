FROM python:3.8.13-buster

WORKDIR "/usr/src/app"

CMD pip-compile --verbose --rebuild --upgrade "${IN_REQUIREMENTS}"
