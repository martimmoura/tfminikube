#!/bin/bash

## Deployment Pipeline
# This script is emulating a simple declarative pipeline definition using bash


## Pipeline (script) setup

# panic on err
set -e
# Get the directory of the script, infra
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
INFRA_DIR="$SCRIPT_DIR/infrastructure"

INFRA_SETUP_DIR="$SCRIPT_DIR/infrastructure/setup"
APP_DIR="$SCRIPT_DIR/app"

# Run the Moto setup script
echo "Setting up Moto..."
"$INFRA_SETUP_DIR/moto/run_moto.sh"

# Run the Minikube setup script
export MINIKUBE_HOME="$INFRA_DIR/.kube/.minikube"
export KUBECONFIG="$INFRA_DIR/.kube/kubeconfig"



# Build and push Docker image
echo "Building Docker image..."
docker build -t app-image:latest $APP_DIR

# Provision aws (fake) resources
echo "Running terraform init"

terraform init inf
docker pull hashicorp/terraform:1.13

echo "Deployment setup finished successfully!"

