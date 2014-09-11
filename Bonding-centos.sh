#!/bin/bash -ex

#tao bien chua dia chi mac

GATEWAY_IP=`route -n | grep 'UG[ \t]' | awk '{print $2}'`

read -p "MASK:" mask
echo $mask

read -p "IP:" ipadd

echo $ipadd


sleep 3
#Tao card bond0

touch /etc/sysconfig/network-scripts/ifcfg-bond0

ifcfgbond0=/etc/sysconfig/network-scripts/ifcfg-bond0


#Cau hinh ip cho cong
cat << EOF >> $ifcfgbond0

DEVICE=bond0
BOOTPROTO=none
ONBOOT=yes
IPADDR=$ipadd
NETMASK=$mask
GATEWAY=$GATEWAY_IP
USERCTL=no
BONDING_OPTS="mode=1 miimon=100"
EOF
#test -f /etc/modprobe.d/bonding.conf.bka || cp /etc/modprobe.d/bonding.conf /etc/modprobe.d/bonding.conf.bka
###Add 
echo "alias bond0 bonding" >>/etc/modprobe.d/bonding.conf

#### Cau hinh ip cho cac card

ifcfgeth1=/etc/sysconfig/network-scripts/ifcfg-eth1

#test -f $ifcfgeth1.bka || cp $ifcfgeth1 $ifcfgeth1.bka

rm $ifcfgeth1

touch $ifcfgeth1

cat << EOF >> $ifcfgeth1
DEVICE=eth1
MASTER=bond0
SLAVE=yes
USERCTL=no
ONBOOT=yes
BOOTPROTO=none

EOF
#######################################################
ifcfgeth0=/etc/sysconfig/network-scripts/ifcfg-eth0

test -f $ifcfgeth0.bka || cp $ifcfgeth0 $ifcfgeth0.bka
rm $ifcfgeth0
touch $ifcfgeth0

cat << EOF >> $ifcfgeth0

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
