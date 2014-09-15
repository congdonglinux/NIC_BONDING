Hướng dẫn dùng script 
====================================

- Cài đặt  gói git :
```
  apt-get install git -y || yum install -y git
```

- tải  file về :
```
git clone https://github.com/vdcit/NIC_BONDING
```

- Sử dụng script :
```
cd NIC_BONDING
chmod +X *.sh
```

- Trên ubuntu :
```
  bash Bonding_ubuntu.sh
```
- Trên centos :
```
 bash Bonding_centos.sh
```
Chờ đến khi quá trình cài đặt hoàn thành.Khởi động lại card mạng hoặc khởi động lại máy:
```
 /etc/init.d/networking restart
```
or
```
init 6
```
