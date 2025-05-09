#!/bin/bash
# Nhập ID của container cần clone từ bàn phím
SOURCE_ID=$1
echo "Source ID: $SOURCE_ID"

# exit 0

# Lấy ID tiếp theo tự động từ Proxmox
NEW_ID=$(pvesh get /cluster/nextid)

echo "Sẽ tạo LXC mới với ID: $NEW_ID"

# Clone LXC container
pct clone $SOURCE_ID $NEW_ID --hostname n8n --full
pct start $NEW_ID

# Chờ container khởi động hoàn toàn
echo "Đang chờ LXC $NEW_ID khởi động..."
while ! pct exec $NEW_ID -- systemctl is-system-running --quiet; do
    echo "Đang chờ container khởi động..."
    sleep 5
done
sleep 5

# Chạy script domain.sh bên trong container
echo "Chạy script domain.sh bên trong container..."
pct exec $NEW_ID -- bash -c "curl -fsSL -o- https://raw.githubusercontent.com/suminhthanh/n8n-hosting/main/docker-compose/withPostgresAndWorker/n8nrun.sh | bash -s -- $NEW_ID"
echo "LXC $NEW_ID đã sẵn sàng!"
sleep 2
