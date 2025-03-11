#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://ubuntu.com/

echo -e "Loading..."
APP="Ubuntu"
var_tags="os"
var_cpu="1"
var_ram="1024"
var_disk="8"
var_os="ubuntu"
var_version="24.04"

header_info "$APP"
variables
color
catch_errors

function install_docker() {
  echo "--------- 🟢 Start install docker -----------"
  sudo apt-get update -y
  sudo apt-get install -y ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo \  
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \  
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \  
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  echo "--------- 🔴 Finish install docker -----------"
}

function setup_n8n() {
  echo "--------- 🟢 Start docker compose up  -----------"
  wget https://raw.githubusercontent.com/suminhthanh/n8n-hosting/refs/heads/main/docker-compose/withPostgresAndWorker/.env -O .env
  wget https://raw.githubusercontent.com/suminhthanh/n8n-hosting/refs/heads/main/docker-compose/withPostgresAndWorker/docker-compose.yml -O compose.yaml

  export INTERNAL_IP=$(hostname -I | cut -f1 -d' ')
  export EXTERNAL_IP=https://$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 6 | head -n 1).n8nhosting.app
  echo "Using domain: $EXTERNAL_IP"

  curl --location "https://n8n-auto.vnict.workers.dev/" \
  --header "Content-Type: application/json" \
  --data "{\"service\": \"http://$INTERNAL_IP:5678\",\"hostname\": \"$EXTERNAL_IP\"}"

  sudo -E docker compose up -d
  echo "--------- 🔴 Finish! Wait a few minutes and test in browser at url $EXTERNAL_IP for n8n UI FROM INTERNAL_IP=$INTERNAL_IP -----------"
}

start
build_container
description
install_docker
setup_n8n

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:5678${CL}"
