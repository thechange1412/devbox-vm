#!/bin/bash

cd /home/developer

availableRAMcommand="free -m | tail -2 | head -1 | awk '{print \$7}'"
availableRAM=$(echo $availableRAMcommand | bash)
custom_param_ram="-m "$(expr $availableRAM - 856 )"M"
cpus=$(lscpu | grep CPU\(s\) | head -1 | cut -f2 -d":" | awk '{$1=$1;print}')

apt-get update

apt-get install unzip wget curl qemu-kvm python3 gcc g++ make libglib2.0-dev \
libfdt-dev libpixman-1-dev zlib1g-dev pkg-config libjpeg-dev libssl-dev \
xz-utils libspice-protocol-dev libspice-server-dev -y

wget -O lite11.qcow2 https://app.vagrantup.com/cvhnups/boxes/Qcow2/versions/1.0/providers/aws.box

nohup kvm -nographic -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga qxl -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=lite11.qcow2,index=0,media=disk,format=qcow2 -boot once=d &>/dev/null &

clear
echo "Script by CVHNups, Windows img file by ThuongHai (https://github.com/kmille36)"
echo IP: 127.0.0.1:30889
echo User: Administrator
echo Password: cvhnups123@
echo Wait 2-4m VM boot up before connect. 
