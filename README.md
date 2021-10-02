# ArchStrike: Customized Arch Linux ISO     
The archstrike-iso project is a customization of the official Arch Linux archiso releng profile. The submodule archiso is needed to create a custom live media. If you have not already, please review `archiso/README.rst`.   

## Initialize Submodule
Make sure to initialize the archiso submodule (i.e. `git submodule init --update --recursive`).

## Requirements
To create the image make sure to satisfy the `archstrike-iso` dependencies.
 * `git submodule init archiso`
 * `git submodule update --remote`
 * `archstrike-installer`
 * `reflector`
 * `arch-install-scripts`
 * `lynx`
 * `gcc-libs`
 * `devtools`

The [archiso requirements](https://github.com/archlinux/archiso#requirements) must be satisfied as well: 

```
# pacman -S --asexplicit archiso && pacman -R archiso
```

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

### Sync Submodule with Upstream
The archiso submodule points to the ArchStrike fork and the submodule URL default uses the HTTPS protocol. If
you prefer to authenticate using SSH, then update the URL within the submodule.
```shell
git -C archiso config remote.origin.url git@github.com:ArchStrike/archiso.git
```
If configured correctly, then you will be able to push changes to `ArchStrike/archiso` and keep it up-to-date with upstream.
```shell
git -C archiso remote add upstream git@github.com:archlinux/archiso.git
git -C archiso fetch upstream
git -C archiso rebase upstream/master master
git -C archiso push
```

### Latest ISO Tracking
Breaking changes in `archiso` can block the critical path for doing a new ISO release. The latest successful ISO build is tracked on `master`.
```shell
latest="$(git -C archiso describe --abbrev=0)"
git -C archiso checkout -b ${latest} refs/tags/${latest}
git -C archiso push -u origin refs/heads/${latest}
git submodule set-branch --branch "${latest}" archiso
git add .gitmodules archiso
git commit -m "Updated archiso submodule branch to ${latest}"
git tag -a archiso-${latest} -m "Submodule archiso branch and SHA-1 index updated to latest: refs/tags/${latest}"
git push origin HEAD refs/tags/archiso-${latest}
```

## Mirror Performance 
If you would like to improve build performance, you may wish to optimize your mirror list. Update your mirrorlist with a ranked mirrorlist by executing the following in userland.
```
reflector --country US,GE --age 12 --sort rate --save /tmp/mirrorlist-reflector
rankmirrors /tmp/mirrorlist-reflector  > /tmp/mirrorlist-ranked
sudo cp -bv /tmp/mirrorlist-ranked /etc/pacman.d/mirrorlist
```

