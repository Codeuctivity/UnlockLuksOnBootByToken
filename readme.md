Howto unlock ar ubuntu 16.04/18.04 encrypted system on boot using an removable storage: 

Be carful. If something goes wrong, your system may stop booting.

change
*) sda5_crypt -> your encrypted root
*) sda5 -> your unlocked root
*) sdb -> your removeable device that will carry the key
*) /dev/mapper/ubuntu--vg-root -> your lvm name of root (on my testmachine, this parameter was not needed)
in initAutoUnlockOnBootConfig.sh and cryptroot

change DECRYPTKEYDEVICE_DISKID="ata-VBOX_HARDDISK_VB53d36dfa-0ee59b83" 
in decryptkeydevice.sh to your removable device that will carry the key id (found in 


Add (i am not sure if this is realy needed) ",keyscript=/etc/decryptkeydevice/decryptkeydevice.sh,key=/dev/sdb" to the line of sda5_crypt (root) in /etc/crypttab

chmod +x ~/initAutoUnlockOnBootConfig.sh
sudo ./initAutoUnlockOnBootConfig.sh


The example values in the scrits and configs fit to this config:

cryptsytem02:~$ lsblk -o name,uuid,mountpoint
NAME           UUID                                   MOUNTPOINT
sda                                                   
├─sda1         7c4412c5-31ab-4f83-ae9c-6229cf4e3b3a   /boot
├─sda2                                                
└─sda5         9d003550-9fbc-433f-b94d-e0e53f7d77fa   
  └─sda5_crypt 8Pe8WC-kMxq-D09F-eqXF-dNTu-CFQ8-X9Wq3l 
    ├─ubuntu--vg-root
    │          e1ed5467-dc20-4c99-9bb8-18d9a722d6aa   /
    └─ubuntu--vg-swap_1
               0faaec1b-da87-4f44-8a82-210e2819212b   [SWAP]
sdb                                                   



Sources:
https://www.len.ro/work/luks-disk-encryption-with-usb-key-on-ubuntu-14-04/
https://wiki.ubuntuusers.de/System_verschl%C3%BCsseln/Schl%C3%BCsselableitung/
https://unix.stackexchange.com/questions/107810/why-my-encrypted-lvm-volume-luks-device-wont-mount-at-boot-time#107859
