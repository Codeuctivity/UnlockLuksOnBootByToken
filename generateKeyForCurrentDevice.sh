#!/bin/sh
# generates a decryption key for the current /dev/sdb

dd if=/dev/urandom of=/dev/sdb bs=512 seek=1 count=60 

dd if=/dev/sdb bs=512 skip=1 count=4 > tempKeyFile.bin 

cryptsetup luksAddKey /dev/sda5 tempKeyFile.bin 