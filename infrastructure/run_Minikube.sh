#!/bin/bash

# This script will set up Minikube.
echo "Setting up Minikube..."
# Start Minikube if not already running
minikube status > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Minikube is not running. Starting Minikube..."
    minikube start
else
    echo "Minikube is already running."
fi

# Set kubectl context to Minikube
kubectl config use-context minikube

minikube addons enable istio-provisioner
minikube addons enable istio
