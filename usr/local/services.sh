#! /bin/bash

# login to p.nju.edu.cn
nohup python /usr/local/pnju.py &

# run fan control
nohup python /usr/local/fan.py &

# start reverse ssh
nohup bash /usr/local/reverse_ssh.sh &

# start EasyRemote client
nohup python /usr/local/client.py &

# start frp
nohup /usr/local/frp/frpc -c /usr/local/frp/frpc.ini &

# start tcp dns
nohup python /usr/local/Tcp-DNS-proxy/tcpdns.py -f /usr/local/Tcp-DNS-proxy/tcpdns.json &

# start global vpn service
nohup bash /usr/local/global_vpn.sh &
