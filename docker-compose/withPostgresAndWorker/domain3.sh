#!/bin/bash
echo "--------- 🟢 Start install domain -----------"

NEW_ID=$1
echo "Source ID: $NEW_ID"

# Check if INTERNAL_IP exists in .env and exit if found
# if grep -q "^INTERNAL_IP=" .env; then
#     echo "INTERNAL_IP already exists in .env. Skipping and exiting."
#     exit 0
# fi

export INTERNAL_IP=$(hostname -I | cut -f1 -d' ')
export EXTERNAL_IP="https://$(uuidgen | tr -d '-' | cut -c1-6).n8nhosting.app"

# Append to .env
echo "INTERNAL_IP=$INTERNAL_IP" >> .env
echo "EXTERNAL_IP=$EXTERNAL_IP" >> .env

echo "Using domain: $EXTERNAL_IP"

# Register domain
curl --location "https://n8n-auto.vnict.workers.dev/" \
--header "Content-Type: application/json" \
--data "{
    \"service\": \"http://$INTERNAL_IP:5678\",
    \"hostname\": \"$EXTERNAL_IP\",
    \"id\": \"8008$NEW_ID\"
}"

# Update n8n.service file
SERVICE_FILE="/etc/systemd/system/n8n.service"
if [ -f "$SERVICE_FILE" ]; then
    echo "Updating systemd service file..."

    # Backup before edit
    cp $SERVICE_FILE "$SERVICE_FILE.bak"

    # Remove all existing Environment lines
    sed -i '/^Environment=/d' $SERVICE_FILE

    # Add new Environment lines
    sed -i "/^\[Service\]/a Environment=\"NODE_ENV=production\"" $SERVICE_FILE
    sed -i "/^\[Service\]/a Environment=\"N8N_PERSONALIZATION_ENABLED=false\"" $SERVICE_FILE
    sed -i "/^\[Service\]/a Environment=\"N8N_SECURE_COOKIE=false\"" $SERVICE_FILE
    sed -i "/^\[Service\]/a Environment=\"N8N_DIAGNOSTICS_ENABLED=false\"" $SERVICE_FILE
    sed -i "/^\[Service\]/a Environment=\"N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true\"" $SERVICE_FILE
    sed -i "/^\[Service\]/a Environment=\"N8N_DEFAULT_LOAD_ALL_NODES=false\"" $SERVICE_FILE
    sed -i "/^\[Service\]/a Environment=\"GENERIC_TIMEZONE=Asia/Ho_Chi_Minh\"" $SERVICE_FILE
    sed -i "/^\[Service\]/a Environment=\"N8N_EDITOR_BASE_URL=$EXTERNAL_IP\"" $SERVICE_FILE
    sed -i "/^\[Service\]/a Environment=\"WEBHOOK_URL=$EXTERNAL_IP\"" $SERVICE_FILE

    # Reload systemd and restart n8n
    systemctl daemon-reexec
    systemctl daemon-reload
    systemctl restart n8n
    
    # sleep 10
    # sudo systemctl status n8n

    echo "Systemd service updated and n8n restarted."
else
    echo "n8n.service file not found! Skipping systemd update."
fi

echo "--------- 🔴 Finish! Test in browser at $EXTERNAL_IP (Internal IP: $INTERNAL_IP) -----------"
