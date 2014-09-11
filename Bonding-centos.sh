#!/bin/bash -ex

#tao bien chua dia chi mac

read -p "gateway:" gw
echo $gw

read -p "MASK:" mask
echo $mask

ipadd=`/sbin/ifconfig eth1 | grep inet | awk '{print $2}'`

echo $ipadd

#Tao card bond0

touch /etc/sysconfig/network-scripts/ifcfg-bond0

ifcfg-bond0=/etc/sysconfig/network-scripts/ifcfg-bond0


#Cau hinh ip cho cong
cat << EOF >> $ifcfg-bond0

DEVICE=bond0
BOOTPROTO=none
ONBOOT=yes
IPADDR=$ipadd
NETMASK=$mask
USERCTL=no
BONDING_OPTS="mode=1 miimon=100"

EOF
test -f /etc/modprobe.d/bonding.conf.bka || cp /etc/modprobe.d/bonding.conf /etc/modprobe.d/bonding.conf.bka
###Add 
echo "alias bond0 bonding" >>/etc/modprobe.d/bonding.conf

#### Cau hinh ip cho cac card

ifcfg-eth1=/etc/sysconfig/network-scripts/ifcfg-eth1

test -f $ifcfg-eth1.bka || cp $ifcfg-eth1 $ifcfg-eth1.bka

rm $ifcfg-eth1

touch $ifcfg-eth1

cat << EOF >> $ifcfg-eth1
DEVICE=eth1
MASTER=bond0
SLAVE=yes
USERCTL=no
ONBOOT=yes
BOOTPROTO=none

EOF
#######################################################
ifcfg-eth0=/etc/sysconfig/network-scripts/ifcfg-eth0

test -f $ifcfg-eth0.bka || cp $ifcfg-eth0 $ifcfg-eth0.bka
rm $ifcfg-eth0
touch $ifcfg-eth0

cat << EOF >> $ifcfg-eth0

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
