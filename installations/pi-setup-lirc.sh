#! /bin/bash

sudo apt update

sudo apt install -y lirc

sudo sed -i 's/DRIVER="UNCONFIGURED"/DRIVER="default"/g' /etc/lirc/hardware.conf
sudo sed -i 's/DEVICE=""/DEVICE="\/dev\/lirc0"/g' /etc/lirc/hardware.conf
sudo sed -i 's/MODULES=""/MODULES="lirc-rpi"/g' /etc/lirc/hardware.conf

# enable  lirc-rpi
sudo sed -i 's/#dtoverlay=lirc-rpi/dtoverlay=lirc-rpi,gpio_in_pin=24,gpio_out_pin=10/g' /boot/config.txt

# record
# irrecord -d /dev/lirc0 ~/lircd.conf

cd ~
wget https://github.com/newnius/raspberryPi/raw/master/installations/lircd.conf
sudo mv ~/lircd.conf /etc/lirc/lircd.conf

# add .lircrc events
wget https://github.com/newnius/raspberryPi/raw/master/installations/.lircrc

sudo reboot
# irexec -d
