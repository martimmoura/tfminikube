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

echo "Starting new Moto container."
# Run Moto in a Docker container in proxy mode
docker run -d -p 5000:5000 --name moto-proxy motoserver/moto
