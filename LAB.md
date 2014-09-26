LAB BONDING ACTIVE-BACKUP

I.Mục tiêu bài lab :
 
  - Hiểu được hoạt động của bonding
  - Cấu hình và test  chế độ hoạt động active-backup trong bonding
  
II. Mô hình thực hiện
<img src="">
III. Kịch bản bài Lab
 - Cài đặt bonding trên HOST chạy trên VMware
 -  Đặt chế độ bonding là active-backup
 - Dùng tool nmon,iperf để kiểm tra hoạt động của bonding.
IV. Quá trình thực hiện :

 1. Cài bằng tay : 
 
- Cài đặt gói ifenslave-2.6
  
```
 sudo apt-get install ifenslave-2.6
```
- Cấu hình các card mạng :

Ensure kernel support:
```
sudo vi /etc/modules

# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.

loop
lp
rtc
bonding
```

Configure network interfaces:
```
sudo stop networking

Then load the bonding kernel module:

sudo modprobe bonding
```
- Sửa file /etc/network/interface 
```
#eth0 is manually configured, and slave to the "bond0" bonded NIC
auto eth0
iface eth0 inet manual
bond-master bond0
bond-primary eth0

#eth1 ditto, thus creating a 2-link bond.
auto eth1
iface eth1 inet manual
bond-master bond0

# bond0 is the bonding NIC and can be used like any other normal NIC.
# bond0 is configured using static network information.
auto bond0
iface bond0 inet static
address 172.16.69.19
gateway 172.16.69.1
netmask 255.255.255.0
bond-mode active-backup
bond-miimon 100
bond-slaves none
bond-slaves eth0,eth1
```
- Khởi động lại dịch vụ mạng :

```
 /etc/init.d/networking restart
```
- Kết thúc quá trình cài đặt và cấu hình bonding.

2. Cài bằng script :

Để cài script thì làm theo hướng dẫn [ở đây] (https://github.com/vdcit/NIC_BONDING/blob/master/Bonding-ubuntu.sh)

IV.Kết quả bài test

- Dùng iperf đẩy gói tinh từ trong ra ngoài máy thât :

Trên máy VM:
```
iperf -c 172.16.69.10 -b 1G    -u --ttl 5 -t 5
```
Trên máy thật:

```
 iperf -s -u
```
- Kết quả hiển thị khi dung nmon :
<img src="">


































