archstrike-iso
===============
The archstrike-iso project is a customization of the official Arch Linux archiso releng profile. The submodule archiso is needed to create a custom live media. If you have not already, please review `archiso/README.rst`.   

Dependencies
------------
 * All dependencies specified by `archiso/README.rst`
 * `archstrike-installer`
 * `reflector`
 * `arch-install-scripts`
 * `lynx`
 * `gcc-libs`

Environment Preparation
-----------------------
If you would like to improve build perfomance, you may wish to optimize your mirror list.
```
$ reflector --country US,GE --age 12 --sort rate --save /tmp/mirrorlist-reflector
$ rankmirrors /tmp/mirrorlist-reflector  > /tmp/mirrorlist-ranked
# cp -bv /tmp/mirrorlist-ranked /etc/pacman.d/mirrorlist
```
Make sure that the directory `archstrike-iso/bin` is searched first by the root user. Otherwise, the build script might not work as expected. If you have not already, add prepend `archstrike-iso/bin` to the `PATH` environment variable.
```shell
$ cd archstrike-iso
# printf 'export PATH="%s:${PATH}"\n' "$(realpath bin)" >> /root/.bashrc
```

Creating the ArchStrike ISO
---------------------------
To build minimal ISO
```shell
# unsquashiso
$ cd configs/minimal
```
Then remove the directory `work` and run the build script.
```
# rm -rf ./work/*
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
