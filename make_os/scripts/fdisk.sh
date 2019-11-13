#!/bin/bash

IMG_NAME=./test_fs.img

MB=$((1000*1000))

dd if=/dev/zero of=$IMG_NAME bs=$MB count=7600 # 7600*1000*1000 Byte (95% of 8GB)

# kpartx will make /dev/loop0p[1,2,...]
#kpartx -a $IMG_NAME
#mkfs.vfat -v -c -F 32 /dev/loop0p1
#mkfs.ext4 /dev/loop0p2

### This is raw patatition and the size is 1MiB
PART3_SIZE=1M

### This is vfat partition and the size is 800MiB
PART1_SIZE=800M

### This is ext4 partition and the size is automatically calculated to use all remained diskc

echo -e \
"n\n"\
"p\n"\
"3\n"\
"\n"\
"+$PART3_SIZE\n"\
"n\n"\
"p\n"\
"1\n"\
"\n"\
"+$PART1_SIZE\n"\
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

#mkfs.vfat -v -c -F 32 $IMG_NAME -E offset=$((2*$MIB))
#mkfs.ext4 $IMG_NAME -E offset=$((802*$MIB))
