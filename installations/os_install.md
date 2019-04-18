# OS install

Based on MacOS

## Format SD card

download [SD Memory Card Formatter](https://www.sdcard.org/downloads/formatter/)

and format the SD card

## Download rasbian img file

download from [Raspbian Download Page](https://www.raspberrypi.org/downloads/raspbian/)

## Unmount SD card

```bash
# use `diskutil list` to see disk name
diskutil unmountDisk /dev/disk2
```

## dd img to SD card

```bash
sudo dd if=raspbian-stretch-lite.img of=/dev/rdisk2 bs=1m;sync
```

*use rdisk to boost, or it would takes rather a long time to write the image*

## Create ssh dir to enable ssh service

Create a dir named `ssh` under the root dir of SD card to enable ssh service

## Eject SD card

```bash
diskutil eject /dev/
```

## Update mirror (if necessary)

A full list of mirrors located at [Raspbian Mirrors](https://www.raspbian.org/RaspbianMirrors)

```
# /etc/apt/sources.list
deb https://mirrors.ustc.edu.cn/raspbian/raspbian/ stretch main contrib non-free rpi

# /etc/apt/sources.list.d/raspi.list
deb https://archive.raspberrypi.org/debian/ stretch main ui
```

*use ssl to get rid of `Hash Sum mismatch`. I hate the ICPs!*

## How to find the ip address

### By a monitor which supports HDMI

### Scan the network with nmap

### In the router management panel

## Ref

[MacOS下树莓派烧录img/iso文件到SD卡](https://www.jianshu.com/p/e95c406badaa)

[解决macOS使用dd指令写入/读取速度过慢的问题](https://zhuanlan.zhihu.com/p/34603784)

[系列 - 树莓派装机（二）](https://www.barretlee.com/blog/2018/06/14/rasyberry-pi-os/)

