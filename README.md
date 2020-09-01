archstrike-iso
===============
ArchStrike-iso is a collection of configurations and scripts to generate the official iso.    

Dependencies
------------
 * `qemu`
 * `squashfs-tools`
 * `arch-install-scripts`
 * `lynx`
 * `libisoburn`
 * `dosfstools`
 * `gcc-libs`
 * `archiso`
 * `archstrike-installer`

Environment Preparation
-----------------------
First verify that you have 30G of free disk space as the Openbox ISO uncompressed consumes more than 15G.
```shell
$ git clone git@github.com:ArchStrike/archstrike-iso.git
$ cd archstrike-iso
$ ln -s archiso/mkstrikeiso ~/bin/
$ ln -s archiso/unsquashiso ~/bin/
# unsquashiso
```

Building the ArchStrike ISO
---------------------------
To build minimal ISO
```shell
$ cd configs/minimal
```
To build openbox ISO
```shell
$ cd configs/openbox
```
Then remove existing work directory, some bugs may exist such as multiple multilib entries,
run the build script, and change the owner of the iso.
```
# [[ -e work ]] && rm -rf ./work/*
# ./build.sh -v
```

Maintenance Notes
-----------------
Over time packages change, check for issues prior to attempting to build the Openbox ISO.
```
$ archstrike-arbitration --package archstrike
$ archstrike-arbitration --file archstrike-iso/configs/openbox/packages.both
```
This should report a list of packages you can use to stdout and report issues to stderr by analyzing input.
