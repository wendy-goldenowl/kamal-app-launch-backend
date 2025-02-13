#!/bin/bash
# Install Docker
apt update -y && apt install -y docker.io

# Install Docker Compose
mkdir -p ~/.docker/cli-plugins
curl -sSL https://github.com/docker/compose/releases/download/v2.11.0/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

systemctl start docker
systemctl enable docker

# Install Kamal
curl -fsSL https://kamal.run | bash

GITLAB_USER="${GITLAB_USER}"
GITLAB_TOKEN="${GITLAB_TOKEN}"

# Deploy app
cd /home/ubuntu/
git clone https://${GITLAB_USER}:${GITLAB_TOKEN}@gitlab.com/wendy-goldenowl/kamal-app-launch-backend.git
# git clone https://${GITLAB_USER}:${GITLAB_TOKEN}@gitlab.com/wendy-goldenowl/kamal-app-launch-frontend.git

# Chạy backend bằng Docker Compose
cd kamal-app-launch-backend
# docker compose up -d

# Build & chạy frontend từ Dockerfile
# cd ../kamal-app-launch-frontend
# docker build -t frontend-app .
# docker run -d -p 3000:3000 --name frontend-container frontend-app