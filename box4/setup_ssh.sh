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

# Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker vagrant

# Falco driver on host VM using Docker
docker pull falcosecurity/falco-driver-loader:latest
docker run --rm -i -t \
   --privileged \
   -v /root/.falco:/root/.falco \
   -v /proc:/host/proc:ro \
   -v /boot:/host/boot:ro \
   -v /lib/modules:/host/lib/modules:ro \
   -v /usr:/host/usr:ro \
   -v /etc:/host/etc:ro \
   falcosecurity/falco-driver-loader:latest

# Minikube 1.8.2
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.8.2/minikube-linux-amd64 \
  && chmod +x minikube
sudo cp minikube /usr/local/bin && rm minikube


# Start minikube with no vm driver
sudo minikube start --vm-driver=none --apiserver-ips 127.0.0.1 \
  --apiserver-name localhost \
  --extra-config=apiserver.audit-dynamic-configuration=true \
  --feature-gates=DynamicAuditing=true \
  --extra-config=apiserver.runtime-config=auditregistration.k8s.io/v1alpha1
sudo minikube start --driver=none
sudo chown -R $USER $HOME/.kube $HOME/.minikube /root
sudo cp -R /root/.kube /root/.minikube $HOME

# Kind
# curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.8.1/kind-$(uname)-amd64
# chmod +x ./kind
# mv ./kind /usr/local/bin

