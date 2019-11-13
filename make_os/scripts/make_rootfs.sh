#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Error: Number of argument should be 1"
	exit 1 
fi

DEBOOTSTRAP_ARCH=$1

if [ "${DEBOOTSTRAP_ARCH}" = "armhf" ]; then
	QEMU_ARCH=arm
elif [ "${DEBOOTSTRAP_ARCH}" = "arm64" ]; then
	QEMU_ARCH=aarch64
else
	echo "Error: Argument should be armhf or arm64"
	exit 1
fi

BUILD_DIR=/work/build
SCRIPTS_DIR=/work/scripts
LINUX_KERNEL_DIR=/work/linux_kernel
DRIVER_DIR=/work/driver

ROOTFS_DIR=${BUILD_DIR}/rootfs_${DEBOOTSTRAP_ARCH}
ROOTFS_TGZ=${ROOTFS_DIR}.tgz

# Chcek if the $ROOTFS_DIR exists or not
if [ -d "${ROOTFS_DIR}" ]; then
	echo "Error: ${ROOTFS_DIR} on docker environment already exists"
	exit 1
fi

# Check if $ROOTFS_TGZ exists or not
if [ -e "${ROOTFS_TGZ}" ]; then
	echo "Error: ${ROOTFS_TGZ} on docker environment already exists"
	exit 1
fi

# Make rootfs
debootstrap --arch=${DEBOOTSTRAP_ARCH} --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg --verbose --foreign bionic ${ROOTFS_DIR}
cp /usr/bin/qemu-${QEMU_ARCH}-static ${ROOTFS_DIR}/usr/bin/
cp ${SCRIPTS_DIR}/setting_after_chroot.sh ${ROOTFS_DIR}
chroot ${ROOTFS_DIR} /bin/bash /setting_after_chroot.sh

# Here is after chroot
rm ${ROOTFS_DIR}/setting_after_chroot.sh
mkdir -p ${ROOTFS_DIR}/lib/modules/4.5.0/kernel/drivers/misc
tar xvzf ${LINUX_KERNEL_DIR}/kernel_modules.tar.gz -C ${ROOTFS_DIR}/lib/modules/4.5.0/kernel
cp ${DRIVER_DIR}/udmabuf.ko ${ROOTFS_DIR}/lib/modules/4.5.0/kernel/drivers/misc
tar cvzf ${ROOTFS_TGZ} -C `dirname ${ROOTFS_DIR}` `basename ${ROOTFS_DIR}` --remove-file
chmod a=rw ${ROOTFS_TGZ}
