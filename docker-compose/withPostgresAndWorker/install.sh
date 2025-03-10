#!/bin/bash
echo "--------- 🟢 Start install docker -----------"
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
# echo "--------- 🔴 Finish install docker -----------"

# echo "--------- 🟢 Start creating folder -----------"
# cd ~
# mkdir vol_n8n
# sudo chown -R 1000:1000 vol_n8n
# sudo chmod -R 755 vol_n8n
# echo "--------- 🔴 Finish creating folder -----------"

echo "--------- 🟢 Start docker compose up  -----------"
wget https://raw.githubusercontent.com/suminhthanh/n8n-hosting/refs/heads/main/docker-compose/withPostgresAndWorker/.env -O .env
wget https://raw.githubusercontent.com/suminhthanh/n8n-hosting/refs/heads/main/docker-compose/withPostgresAndWorker/docker-compose.yml -O compose.yaml

export INTERNAL_IP=$(hostname -I | cut -f1 -d' ')
export EXTERNAL_IP=https://$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 6 | head -n 1).n8nhosting.app
echo "Using domain: $EXTERNAL_IP"

sudo -E docker compose up -d
echo "--------- 🔴 Finish! Wait a few minutes and test in browser at url $EXTERNAL_IP for n8n UI FROM INTERNAL_IP=$INTERNAL_IP -----------"
