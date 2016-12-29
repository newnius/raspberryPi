#! /bin/bash

# sudo apt-get update

# install mplyer
sudo apt install -y mplayer2

# level up USB audio card
# this conf file is in /etc/modprobe.d/alsa-base.conf if not Raspbian Jessie
# http://5aimiku.com/archives/400.html 
sudo sed -i "s/options snd-usb-audio index=-2/options snd-usb-audio index=0/g" /lib/modprobe.d/aliases.conf

echo "need reboot"
