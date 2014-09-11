#!/bin/bash -ex

#tao bien chua dia chi mac

read -p "gateway:"gw
echo $gw

read -p "MASK:"mask
echo $mask

ipadd=`/sbin/ifconfig eth1 | grep inet | awk '{print $2}'`
#Tao card bond0

touch /etc/sysconfig/network-scripts/ifcfg-bond0

#Cau hinh ip cho cong
cat << EOF >> /etc/sysconfig/network-scripts/ifcfg-bond0
DEVICE=bond0
BOOTPROTO=none
ONBOOT=yes
IPADDR=$ipadd
NETMASK=$mask
USERCTL=no
BONDING_OPTS="mode=1 miimon=100"

EOF

cp /etc/modprobe.d/bonding.conf /etc/modprobe.d/bonding.conf.bka
###Add 
echo "alias bond0 bonding" >>/etc/modprobe.d/bonding.conf



#### Cau hinh ip cho cac card
cp /etc/sysconfig/network-scripts/ifcfg-eth1  /etc/sysconfig/network-scripts/ifcfg-eth1.bka
cp /etc/sysconfig/network-scripts/ifcfg-eth0  /etc/sysconfig/network-scripts/ifcfg-eth0.bka

cat << EOF >> /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
MASTER=bond0
SLAVE=yes
USERCTL=no
ONBOOT=yes
BOOTPROTO=none

EOF
#######################################################
cat << EOF >> /etc/sysconfig/network-scripts/ifcfg-eth0

DEVICE=eth0
MASTER=bond0
SLAVE=yes
USERCTL=no
ONBOOT=yes
BOOTPROTO=none

EOF
###########################################
#ddd module
modprobe bonding

#restart network
/etc/init.d/network restart

ifup eth0
ifup eth1
ifup bond0

#####################################################
#test thu
cat /proc/net/bonding/bond0
