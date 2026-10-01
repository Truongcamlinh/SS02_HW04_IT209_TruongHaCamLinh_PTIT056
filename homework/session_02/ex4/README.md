# Bài 4 - Cấu hình tường lửa UFW và DigitalOcean Cloud Firewall

**Sinh viên:** Trương Hà Cẩm Linh  
**Mã sinh viên:** PTIT056  
**Môn học:** IT209

## Mô hình bảo vệ hai lớp

1. **DigitalOcean Cloud Firewall:** chặn gói tin không hợp lệ ngay tại biên mạng trước khi chúng đến Droplet.
2. **UFW trên Ubuntu:** kiểm soát lần cuối tại hệ điều hành, chỉ cho phép SSH và HTTP đi vào.

Luồng hợp lệ:

```text
Internet → Cloud Firewall (22, 80) → UFW (22, 80) → SSH/Nginx
```

## Cấu hình UFW

Trên Ubuntu Droplet:

```bash
cd homework/session_02/ex4
chmod +x configure-ufw.sh collect-evidence.sh
sudo ./configure-ufw.sh
```

Script mở cổng SSH trước khi kích hoạt UFW để tránh khóa phiên đang quản trị. Các chính sách được áp dụng:

```text
Default: deny (incoming), allow (outgoing)
22/tcp: ALLOW IN
80/tcp: ALLOW IN
```

## Cấu hình Cloud Firewall

Thực hiện theo [cloud-firewall-rules.md](cloud-firewall-rules.md). Khuyến nghị chỉ cho phép SSH từ IP cá nhân theo CIDR `/32`; HTTP được phép từ mọi nguồn IPv4 và IPv6.

## Thu thập bằng chứng

Sau khi cấu hình UFW xong, chạy:

```bash
sudo ./collect-evidence.sh
```

Lệnh tạo file `ufw-status.txt` từ output thật của `sudo ufw status verbose`.

Ảnh chụp DigitalOcean Console cần đặt tại:

```text
screenshots/digitalocean-cloud-firewall.png
```

Ảnh phải nhìn rõ hai inbound rule cổng 22, 80 và Droplet đã được gán. Không sử dụng ảnh minh họa thay cho kết quả thật.

## Kiểm tra

Trên Droplet:

```bash
sudo ufw status verbose
sudo ss -lntp
curl -I http://localhost
```

Từ máy cá nhân:

```bash
ssh root@<IP_ADDRESS_DROPLET>
curl -I http://<IP_ADDRESS_DROPLET>
nc -vz -w 5 <IP_ADDRESS_DROPLET> 22
nc -vz -w 5 <IP_ADDRESS_DROPLET> 80
nc -vz -w 5 <IP_ADDRESS_DROPLET> 8080
```

Kết quả mong đợi:

- SSH cổng 22 kết nối thành công.
- HTTP cổng 80 trả response từ Nginx.
- Cổng 8080 và các cổng không được mở bị timeout hoặc từ chối.
- `ufw status verbose` hiển thị `Status: active`, `deny (incoming)` và `allow (outgoing)`.

Ping dùng ICMP, không phải phép kiểm tra chính xác cho trạng thái cổng TCP. Vì vậy bài kiểm tra sử dụng `nc` vào một cổng không mở.

## Lưu ý an toàn

- Không đóng phiên SSH hiện tại trước khi xác nhận rule 22/tcp hoạt động.
- Nên mở thêm một terminal và thử SSH lại trước khi thoát phiên cũ.
- Nếu đổi SSH sang cổng khác, phải mở cổng mới ở cả UFW và Cloud Firewall trước khi sửa cấu hình SSH.
