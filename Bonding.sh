#!/bin/bash -ex

NIC1=eth0
NIC2=eth1
BOND0=bond0
ADD=172.16.69.254
GATEWAY=172.16.69.1
NET=172.16.69.0
MASK=255.255.255.0
DNS=8.8.8.8
BROADCAST=172.16.69.255
MODE=4
#---------END DEFINING PARAMETERS-------------------------------------------------------------------------
#Install ifenslave packet
sudo apt-get -y install ifenslave-2.6
#Add bonding parameter to boot automatically
#echo "Adding bond interface into /etc/modules"
sleep 3
echo "bonding" >> /etc/modules
#Load bonding kernel module
sudo modprobe bonding
#Configure bonding interface
echo "Configure bonding interface in /etc/network/interfaces"
sleep 3
IFACES=/etc/network/interfaces
test -f $IFACES.orig || cp $IFACES $IFACES.orig
rm $IFACES
touch $IFACES
cat << EOF >> $IFACES
#Define loopback interface
# LOOPBACK INTERFACE
auto lo
iface lo inet loopback
#Configure first NIC1
auto $NIC1
iface $NIC1 inet manual
bond-master bond0
#Configure second NIC2
auto $NIC2
iface $NIC2 inet manual
bond-master bond0	
# DEFINE BONDING INTERFACE
auto $BOND0
iface $BOND0 inet static
# For jumbo frames, change mtu to 9000
mtu 1500
address $ADD
netmask $MASK
network $NET
broadcast $BROADCAST
gateway $GATEWAY
dns-nameservers $DNS
bond-miimon 100  
bond-downdelay 200 
bond-updelay 200 
bond-mode $MODE
bond-lacp-rate 1
#bond-xmit-hash-policy layer2+3
#txqueuelen 10000
bond-slaves none 
EOF
