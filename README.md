archstrike-iso
===============
The archstrike-iso project is a customization of the official Arch Linux archiso releng profile. The submodule archiso is needed to create a custom live media. If you have not already, please review `archiso/README.rst`.   

Environment Preparation
-----------------------
Make sure to initialize the archiso submodule (i.e. `git submodule init --update --recursive`).

If you would like to improve build performance, you may wish to optimize your mirror list.
```
$ reflector --country US,GE --age 12 --sort rate --save /tmp/mirrorlist-reflector
$ rankmirrors /tmp/mirrorlist-reflector  > /tmp/mirrorlist-ranked
# cp -bv /tmp/mirrorlist-ranked /etc/pacman.d/mirrorlist
```

Things will not work as expected without installing the necessary dependencies with pacman:
 * All dependencies specified by `archiso/README.rst`
 * `archstrike-installer`
 * `reflector`
 * `arch-install-scripts`
 * `lynx`
 * `gcc-libs`


Creating the ArchStrike ISO
---------------------------
To build the ArchStrike ISO, simply run `make`. Equivalently, you can run each target.
``shell
# make check
# make clean
# make build-archstrike-iso
# make sign
```
To use a non-default gpg key to sign, run `GPG_OPTIONS="--default-key <your-key-id>" make sign`.

Maintenance Notes
-----------------
Over time packages change, check for issues prior to attempting to build the Openbox ISO.
```
$ archstrike-arbitration --package archstrike
$ archstrike-arbitration --file archstrike-iso/configs/openbox/packages.both
```
This should report a list of packages you can use to stdout and report issues to stderr by analyzing input.
