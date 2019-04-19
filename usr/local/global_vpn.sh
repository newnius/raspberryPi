#!/bin/bash

# restore Chineses IPs
ipset restore < /etc/chnroute.ipset

# add iptables chain
iptables -t nat -N SHADOWSOCKS

# exclude your own vps IPs

# exclude CloudFlare IPs
iptables -t nat -A SHADOWSOCKS -d 173.245.48.0/20 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 103.21.244.0/22 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 103.22.200.0/22 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 103.31.4.0/22 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 141.101.64.0/18 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 108.162.192.0/18 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 190.93.240.0/20 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 188.114.96.0/20 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 197.234.240.0/22 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 198.41.128.0/17 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 162.158.0.0/15 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 104.16.0.0/12 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 172.64.0.0/13 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 131.0.72.0/22 -j RETUR

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
iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53

exit 0
