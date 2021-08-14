# ArchStrike: Customized Arch Linux ISO     
The archstrike-iso project is a customization of the official Arch Linux archiso releng profile. The submodule archiso is needed to create a custom live media. If you have not already, please review `archiso/README.rst`.   

## Initialize Submodule
Make sure to initialize the archiso submodule (i.e. `git submodule init --update --recursive`).

## Dependencies
Use pacman to install dependencies as needed.
 * `git submodule init archiso`
 * `git submodule update --remote`
 * `archstrike-installer`
 * `reflector`
 * `arch-install-scripts`
 * `lynx`
 * `gcc-libs`

## Creating the ArchStrike ISO

To build the ArchStrike ISO, simply run `make` in userland. Equivalently, you can run each target in userland.
```shell
make check
make clean
make build-archstrike-iso
make sign
```
To use a non-default gpg key to sign, run `GPG_OPTIONS="--default-key <your-key-id>" make sign` in userland.    

To change the output location to say `/tmp`, run `BUILD_DIR=/tmp/archstrike-iso-build make`.    

## Developer Notes

Over time packages change, check for issues prior to attempting to install the entire `archstrike` package group. You can do so by running the following commands in userland.
```shell
archstrike-arbitration --package archstrike
archstrike-arbitration --file archstrike-iso/configs/archstrike/packages.both
```
This should report a list of packages you can use to stdout and report issues to stderr by analyzing input.

### Sync with Upstream
The archiso submodule points to the ArchStrike fork. So, keep the master branch for `ArchStrike/archiso` up-to-date.
```shell
git -C archiso remote add upstream git@github.com:archlinux/archiso.git
git -C archiso fetch upstream
git -C archiso rebase upstream/master
git -C archiso push
```
Git submodules only support branches within the `.gitmodules` config
```shell
latest="$(git -C archiso describe --abbrev=0)"
git -C archiso checkout -b ${latest} refs/tags/${latest}
git submodule set-branch --branch "${latest}" archiso
git submodule update --remote
git add .gitmodules archiso
git commit -m "Updated archiso submodule branch to ${latest}"
```
### Update Submodule Branch


## Mirror Performance 
If you would like to improve build performance, you may wish to optimize your mirror list. Update your mirrorlist with a ranked mirrorlist by executing the following in userland.
```
reflector --country US,GE --age 12 --sort rate --save /tmp/mirrorlist-reflector
rankmirrors /tmp/mirrorlist-reflector  > /tmp/mirrorlist-ranked
sudo cp -bv /tmp/mirrorlist-ranked /etc/pacman.d/mirrorlist
```

