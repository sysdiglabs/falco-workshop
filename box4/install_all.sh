#!/usr/bin/env bash

# Base packages installation
sudo apt-get update --allow-releaseinfo-change
sudo apt-get install -y curl gnupg2 apt-transport-https git vim

# Kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
# sudo apt-get update -y
# sudo apt-get install -y kubectl

echo "source <(kubectl completion bash)" >>/home/vagrant/.bashrc
echo "alias k=kubectl" >>/home/vagrant/.bashrc
echo 'complete -F __start_kubectl k' >>/home/vagrant/.bashrc

# Kubens
curl -sLo kubens https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens
chmod +x kubens
sudo mv kubens /usr/local/bin

# Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm ./get_helm.sh

# Docker
sudo apt-get install -y lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker vagrant


# Kubernetes 1.20.2 requirements
sudo apt-get install -y conntrack
## /usr/sbin/iptables needs to be in path for minikube driver=none
export PATH=$PATH:/usr/sbin/

# Minikube 1.23.2

curl -sLo minikube https://storage.googleapis.com/minikube/releases/v1.23.2/minikube-linux-amd64 \
  && chmod +x minikube
sudo cp minikube /usr/local/bin && rm minikube

# Start minikube with no vm driver, dynamic audit enabled
minikube start --driver=none \
  --apiserver-ips 127.0.0.1 \
  --apiserver-name localhost
  # --feature-gates=DynamicAuditing=true \
  # --extra-config=apiserver.audit-dynamic-configuration=true \
  # --extra-config=apiserver.runtime-config=auditregistration.k8s.io/v1alpha1

# Assign kubeconfig 
sudo cp -R /root/.kube /root/.minikube /home/vagrant/
sudo chown -R vagrant /root/.kube /root/.minikube /root /home/vagrant/.kube


# Kernel headers

## This is faster, doesn't detect all kinds of headers
# sudo apt-get -y install linux-headers-$(uname -r)
## This is slower, but works always on amd64
sudo apt-get install -y linux-image-amd64 linux-headers-amd64