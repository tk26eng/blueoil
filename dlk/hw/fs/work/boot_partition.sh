#!/bin/bash

FPGA_DIR=output_template
LINUX_KERNEL_DIR=linux_kernel
BOOT_PARTITION_DIR=boot_partition

mkdir ${BOOT_PARTITION}
cp ./output_template/fpga/soc_system.dtb ${BOOT_PARTITION_DIR}
cp ./output_template/fpga/soc_system.rbf ${BOOT_PARTITION_DIR}
cp ./dlk/hw/intel/de10_nano/linux_kernel/zImage ${BOOT_PARTITION_DIR}

# apt-get install uboot-mkimage
mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "My script" -d boot.script u-boot.scr
