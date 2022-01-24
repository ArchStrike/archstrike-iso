# Simplify the creation of ISOs
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR?=/opt/archstrike-iso-build
IMG_NAME=archstrike.img
VMDK_NAME=archstrike.vmdk
WORK=${BUILD_DIR}/work
MOUNT_POINT=/mnt/archinstall
OUT=${BUILD_DIR}/out
PROFILE=${ROOT_DIR}/configs/archstrike
ARCHINSTALL="${PROFILE}/airootfs/root/.config/archinstall"


clean:
	sudo umount -qfR ${MOUNT_POINT} ||:
	sudo rm -rf ${MOUNT_POINT} ${WORK} ${OUT} 
	sudo mkdir -pv ${MOUNT_POINT} ${WORK} ${OUT}
	sudo chown -R ${LOGNAME} ${BUILD_DIR}

check:
	shellcheck -s bash bin/port-archiso-releng
	pacman -Qi devtools >/dev/null
	pacman -Qi edk2-ovmf >/dev/null
	pacman -Qi erofs-utils >/dev/null
	pacman -Qi openssl >/dev/null
	pacman -Qi arch-install-scripts >/dev/null
	pacman -Qi bash >/dev/null
	pacman -Qi dosfstools >/dev/null
	pacman -Qi e2fsprogs >/dev/null
	pacman -Qi libarchive >/dev/null
	pacman -Qi libisoburn >/dev/null
	pacman -Qi mtools >/dev/null
	pacman -Qi squashfs-tools >/dev/null
	pacman -Qi qemu >/dev/null

sign-iso:
	sudo chown -R ${LOGNAME} ${OUT}
ifndef GPG_OPTIONS
	@echo Assuming default key is OKAY. You can also try running \`GPG_OPTIONS=\"--default-key \<your-key\>\" make sign\`
endif
	@gpg --batch --yes -v ${GPG_OPTIONS} -sb $(wildcard ${OUT}/*.iso)

build-iso:
	./bin/port-archiso-releng
	sudo mkdir -pv ${BUILD_DIR}
	sudo chown ${LOGNAME} ${BUILD_DIR}
	sudo ./archiso/archiso/mkarchiso -v -w ${WORK} -o ${OUT} ${PROFILE}

test-ami:
	truncate -s 10G ${BUILD_DIR}/${IMG_NAME}
	sudo losetup -fLP ${BUILD_DIR}/${IMG_NAME} --show | grep "/dev/loop0"
	pushd "${ARCHINSTALL}" && sudo archinstall --config ./profiles/ami-default.json --disk_layouts=${ARCHINSTALL}/profiles/ami-disk-layout.json --silent

# test:
ami: clean test-ami
iso: clean check build-iso sign-iso
all: clean check build-iso sign-iso
.DEFAULT_GOAL := all
.PHONY: all ami iso clean check build-iso test-ami sign-iso

