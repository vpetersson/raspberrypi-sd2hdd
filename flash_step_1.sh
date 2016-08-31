#!/bin/bash -ex

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

# Don't trust the firmware revision.
rm -f /boot/.firmware_revision

apt-get update
apt-get install -y rpi-update dosfstools

BRANCH=next rpi-update

if ! grep -q program_usb_boot_mode /boot/config.txt; then
  echo program_usb_boot_mode=1 | tee -a /boot/config.txt
fi

echo "Please reboot your system to apply the firmware."
