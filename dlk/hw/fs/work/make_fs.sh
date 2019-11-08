#!/bin/bash

IMG_NAME=./test_fs.img

MIB=$((1024*1024))
MB=$((1000*1000))
SEC=512

dd if=/dev/zero of=$IMG_NAME bs=$MB count=7600 # 7600*1000*1000 Byte (95% of 8GB)

# kpartx will make /dev/loop0p[1,2,...]
#kpartx -a $IMG_NAME
#mkfs.vfat -v -c -F 32 /dev/loop0p1
#mkfs.ext4 /dev/loop0p2

### This is raw patatition and unit is sector
PART3_START=$((1*$MIB/$SEC))
PART3_END=$((1*$MIB/$SEC-1))

### This is vfat partition and unit is sector
PART1_START=$((2*$MIB/$SEC))
PART1_END=$((800*$MIB/$SEC-1))

### This is ext4 partition and unit is sector
PART2_START=$((802*$MIB/$SEC))
#PART2_END=$((6799*$MIB/$SEC-1)) # Setting this value is not necessary because this is the last partition

echo "PART2_START"
echo $((802*$MIB))

echo -e \
"n\n"\
"p\n"\
"3\n"\
"$PART3_START\n"\
"+$PART3_END\n"\
"n\n"\
"p\n"\
"1\n"\
"$PART1_START\n"\
"+$PART1_END\n"\
"n\n"\
"p\n"\
"2\n"\
"$PART2_START\n"\
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

mkfs.vfat -v -c -F 32 $IMG_NAME -E offset=$((2*$MIB))
mkfs.ext4 $IMG_NAME -E offset=$((802*$MIB))
