FROM archlinux/archlinux:base-20220315.0.50478

RUN pacman-key --init

RUN pacman -Syu --noconfirm

RUN pacman -S --noconfirm make

WORKDIR "/usr/src/source"

CMD make "${BUILD_ARGUMENT}"
