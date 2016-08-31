#!/bin/bash -ex

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

set +x
OTPDUMP=$(vcgencmd otp_dump | grep 17:)
if [[ "$OTPDUMP" != "17:3020000a" ]]; then
    echo "Oh-oh. USB support not found."
    exit 1
fi

echo "!!! WARNING !!!"
echo "We will now remove everything from /dev/sda."
echo "If you don't want to proceed, press ^C now."
echo "!!! WARNING !!!"
read
set -x

parted -s /dev/sda mktable msdos
parted -s /dev/sda mkpart primary fat32 0% 100M
parted -s /dev/sda mkpart primary ext4 100M 100%

mkfs.vfat -n BOOT -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

mkdir -p /mnt/target
mount /dev/sda2 /mnt/target/
mkdir -p /mnt/target/boot
mount /dev/sda1 /mnt/target/boot/
apt-get -y install rsync

rsync \
    -ax \
    --progress \
    --exclude 'var/swap' \
    --exclude 'var/cache/apt' \
    --exclude 'boot.bak' \
    --exclude 'lib/modules.bak' \
    / /boot /mnt/target

sed -i "s,root=/dev/mmcblk0p2,root=/dev/sda2," /mnt/target/boot/cmdline.txt
sed -i "s,/dev/mmcblk0p,/dev/sda," /mnt/target/etc/fstab
rm -f /mnt/target/etc/ssh/ssh_host*
sed -i 's/exit 0/ssh-keygen -A\n\nexit 0/' /mnt/target/etc/rc.local

sync
umount /mnt/target/boot
umount /mnt/target

echo "Run 'shutdown -h now ' to power off your Raspberry Pi."
