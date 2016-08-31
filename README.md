# raspberrypi-sd2hdd

Experimental scripts for migrating for SD cards to the new experimental USB boot support on the Raspberry Pi 3.

These scripts implements the [official guide](https://github.com/raspberrypi/documentation/blob/master/hardware/raspberrypi/bootmodes/msd.md) in an automatic fashion (with some minor improvements).

## Usage

* Boot your Raspberry Pi 3
* Attach a USB hard drive
* Clone this repository
* Run `./flash_step_1.sh`
* Reboot your system
* Run `./flash_step_2.sh`
* Shut down your system
* Remove the SD card
* Boot the system with the HDD attached.
