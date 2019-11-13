#!/bin/bash

FPGA_DIR=/work/fpga
LINUX_KERNEL_DIR=/work/linux_kernel
SCRIPTS_DIR=/work/scripts
BOOT_PARTITION_DIR=/work/build/boot_partition
BOOT_PARTITION_TGZ=${BOOT_PARTITION_DIR}.tgz

mkdir ${BOOT_PARTITION_DIR} # Even if directory already exits, this program will continue. It might be better to handle the error.
cp ${FPGA_DIR}/soc_system.dtb ${BOOT_PARTITION_DIR}
cp ${FPGA_DIR}/soc_system.rbf ${BOOT_PARTITION_DIR}
cp ${LINUX_KERNEL_DIR}/zImage ${BOOT_PARTITION_DIR}
# apt-get install uboot-mkimage
mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "My script" -d ${SCRIPTS_DIR}/boot.script ${BOOT_PARTITION_DIR}/u-boot.scr
tar cvzf ${BOOT_PARTITION_TGZ} -C `dirname ${BOOT_PARTITION_DIR}` `basename ${BOOT_PARTITION_DIR}` --remove-file
chmod a=rw ${BOOT_PARTITION_TGZ} 
