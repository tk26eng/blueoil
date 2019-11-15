#!/bin/bash

BUILD_DIR=/work/build
IMG_NAME=${BUILD_DIR}/micro_sd.img

dd if=/dev/zero of=${IMG_NAME} bs=1MB count=7600 # 7600*1000*1000 Byte (95% of 8GB). 1MB means 1000*1000 Bytes

### This is raw patatition and the size is 1MiB
PART3_SIZE=1M

### This is vfat partition and the size is 800MiB
PART1_SIZE=800M

### The size for ext4 is automatically calculated because it uses all remained disk

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
 | fdisk ${IMG_NAME}

chmod a=rw ${IMG_NAME}
