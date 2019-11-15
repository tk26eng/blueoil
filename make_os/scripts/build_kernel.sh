#!/bin/bash

BUILD_DIR=/work/build
SCRIPTS_DIR=/work/scripts
LINUX_KERNEL_DIR=/work/linux_kernel
DRIVER_DIR=/work/driver

#ROOTFS_DIR=${BUILD_DIR}/rootfs_${DEBOOTSTRAP_ARCH}
#ROOTFS_TGZ=${ROOTFS_DIR}.tgz

LINUX_DIR=${BUILD_DIR}/linux
LINUX_TGZ=${LINUX_DIR}.tgz

######
### This is main part
######
cd ${BUILD_DIR} # Just in case, we move to the directory 
wget -i ${LINUX_KERNEL_DIR}/sources.txt -P ${BUILD_DIR}
unzip socfpga-4.5.zip -d ${BUILD_DIR}
mv ${BUILD_DIR}/linux-socfpga-socfpga-4.5 ${LINUX_DIR}
cp ${LINUX_KERNEL_DIR}/config ${LINUX_DIR}/.config

cd ${LINUX_DIR}
ln -s /usr/bin/arm-linux-gnueabihf-gcc-7 /usr/local/bin/arm-linux-gnueabihf-gcc
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
make -j 32 # If we use -j option, it'll be faster than single core
#mv ${LINUX_DIR}/arch/arm/boot/zImage ${BUILD_DIR}
#make modules_install INSTALL_MOD_PATH=${BUILD_DIR}

# Tar part is necessary later. It should be holded.
#rm ${ROOTFS_DIR}/setting_after_chroot.sh

#mkdir -p ${ROOTFS_DIR}/lib/modules
#tar xvzf ${LINUX_KERNEL_DIR}/kernel_modules.tar.gz -C ${ROOTFS_DIR}/lib/modules
#cp ${DRIVER_DIR}/udmabuf.ko ${ROOTFS_DIR}/lib/modules/4.5.0/kernel/drivers/misc

#tar cvzf ${ROOTFS_TGZ} -C `dirname ${ROOTFS_DIR}` `basename ${ROOTFS_DIR}` --remove-file
#chmod a=rw ${ROOTFS_TGZ}


# These two lines  will be used on the anather script
#mkdir ${BUILD_DIR}/modules

