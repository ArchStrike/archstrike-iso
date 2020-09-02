# Simplify the creation of ISOs
# TODOs:
# 	- review archiso/README.rst to see if there is a better way to test the iso
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR?=/opt/archstrike-iso-build
WORK=${BUILD_DIR}/work
OUT=${BUILD_DIR}/out
PROFILE=${ROOT_DIR}/configs/archstrike


check:
	shellcheck -s bash bin/port-archiso-releng

clean:
	sudo rm -fr ${WORK} ${OUT}

build-archstrike-iso:
	sudo mkdir -pv ${BUILD_DIR}
	sudo chown ${LOGNAME} ${BUILD_DIR}
	sudo ./archiso/archiso/mkarchiso -v -w ${WORK} -o ${OUT} ${PROFILE}

sign:
	sudo chown -R ${LOGNAME} ${OUT}
ifndef GPG_OPTIONS
	@echo Assuming default key is OKAY. You can also try running \`GPG_OPTIONS=\"--default-key \<your-key\>\" make sign\`
endif
	@gpg --batch --yes -v ${GPG_OPTIONS} -sb $(wildcard ${OUT}/*.iso)

# test:

all: check clean build-archstrike-iso sign
.DEFAULT_GOAL := all
.PHONY: all clean check build-archstrike-iso sign
