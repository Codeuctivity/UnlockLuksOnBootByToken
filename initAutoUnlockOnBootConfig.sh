#!/bin/sh
# setting up everthing - excute as root

sudo dd if=/dev/urandom of=/dev/sdb bs=512 seek=1 count=60 

sudo dd if=/dev/sdb bs=512 skip=1 count=4 > tempKeyFile.bin 

sudo cryptsetup luksAddKey /dev/sda5 tempKeyFile.bin 

# reset old config 
#rm -R /etc/decryptkeydevice
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

