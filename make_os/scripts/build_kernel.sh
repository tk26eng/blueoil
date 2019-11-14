#!/bin/bash

BUILD_DIR=/work/build
SCRIPTS_DIR=/work/scripts
LINUX_KERNEL_DIR=/work/linux_kernel
DRIVER_DIR=/work/driver

ROOTFS_DIR=${BUILD_DIR}/rootfs_${DEBOOTSTRAP_ARCH}
ROOTFS_TGZ=${ROOTFS_DIR}.tgz

######
### This is main part
######
wget -i ${LINUX_KERNEL_DIR}/sources.txt



# Tar part is necessary later. It should be holded.
#rm ${ROOTFS_DIR}/setting_after_chroot.sh

#mkdir -p ${ROOTFS_DIR}/lib/modules
#tar xvzf ${LINUX_KERNEL_DIR}/kernel_modules.tar.gz -C ${ROOTFS_DIR}/lib/modules
#cp ${DRIVER_DIR}/udmabuf.ko ${ROOTFS_DIR}/lib/modules/4.5.0/kernel/drivers/misc

#tar cvzf ${ROOTFS_TGZ} -C `dirname ${ROOTFS_DIR}` `basename ${ROOTFS_DIR}` --remove-file
#chmod a=rw ${ROOTFS_TGZ}
