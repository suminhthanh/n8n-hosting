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
var_version="24.10"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  $STD curl -fsSL https://raw.githubusercontent.com/suminhthanh/n8n-hosting/main/docker-compose/withPostgresAndWorker/install.sh | bash
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:5678${CL}"
