#!/usr/bin/env bash

sudo apt-get update

sudo apt-get install -y curl gnupg2

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
#sudo groupadd docker
sudo usermod -aG docker vagrant
sudo pkill -9 -u vagrant
#This kills current session, so no further commands are executed in this script