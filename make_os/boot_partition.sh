#!/bin/bash

FPGA_DIR=/work/fpga
LINUX_KERNEL_DIR=/work/linux_kernel
MAKE_OS_DIR=/work/make_os
BOOT_PARTITION_DIR=/work/make_os/boot_partition

mkdir ${BOOT_PARTITION_DIR} # Even if directory already exits, this program will continue. It might be better to handle the error.
cp ${FPGA_DIR}/soc_system.dtb ${BOOT_PARTITION_DIR}
cp ${FPGA_DIR}/soc_system.rbf ${BOOT_PARTITION_DIR}
cp ${LINUX_KERNEL_DIR}/zImage ${BOOT_PARTITION_DIR}
# apt-get install uboot-mkimage
mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "My script" -d ${MAKE_OS_DIR}/boot.script ${BOOT_PARTITION_DIR}/u-boot.scr
