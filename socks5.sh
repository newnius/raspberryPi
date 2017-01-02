#! /bin/bash

while [ true ]
do
  cnt=`netstat -nultp 2>/dev/null | grep -c '192.168.68.1:7001'`
  if [ ${cnt} -eq 0 ]; then
    echo "connection lose"
    ssh -NfD 192.168.68.1:7001 band -E /var/log/socks_band.log
    echo "connected"
  fi
  sleep 30
done
