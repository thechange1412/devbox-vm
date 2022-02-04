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

wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
unzip -o ngrok-stable-linux-amd64.zip > /dev/null 2>&1
clear
read -p "Paste authtoken here (Copy and Ctrl+V to paste then press Enter): " CRP

./ngrok authtoken $CRP 

echo "======================="
echo "choose ngrok region (for better connection)."
echo "======================="
echo "us - United States (Ohio)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"
read -p "choose ngrok region: " rg

nohup ./ngrok tcp --region $rg 30889 &>/dev/null &

wget -O lite11.qcow2 https://app.vagrantup.com/cvhnups/boxes/Qcow2/versions/1.0/providers/aws.box

qemu-img resize lite11.qcow2 45G

nohup kvm -nographic -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga qxl -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=lite11.qcow2,index=0,media=disk,format=qcow2 -boot once=d &>/dev/null &

clear
echo "Script by CVHNups, Windows img file by ThuongHai (https://github.com/kmille36)"
echo Ip: 
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo User: Administrator
echo Password: Thuonghai001
echo Wait 2-4m VM boot up before connect. 
