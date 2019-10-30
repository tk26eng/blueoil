#!/bin/bash

IMG_NAME=./test_fs.img

dd if=/dev/zero of=$IMG_NAME bs=512 count=14843750 # 7600*1000*100 Byte (95% of 8GB)


# kpartx will make /dev/loop0p[1,2,...]
#kpartx -a $IMG_NAME
#mkfs.vfat -v -c -F 32 /dev/loop0p1
#mkfs.ext4 /dev/loop0p2

echo -e \
"n\n"\
"p\n"\
"3\n"\
"\n"\
"+1M\n"\
"n\n"\
"p\n"\
"1\n"\
"\n"\
"+800M\n"\
"n\n"\
"p\n"\
"2\n"\
"\n"\
"\n"\
"t\n"\
"1\n"\
"c\n"\
"t\n"\
"2\n"\
"83\n"\
"t\n"\
"3\n"\
"a2\n"\
"p\n"\
"w\n"\
 | fdisk $IMG_NAME
