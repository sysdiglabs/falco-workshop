#!/usr/bin/env bash

apt-get update

apt-get install -y curl gnupg2 apt-transport-https

# Kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubectl

# Kubens
curl -Lo kubens https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens
chmod +x kubens
sudo mv kubens /usr/local/bin

# Minikube 1.8.2
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.8.2/minikube-linux-amd64 \
  && chmod +x minikube
sudo cp minikube /usr/local/bin && rm minikube

# Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh


# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
#sudo groupadd docker
sudo usermod -aG docker vagrant
sudo pkill -9 -u vagrant
#This kills current session, so no further commands are executed in this script