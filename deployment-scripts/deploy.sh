#!/bin/bash

set -euo pipefail

# -------------------------------
# CONFIGURATION
# -------------------------------
IMAGE_NAME="holuphilix/jenkins-cicd-app:latest"
CONTAINER_NAME="jenkins-cicd-app"
PORT=3000

# -------------------------------
# LOGGING FUNCTION
# -------------------------------
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# -------------------------------
# DEPLOYMENT STARTS
# -------------------------------
log "🚀 Starting deployment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    log "❌ Docker not found. Please install Docker."
    exit 1
fi

# Login to DockerHub if environment variables are set
if [[ -n "${DOCKER_USERNAME:-}" && -n "${DOCKER_PASSWORD:-}" ]]; then
  log "🔐 Logging into DockerHub..."
  echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
fi

# Check if container exists
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}$"; then
    log "🛑 Stopping and removing existing container: $CONTAINER_NAME"
    docker stop "$CONTAINER_NAME" && docker rm "$CONTAINER_NAME"
else
    log "ℹ️ No existing container to stop."
fi

# Pull latest image
log "📥 Pulling latest image: $IMAGE_NAME"
docker pull "$IMAGE_NAME"

# Run the new container
log "🟢 Running new container: $CONTAINER_NAME"
docker run -d \
  --name "$CONTAINER_NAME" \
  -p "$PORT:$PORT" \
  "$IMAGE_NAME"

# Wait briefly and check if container started
sleep 3

if docker ps --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}$"; then
    log "✅ Deployment successful. Container '$CONTAINER_NAME' is running on port $PORT."
else
    log "❌ Deployment failed. Displaying logs:"
    docker logs "$CONTAINER_NAME" || log "⚠️ Unable to retrieve logs."
    exit 1
fi
