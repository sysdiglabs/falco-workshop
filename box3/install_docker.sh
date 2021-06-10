#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y curl gnupg2 apt-transport-https ca-certificates

# Install Docker
sudo apt-get install -y lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# curl -fsSL https://get.docker.com -o get-docker.sh
# sudo sh get-docker.sh

# sudo groupadd docker
sudo usermod -aG docker vagrant

# This kills current session, so no further commands are executed in this script
sudo pkill -9 -u vagrant
