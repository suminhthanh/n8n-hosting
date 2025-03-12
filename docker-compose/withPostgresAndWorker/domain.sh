#!/bin/bash
echo "--------- 🟢 Start install domain -----------"

NEW_ID=$1
echo "Source ID: $NEW_ID"

export INTERNAL_IP=$(hostname -I | cut -f1 -d' ')
export EXTERNAL_IP="https://$(uuidgen | tr -d '-' | cut -c1-6).n8nhosting.app"

# Ghi vào file .env
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
echo "--------- 🔴 Finish! Wait a few minutes and test in browser at url $EXTERNAL_IP for n8n UI FROM INTERNAL_IP=$INTERNAL_IP -----------"
