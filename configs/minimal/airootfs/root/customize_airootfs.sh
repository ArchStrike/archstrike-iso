#!/usr/bin/env bash

set -e -u

__arch=$(uname -m)

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

cp -aT /etc/skel/ /root/

chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/g_wheel

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf


#Adding in our pacman.conf
printf '%s\n' 'Configuring Pacman'
sed -i 's|^#CheckSpace|CheckSpace|g' /etc/pacman.conf

if [[ "$__arch" = 'x86_64' ]]; then
    printf '\n%s\n%s\n%s\n' '[multilib]' 'SigLevel = PackageRequired' 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
fi

#start up systemctl processes
#systemctl enable multi-user.target pacman-init.service choose-mirror.service
systemctl disable sshd dhcpcd
systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target

# Pacstrap/Pacman bug where hooks are not run inside the chroot
/usr/bin/update-ca-trust

#make sure we dont keep any pacman pkgs in the cache
pacman -Scc --noconfirm

# Make ISO thinner
rm -rf /usr/share/{doc,gtk-doc,info,gtk-2.0,gtk-3.0} || true
rm -rf /usr/share/{man,gnome,X11} || true

# Build kernel modules that are handled by dkms so we can delete kernel headers to save space
dkms autoinstall

# Fix sudoers
chown -R root:root /etc/
chmod 660 /etc/sudoers

# Black list floppy
printf '%s\n' 'blacklist floppy' > /etc/modprobe.d/nofloppy.conf

# Remove dkms.
pacman -Rdd --noconfirm dkms

# sync pacman dbs
pacman -Syy

# modify /etc/issue
echo "ArchStrike Minimal | Linux kernel version: \\r | tty: (\\l)


Welcome to the ArchStrike Minimal ISO!

Run 'install-archstrike' to start the installation.

Website     https://archstrike.org
Twitter     @ArchStrike
IRC         #archstrike @ freenode.net


" > /etc/issue
