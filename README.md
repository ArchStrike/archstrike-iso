# ArchStrike: Customized Arch Linux ISO     
The ArchStrike ISO installs our unofficial user repository mirror through a guided installation process using [archinstall](https://wiki.archlinux.org/title/Archinstall). Our customized Arch Linux image uses [archiso](https://wiki.archlinux.org/title/archiso), which builds the official Arch Linux images.

## Requirements
Before you build or test, make sure to install any dependencies needed (i.e., [archiso dependencies](https://github.com/archlinux/archiso#requirements))
```shell
sudo pacman -S --needed make devtools edk2-ovmf erofs-utils openssl qemu
sudo pacman -S --needed arch-install-scripts bash dosfstools e2fsprogs libarchive libisoburn mtools squashfs-tools
```

## Submodule
A fixed version of the `archiso` repository is embedded as a submodule to create the ArchStrike image.
```shell
sudo pacman -S --needed make devtools
git submodule update --init --recursive --remote
```

## Creating the ArchStrike ISO
To build the ArchStrike ISO, simply run `make` in userland. Equivalently, you can run each target in userland.
```shell
make check
make clean
make build
make sign
```
To use a non-default gpg key to sign, run `GPG_OPTIONS="--default-key <your-key-id>" make sign` in userland.    

To change the output location to say `/tmp`, run `BUILD_DIR=/tmp/archstrike-iso-build make`.    

## Developer Notes
Over time packages change, check for issues prior to attempting to install the entire `archstrike` package group. You can do so by running the following commands in userland.
```shell
./bin/archstrike-arbitration --package archstrike
./bin/archstrike-arbitration --file ./configs/archstrike/packages.x86_64
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
git -C archiso fetch upstream
git -C archiso rebase upstream/master master
git -C archiso push
latest="$(git -C archiso describe --abbrev=0)"
git -C archiso checkout -b ${latest} refs/tags/${latest}
git -C archiso push -u origin refs/heads/${latest}
git submodule set-branch --branch "${latest}" archiso
git add .gitmodules archiso
git commit -m "Updated archiso submodule branch to ${latest}"
git tag -a archiso-${latest} -m "Submodule archiso branch and SHA-1 index updated to latest: refs/tags/${latest}"
git push origin HEAD refs/tags/archiso-${latest}
```

### Mirror Performance 
If you would like to improve build performance, you may wish to optimize your mirror list. Update your mirrorlist with a ranked mirrorlist by executing the following in userland.
```shell
reflector --country US --age 6 --score 30 --sort rate --save /tmp/mirrorlist
sudo cp -bv {/tmp,/etc/pacman.d}/mirrorlist
```

### Test Arch Installer Script w/o ISO
These instructions are based on the [upstream README.md](https://github.com/archlinux/archinstall#without-a-live-iso-image) for `archinstall`. Before starting, check the upstream documentation and make sure that `/dev/loop0p*` does not exist from previous testing.
```shell
truncate -s 20G testimage.img
sudo losetup -fP ./testimage.img
sudo losetup -a | grep "testimage.img" | awk -F ":" '{print $1}'
sudo pacman -Sy --needed archinstall
pushd ./configs/archstrike/airootfs/root/.config/archinstall/
```
To test USA default configuration profile, run the command below.
```shell
sudo archinstall --config ./profiles/usa-default.json --script archstrike-guided
```
To test USA the advanced configuration profile, run the command below.
```shell
sudo archinstall --config ./profiles/advanced.json --script archstrike-guided
```
Once complete, you should see a message stating `Installation completed without any errors.` If you wish to virtualize your test, then use `qemu` and your `testimage.img`.
```shell
qemu-system-x86_64 -enable-kvm -machine q35,accel=kvm -device intel-iommu -cpu host -m 4096 -boot order=d -drive file=./testimage.img,format=raw -drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/x64/OVMF_CODE.fd -drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/x64/OVMF_VARS.fd
```

### Test ArchStrike ISO in QEMU
Set the variable `image` value as the absolute path to the ArchStrike ISO.
```shell
image="${BUILD_DIR:-/opt/archstrike-iso-build}/out/archstrike-"$(date '+%Y.%m.%d')"-x86_64.iso"
```
Run the ArchStrike image using QEMU (boot type BIOS):
```shell
./archiso/scripts/run_archiso.sh -b -i ${image}
```
Run the ArchStrike image using QEMU (boot type UEFI):
```shell
./archiso/scripts/run_archiso.sh -u -i ${image}
```
