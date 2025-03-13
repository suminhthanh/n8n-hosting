#!/bin/bash
echo "--------- 🟢 Start install domain -----------"

NEW_ID=$1
echo "Source ID: $NEW_ID"

export INTERNAL_IP=$(hostname -I | cut -f1 -d' ')
export EXTERNAL_IP="https://$(uuidgen | tr -d '-' | cut -c1-6).n8nhosting.app"

# Check if INTERNAL_IP exists in .env and exit if found
if grep -q "^INTERNAL_IP=" .env; then
    echo "INTERNAL_IP already exists in .env. Skipping and exiting."
    exit 0
fi

# Append to .env if not exists
echo "INTERNAL_IP=$INTERNAL_IP" >> .env
echo "EXTERNAL_IP=$EXTERNAL_IP" >> .env

echo "Using domain: $EXTERNAL_IP"

curl --location "https://n8n-auto.vnict.workers.dev/" \
--header "Content-Type: application/json" \
--data "{
    \"service\": \"http://$INTERNAL_IP:5678\",
    \"hostname\": \"$EXTERNAL_IP\",
    \"id\": \"$NEW_ID\"
}"

sudo -E docker compose up -d
echo "--------- 🔴 Finish! Test in browser at $EXTERNAL_IP (Internal IP: $INTERNAL_IP) -----------"
