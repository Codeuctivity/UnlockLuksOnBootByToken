# Unlock a Ubuntu 16.04/18.04 encrypted system on boot using a removable storage

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/fd6cf6c43b9542fc90fc2bb038a648a4)](https://app.codacy.com/app/stesee/UnlockLuksOnBootByToken?utm_source=github.com&utm_medium=referral&utm_content=Codeuctivity/UnlockLuksOnBootByToken&utm_campaign=Badge_Grade_Dashboard)

The example values in the scripts and configs fit this config:

```shell
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
```

## Setup

Thoroughly follow the steps specified below.

> **Warning:** Be careful! If something goes wrong, your system may stop booting!

### 1. Adjust parameters in `cryptroot` and `generateKeyForCurrentDevice.sh`

Replace the following values according to your system (use `$ lslbk` to get your parameters):

- `sda5_crypt` -> your encrypted root partition

- `sda5` -> your unlocked root partition

- `sdb` -> your removeable device that will carry the key

- `/dev/mapper/ubuntu--vg-root` -> your lvm name of root (on my test machine, this parameter was not needed)

### 2. Adjust parameters in `decryptkeydevice.sh`

Change the value of `DECRYPTKEYDEVICE_DISKID` to the ID of your **removable device** that will carry the decryption key.

You may get the ID of the device via:

```shell
$ ls /dev/disk/by-id/
```

> **NOTE:** You can specify multiple device ID's separated by a blank. This requires setting up each device individually as described in step 3.

### 3. Set up the decryption key

First, run:

```shell
$ chmod +x ./generateKeyForCurrentDevice.sh
```

Subsequently, run once for each device that should carry a decryption key:

```shell
$ sudo ./generateKeyForCurrentDevice.sh
```

Enter an existing decryption pass phrase when asked to do so.

This creates the decryption key in the boot sector of the device and then adds it to your LUKS config. This also means that each removeable device will have a different decryption key.

> **NOTE:** Make sure to keep only one device at a time connected to your machine, otherwise this won't work properly.

### 4. Update the boot partition

Create a backup of your `initrd.img`:

```shell
$ ls /boot/initrd*
initrd.img-4.15.0-29-generic  initrd.img-4.15.0-39-generic
$ sudo cp /boot/initrd.img-4.15.0-39-generic /boot/initrd.img-4.15.0-39-generic.bak
```

Then add the scripts to your boot config:

```shell
$ chmod +x ./initAutoUnlockOnBootConfig.sh
$ sudo ./initAutoUnlockOnBootConfig.sh
```

If no error occurred during execution, you should be good to reboot. Otherwise, check the previous steps again and adjust you config. Then run again. If the error persists, restore you backed up `initrd.img`, otherwise you will most likely not be able to boot!

> NOTE: If you have previously run `initAutoUnlockOnBootConfig.sh, you will get an error that the directory /etc/decryptkeydevice already exists. You can ignore this one!

## Sources

<https://www.len.ro/work/luks-disk-encryption-with-usb-key-on-ubuntu-14-04/>

<https://wiki.ubuntuusers.de/System_verschl%C3%BCsseln/Schl%C3%BCsselableitung/>

<https://unix.stackexchange.com/questions/107810/why-my-encrypted-lvm-volume-luks-device-wont-mount-at-boot-time#107859>
