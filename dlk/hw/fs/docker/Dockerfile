FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y parted \
vim \
kpartx \
libguestfs-tools \
linux-image-generic

ENV LIBGUESTFS_BACKEND direct
