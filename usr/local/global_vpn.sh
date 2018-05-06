#!/bin/bash

# restore Chineses IPs
ipset restore < /etc/chnroute.ipset

# add iptables chain
iptables -t nat -N SHADOWSOCKS

# exclude your own vps IPs
iptables -t nat -A SHADOWSOCKS -d 1.2.3.4/24 -j RETURN

# excluce intranet ips & Chinese IPs
iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -m set --match-set chnroute dst -j RETURN

# redirect traffic to redsocks
iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports 12345

# redirect traffic to SHADOWSOCKS
iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS
iptables -t nat -A PREROUTING -p tcp -j SHADOWSOCKS

# overide default dns ns of devices
iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 5353

exit 0
