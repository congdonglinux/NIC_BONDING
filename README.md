NIC BONDING
===========================================================
### Tổng quan về NIC BONDING

#### 1. NIC BONDING :

- Kết hợp nhiều card mạng thành một card mạng tổng
 => Việc này giúp  tăng tính sẵn sàng(HA) của  các card mạng và hiệu năng làm việc

- Các tham số hay sử dụng trong Bonding ( ở mức OS) :

- Updelay :
 > Quy định cụ thể thời gian, trong mili giây , chờ đợi trước khi bật
   một card mạng  sau khi thiểt lập liên kết.
 > Giá trị mặc định là 0
- Downdelay:
 > Quy định cụ thể thời gian, trong mili giây , chờ đợi trước khi vô hiệu hóa
   một card mạng  sau khi thất bại liên kết đã được phát hiện.
 > Giá trị mặc định là 0

- Miinon:

Các chế độ thiết lập cho  card chạy chế độ bonding :
 
- mode=0 (Balance Round Robin):
 > Chế độ này cho phép truyền tải các gói tin đều trên card mạng vật lý.
 > Chế độ này giúp cân bằng tải và chống chịu lỗi.
- mode=1 (Active backup) : 
 > Chế độ này  khi 1 card đang sử dụng bị down , hệ thống sẽ tự động chuyển traffic sang những card  còn lại.
 > Chỉ có 1 card mạng được phép hoạt động.
 > chế độ này giúp khả năng chống lỗi.
- mode=2 (Balance XOR) :
 > Truyền traffic thông qua  phép toán XOR giữa source MAC nguồn với source MAC đích.
 > Kiểm tra các địa chỉ mac nguồn và mac đích  của các card mạng đuơc bonding quản lý.
 > Cung cấp cân bằng tải và khả năng chống chịu lỗi.

- mode=3 (Broadcast):
 > Khi bonding sử dụng chế độ này toàn bộ traffic sẽ  truyền ra tất cả các card mạng được bonding quản lý.
 > Dễ gây hiện tượng DUP! trong mạng => gói tin ARP không tìm dược địa chỉ mac để truyền.
- mode=4 (802.3ad):
=> Thông thường  hay sử dụng các mode =0,1,2 để  thiết lập cho card bonding.
####. 2. CÀI ĐẶT VÀ CẤU HÌNH:
Bài hướng dẫn này  cấu hình trên Centos 6.5

- Tạo card mạng bond0 :

```
vi /etc/sysconfig/network-scripts/ifcfg-bond0

DEVICE=bond0 
IPADDR=172.16.69.77 
NETMASK=255.255.255.0 
GATEWAY=172.16.69.1 
USERCTL=no 
BOOTPROTO=none 
ONBOOT=yes

```
- Sửa file cấu hình  card eth0:
```
vi /etc/sysconfig/network-scripts/ifcfg-eth0

DEVICE=eth0 
BOOTPROTO=none 
ONBOOT=yes 
# Settings for Bond 
MASTER=bond0 
SLAVE=yes

```
- Sửa file cấu hình  card eth0:
```
vi /etc/sysconfig/network-scripts/ifcfg-eth0

DEVICE=eth0 
BOOTPROTO=none 
ONBOOT=yes 
#Settings for Bond 
MASTER=bond0 
SLAVE=yes

```
- Thiết lập thông số cho card bond0 :
 
```
 - Thêm vào trong file /etc/modprobe.conf

```
- bonding commands
```
alias bond0 bonding 
options bond0 mode=1 miimon=100

```
- Load driver module  from the CMD:
```
modprobe bonding
```
- Khởi động lại dịch vụ network:

```
service network  restart
```
