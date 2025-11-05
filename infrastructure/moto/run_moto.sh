#!/bin/bash

# Check if a container named moto-proxy is already running
if [ "$(docker ps -q -f name=moto-proxy)" ]; then
    echo "Moto container is already running."
    exit 0
fi

# Check if a container named moto-proxy exists, but is stopped
if [ "$(docker ps -aq -f status=exited -f name=moto-proxy)" ]; then
    echo "Starting existing Moto container."
    docker start moto-proxy
    exit 0
fi

# Only need this bit if the container hasnt been built
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# build local proxy container
echo "Building local moto-proxy image..."
docker build -t moto-proxy "$SCRIPT_DIR/image"

# Run Moto in a Docker container in proxy mode
echo "Running moto-proxy container..."
docker run -d -p 5050:5050 --name moto-proxy moto-proxy
