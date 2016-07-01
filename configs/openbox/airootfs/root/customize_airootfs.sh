#!/bin/bash

set -e -u

__arch=$(uname -m)

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

cp -aT /etc/skel/ /root/

# Create the user directory for live session
if [ ! -d /home/archstrike ]; then
    mkdir /home/archstrike && chown -R archstrike:users /home/archstrike
fi

# Copy files over to home
cp -aT /etc/skel /home/archstrike
chown -R archstrike:users /home/archstrike/.*
chmod 755 /home/archstrike/.xinitrc
usermod -aG adm,audio,floppy,video,log,network,rfkill,scanner,storage,optical,power,wheel archstrike

#add entries for .xinitrc
#sed -i 's/# exec gnome-session/exec gnome-session/' /home/archstrike/.xinitrc

chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/g_wheel

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf


#Adding in our pacman.conf
echo "Configuring Pacman"
sed -i 's|^#CheckSpace|CheckSpace|g' /etc/pacman.conf
if [[ ${__arch} == 'x86_64' ]]; then
    	echo '' >> /etc/pacman.conf
        echo '[multilib]' >> /etc/pacman.conf
        echo 'SigLevel = PackageRequired' >> /etc/pacman.conf
        echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
fi

#start up systemctl processes
#systemctl enable multi-user.target pacman-init.service choose-mirror.service
systemctl disable sshd dhcpcd
systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target

#enable vboxclient
echo "/usr/bin/VBoxClient-all" >> /root/.xinitrc


if [[ -d "/usr/share/icons" ]]; then
		cd /usr/share/icons
		find . \
			! -iname '**Cnchi**' \
			! -iname '**image-missing.svg**' \
			! -iname '**emblem-default.svg**' \
			! -iname '**dialog-warning.svg**' \
			! -iname '**edit-undo**' \
			! -iname '**list-add**' \
			! -iname '**list-remove**' \
			! -iname '**system-run**' \
			! -iname '**edit-clear-all**' \
			! -iname 'dialog-***' \
			! -iname '**-yes.svg**' \
			! -iname '**_yes.svg**' \
			! -iname '**-no.svg**' \
			! -iname '**stock_no.svg**' \
			! -iname 'nm-***' \
			! -iname '**system-software-install**' \
			! -iname '***bluetooth***' \
			! -iname '***printer***' \
			! -iname '***firefox***' \
			! -iname '**network-server**' \
			! -iname '***preferences-desktop-font***' \
			! -iname '**fonts**' \
			! -iname '**applications-accessories**' \
			! -iname '**text-editor**' \
			! -iname '**accessories-text-editor**' \
			! -iname '**gnome-mime-x-directory-smb-share**' \
			! -iname '**terminal**' \
			! -iname '**video-display**' \
			! -iname '**go-next-symbolic**' \
			! -iname '**go-previous-symbolic**' \
			! -iname '**_close**' \
			! -iname '**-close**' \
			! -iname '**dialog-**' \
			! -iname 'nm-**' \
			! -iname 'window-**' \
			! -iname '**network**' \
			! -iname 'index.theme' \
			! -iname '**system-shutdown**' \
			! -iname '**pan-**' \
			! -iname '**symbolic**' \
			! -ipath '**Adwaita**' \
			! -ipath '**highcolor**' \
			-type f -delete
	fi



# GDK Pixbuf Bug
gdk-pixbuf-query-loaders --update-cache

# Pacstrap/Pacman bug where hooks are not run inside the chroot
/usr/bin/update-ca-trust

#make sure we dont keep any pacman pkgs in the cache
pacman -Scc --noconfirm

# Make ISO thinner
rm -rf /usr/share/{doc,gtk-doc,info,gtk-2.0,gtk-3.0} || true
rm -rf /usr/share/{man,gnome} || true

# Build kernel modules that are handled by dkms so we can delete kernel headers to save space
dkms autoinstall

# Fix sudoers
chown -R root:root /etc/
chmod 660 /etc/sudoers

# Black list floppy
echo "blacklist floppy" > /etc/modprobe.d/nofloppy.conf

# Fix QT apps
echo 'export GTK2_RC_FILES="$HOME/.gtkrc-2.0"' >> /etc/bash.bashrc

# Remove kernel headers and dkms.
pacman -Rdd --noconfirm linux-headers dkms

#disable network interface names
#ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules

# set archstrike users password to reset at login
#chage -d0 archstrike
