#!/bin/bash

DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
shopt -s nocasematch
os=$(uname)
arch=$(uname -m)
KUBDIR=/Users/martim.moura/tfminikube/infrastructure/.kube


case $os in
  "Darwin" | "mac"| "macOS")
    OS="darwin"
    ;;
  "linux" | "ubuntu" | "fedora" | "debian" | "alpine-linux")
    OS="linux"
    ;;
    *)
    echo "couldnt determine your os, assuming linux"
    OS=linux
    ;;
esac

case $arch in 
  "amd64" | "x86" | "x86-64" | "x64")
    ARCH=amd64
    ;;
  "arm" | "arm64" )
    ARCH="arm64"
  ;;
  *)
    echo "couldnt determine architecture, using uname -m as your architecture name."
  ;;
esac


curl -L https://github.com/kubernetes/minikube/releases/download/v1.37.0/minikube-$OS-$ARCH.tar.gz -O && 
tar -xf minikube-$OS-$ARCH.tar.gz -C $DIR --strip-components=1 && 
mv $DIR/minikube-$OS-$ARCH $KUBDIR/minikube