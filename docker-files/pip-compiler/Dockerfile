FROM archlinux/archlinux:base-20220315.0.50478

RUN pacman-key --init

RUN pacman -Syu --noconfirm

RUN pacman -S --noconfirm python-pip
RUN pip install pip-tools

WORKDIR "/usr/src/source"

CMD ["pip-compile", "--verbose", "--rebuild", "--no-index", "--no-header", "--upgrade ${IN_REQUIREMENTS}"]
