# DigitalOcean Cloud Firewall Rules

## Inbound Rules

| Type | Protocol | Port | Sources |
|---|---|---:|---|
| SSH | TCP | 22 | IP quản trị cá nhân `/32` (khuyến nghị) hoặc `0.0.0.0/0`, `::/0` |
| HTTP | TCP | 80 | `0.0.0.0/0`, `::/0` |

Không thêm inbound rule cho các cổng dịch vụ khác.

## Outbound Rules

Giữ các outbound rule mặc định của DigitalOcean để Droplet có thể cập nhật gói, phân giải DNS và kết nối ra Internet.

## Các bước trên DigitalOcean Console

1. Mở `Networking` → `Firewalls` → `Create Firewall`.
2. Đặt tên firewall, ví dụ `ptit-web-firewall`.
3. Tạo đúng hai inbound rule SSH và HTTP như bảng trên.
4. Giữ outbound rules mặc định.
5. Trong phần `Apply to Droplets`, chọn đúng Droplet đang chạy Nginx.
6. Tạo firewall và chụp màn hình phần inbound rules cùng Droplet đã gán.
7. Lưu ảnh thành `screenshots/digitalocean-cloud-firewall.png`.

Cloud Firewall lọc lưu lượng ở biên mạng DigitalOcean. UFW tiếp tục lọc lần hai trong Ubuntu nếu lưu lượng đã đi qua lớp cloud.
