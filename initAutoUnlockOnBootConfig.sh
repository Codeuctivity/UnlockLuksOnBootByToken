#!/bin/sh

# reset old config 
rm -R /etc/decryptkeydevice

# copy new config
mkdir /etc/decryptkeydevice

# update device ids in in this file
cp decryptkeydevice.sh /etc/decryptkeydevice/decryptkeydevice.sh
chmod +x /etc/decryptkeydevice/decryptkeydevice.sh

cp cryptroot /etc/initramfs-tools/conf.d/cryptroot
chmod +x /etc/initramfs-tools/conf.d/cryptroot

cp decryptkeydevice.hook /etc/initramfs-tools/hooks/decryptkeydevice.hook
chmod +x /etc/initramfs-tools/hooks/decryptkeydevice.hook

# update blockids in this file
cat modules >> /etc/initramfs-tools/modules

update-initramfs -u
