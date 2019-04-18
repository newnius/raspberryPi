#! /bin/bash

sudo apt update

sudo apt install -y hostapd dnsmasq

sudo bash -c "cat >>/etc/dnsmasq.conf <<EOF
#this line existes to make sure below starts in a new line
interface=wlan0
dhcp-range=192.168.68.24,192.168.68.200,255.255.255.0,12h
EOF"

sudo bash -c "cat >/etc/hostapd/hostapd.conf <<EOF
interface=wlan0
hw_mode=g
channel=10
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
wpa_passphrase=PASSWORD
ssid=SSID
EOF"

# enable ip_forward
sudo sed -i "s/#net.ipv4.ip_forward=[01]/net.ipv4.ip_forward=1/g" /etc/sysctl.conf

# open wifi on startup
sudo sed -i "s/exit 0//g" /etc/rc.local

sudo bash -c "cat >>/etc/rc.local <<EOF
ifconfig wlan0 down
ifconfig wlan0 192.168.68.1 netmask 255.255.255.0 up
iwconfig wlan0 power off
service dnsmasq restart
hostapd -B /etc/hostapd/hostapd.conf & > /dev/null 2>&1
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

exit 0
EOF"

# sudo reboot
echo -e "now reboot to take effect"
