#! /bin/bash -ex
#mac='/sbin/ifconfig eth0 | grep HWaddr | awk "{ print $5}"'

mac1=`/sbin/ifconfig eth0 | grep HWaddr | awk '{print $5}'`
mac2=`/sbin/ifconfig eth1 | grep HWaddr | awk '{print $5}'`
#mac3=`/sbin/ifconfig eth2 | grep HWaddr | awk '{print $5}'`

ipaddr =`/sbin/ifconfig eth0 | grep inet | awk '{print $2}'`

read -p "gateway:" gw
echo $gw

read -p "MASK:" mask
echo $mask
#cai dat goi ho tro
sudo apt-get -y install ifenslave
#them module

cp /etc/modules   /etc/modules.bka
echo "bonding" >>/etc/modules
#-------------------------------------

#ngat mang de them card
/etc/init.d/networking stop
#load module vao kernel
sudo modprobe bonding
#

ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
cat << EOF > $ifaces
#Dat IP cho Controller node

# LOOPBACK NET 
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet manual
hwaddres $mac1
bond-master bond0

# DATA NETWORK
auto eth1
iface eth1 inet manual
hwaddress $mac2
bond-master bond0

#Data bonding
auto bond0
iface bond0 inet static
address $ipaddr
gateway $gw
netmask $mask
bond-mode 1
bond-miimon 100
bond-slaves eth0 eth1
EOF

#start networking

/etc/init.d/networking start
#test:

cat /proc/net/bonding

#---------------------------------------------
