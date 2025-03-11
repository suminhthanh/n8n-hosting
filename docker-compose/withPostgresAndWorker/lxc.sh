#!/bin/bash

# Lấy ID tiếp theo tự động từ Proxmox
NEW_ID=$(pvesh get /cluster/nextid)

echo "Sẽ tạo LXC mới với ID: $NEW_ID"

# Clone LXC container
pct clone 201 $NEW_ID --hostname n8n
pct start $NEW_ID

# Chờ container khởi động hoàn toàn
echo "Đang chờ LXC $NEW_ID khởi động..."
while ! pct exec $NEW_ID -- bash -c "echo Container Ready" &>/dev/null; do
    sleep 2
done

# Chờ mạng sẵn sàng
echo "Đang chờ mạng LXC $NEW_ID sẵn sàng..."
while ! pct exec $NEW_ID -- ping -c 1 8.8.8.8 &>/dev/null; do
    sleep 2
done

# Chạy script domain.sh bên trong container
pct exec $NEW_ID -- bash -c "curl -fsSL https://raw.githubusercontent.com/suminhthanh/n8n-hosting/main/docker-compose/withPostgresAndWorker/domain.sh | bash"

echo "LXC $NEW_ID đã sẵn sàng!"
