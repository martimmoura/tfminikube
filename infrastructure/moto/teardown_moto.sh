#!/bin/bash

CONTAINER_NAME="moto-proxy"

# Check if the container is running and stop it
if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "Stopping container: ${CONTAINER_NAME}"
    docker stop "${CONTAINER_NAME}"
fi

# Check if the container exists (even if stopped) and remove it
if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "Removing container: ${CONTAINER_NAME}"
    docker rm "${CONTAINER_NAME}"
fi

echo "Teardown complete. The moto-proxy container has been stopped and removed."
