#!/bin/bash

# setup DoH

# install 32bit architecture
# see https://forum.armbian.com/topic/4764-running-32-bit-applications-on-aarch64/
dpkg --add-architecture armhf

apt-get update

apt-get install libc6:armhf libstdc++6:armhf

wget -O cloudflared.tgz https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-arm.tgz \
  && tar -xzvf cloudflared.tgz \
  && rm cloudflared.tgz

./cloudflared
