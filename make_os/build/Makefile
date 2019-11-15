SCRIPTS_DIR=/work/scripts

all: fdisk build-kernel boot-partition make-rootfs merge-all

fdisk:
	$(SCRIPTS_DIR)/fdisk.sh

build-kernel:
	$(SCRIPTS_DIR)/build_kernel.sh

boot-partition:
	$(SCRIPTS_DIR)/boot_partition.sh
	
make-rootfs:
	$(SCRIPTS_DIR)/make_rootfs.sh

merge-all:
	$(SCRIPTS_DIR)/merge_all.sh

