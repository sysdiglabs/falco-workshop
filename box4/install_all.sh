#!/usr/bin/env bash

sudo apt-get update

sudo apt-get install -y curl gnupg2 apt-transport-https git vim

# Kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubectl
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


# Minikube 1.8.2
curl -sLo minikube https://storage.googleapis.com/minikube/releases/v1.8.2/minikube-linux-amd64 \
  && chmod +x minikube
sudo cp minikube /usr/local/bin && rm minikube


# Start minikube with no vm driver, dynamic audit enabled
sudo minikube start --driver=none \
  --apiserver-ips 127.0.0.1 \
  --apiserver-name localhost \
  --feature-gates=DynamicAuditing=true \
  --extra-config=apiserver.audit-dynamic-configuration=true \
  --extra-config=apiserver.runtime-config=auditregistration.k8s.io/v1alpha1

# WIP to set up Audit Log with NodePort
# sudo minikube start --driver=none \
#   --apiserver-ips 127.0.0.1 \
#   --apiserver-name localhost \
#   --extra-config=audit-policy-file=/vagrant/k8s_audit_cfg/audit-policy.yaml
#   --extra-config=audit-webhook-batch-max-wait=5s
#   --extra-config=audit-webhook-config-file=/vagrant/k8s_audit_cfg/webhook-config.yaml


sudo cp -R /root/.kube /root/.minikube /home/vagrant/
sudo chown -R vagrant /root/.kube /root/.minikube /root /home/vagrant/.kube

# Install full Falco on host
# This is slower, but succeeds where Falco driver using Docker may fail

# Falco deb source
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | sudo apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | sudo tee -a /etc/apt/sources.list.d/falcosecurity.list
sudo apt-get update -y

# Kernel headers
# This is faster, doesn't detect all kinds of headers
sudo apt-get -y install linux-headers-$(uname -r)
# This is slower, but works always on amd64
apt-get install linux-image-amd64 linux-headers-amd64

# Install Falco
sudo apt-get install -y falco

exit

# Falco driver on host VM using Docker
docker pull falcosecurity/falco-driver-loader:latest
docker run --rm \
   --privileged \
   -v /root/.falco:/root/.falco \
   -v /proc:/host/proc:ro \
   -v /boot:/host/boot:ro \
   -v /lib/modules:/host/lib/modules:ro \
   -v /usr:/host/usr:ro \
   -v /etc:/host/etc:ro \
   falcosecurity/falco-driver-loader:latest
