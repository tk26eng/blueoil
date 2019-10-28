#!/bin/bash

IMG_NAME=./test_fs.img

dd if=/dev/zero of=$IMG_NAME bs=1024 count=4194304 #4GB
parted -s $IMG_NAME -- mklabel gpt \
mkpart primary fat32 2048s 4096s \
mkpart primary ext4 8192s 16384s \
print
