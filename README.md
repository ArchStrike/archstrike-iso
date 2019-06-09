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

Environment Preparation
-----------------------
```shell
$ git clone git@github.com:ArchStrike/archstrike-iso.git
$ cd archstrike-iso
$ cp archiso/{mkstrikeiso,unsquashiso} ~/bin
$ ./archiso/unsquashiso
# cp -r /tmp/squashfs-root/etc/initcpio/* /usr/lib/initcpio/
```

Building the ArchStrike ISO
---------------------------
To build minimal ISO
```shell
$ cd archstrike-iso/configs/minimal{,2}
```
To build openbox ISO
```shell
$ cd archstrike-iso/configs/openbox
```
Then remove existing work directory, some bugs may exist such as multiple multilib entries,
run the build script, and change the owner of the iso.
```
# [[ -e work ]] && rm -rf ./work/*
# ./build.sh -v
```

Maintenance Notes
-----------------
Over time packages change, if you wish to find a list of packages that no longer exist run the following.
```
$ for pkg in $(cat packages.both | grep -v '#'); do SSPKG="$(pacman -Ss "^$pkg\$" )"; [[ -z "$SSPKG" ]] && sed -i "/^$pkg\$/d" ./packages.both ; done
```
This will delete any dependencies that no longer resolve and using `git diff` should help figure out what needs some to be reviewed.
