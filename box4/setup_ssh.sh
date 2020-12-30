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
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh
sudo usermod -aG docker vagrant


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
