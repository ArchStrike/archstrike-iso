archstrike-iso
===============
ArchStrike-iso is a collection of configurations and scripts to generate the official iso.    

Dependencies
------------
 * `qemu`
 * `squashfs-tools`

Environment Preparation
-----------------------
```shell
$ cp archiso/{mkstrikeiso,unsquashiso} ~/bin
$ unsquashiso
$ cp /tmp/squashfs-root/etc/initcpio/hooks/* /usr/lib/initcpio/hooks/
```

Building the ArchStrike ISO
---------------------------
To build minimal ISO
```shell
$ cd archstrike-iso/configs/minimal
$ sudo ./build.sh
```
To build openbox ISO
```shell
$ cd archstrike-iso/configs/openbox
$ sudo ./build.sh
```
