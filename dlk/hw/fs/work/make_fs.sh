#!/bin/bash

IMG_NAME=./test_fs.img

losetup -D
dd if=/dev/zero of=$IMG_NAME bs=1024 count=4194304 #4GB
#losetup --show -f -P $IMG_NAME
parted -s $IMG_NAME -- mklabel gpt \
#parted -s /dev/loop0 -- mklabel gpt \
mkpart primary fat32 4096s 16383s \
mkpart primary ext4 16384s -1s \
mkpart primary 2048s 4095s \
print \

# kpartx will make /dev/loop0p[1,2,...]
kpartx -a $IMG_NAME
mkfs.vfat -v -c -F 32 /dev/loop0p1
mkfs.ext4 /dev/loop0p2
