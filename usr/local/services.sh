#! /bin/bash

# login to p.nju.edu.cn
nohup python /usr/local/pnju.py &

# run fan control
nohup python /usr/local/fan.py &

# start frp
nohup /usr/local/frp/frpc -c /usr/local/frp/frpc.ini &

# start DoH to fuck GFW
nohup /usr/local/cloudflared proxy-dns --port 15353 &

# start global vpn service
nohup bash /usr/local/global_vpn.sh &
