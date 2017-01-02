#! /bin/bash

# wait until network connection is established
wget -q --tries=5 --timeout=10 --spider http://blog.newnius.com
while ! [[ $? -eq 0 ]]
do
  echo "Waiting for network"
  sleep 5
  wget -q --tries=5 --timeout=10 --spider http://blog.newnius.com
done
echo "connected, preparing to run ssh"

# rebuild periodly to avoid connection lost
while [ true ]
do
  ps -aux | grep "ssh -NfR 8.8.8.8:2201:9.9.9.9:22 pi@8.8.8.8" | awk '{print $2 }' | xargs kill
  ssh -NfR 8.8.8.8:2201:9.9.9.9:22 pi@8.8.8.8
  sleep 7200
done
