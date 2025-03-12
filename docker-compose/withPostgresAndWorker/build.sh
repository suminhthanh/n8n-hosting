wget https://raw.githubusercontent.com/suminhthanh/n8n-hosting/refs/heads/main/docker-compose/withPostgresAndWorker/.env -O .env
wget https://raw.githubusercontent.com/suminhthanh/n8n-hosting/refs/heads/main/docker-compose/withPostgresAndWorker/docker-compose.yml -O compose.yaml
wget http://ava.webpilot.cc/n8n/Dockerfile-ffmpeg -O Dockerfile-ffmpeg
docker compose build
