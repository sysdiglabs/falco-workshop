#!/usr/bin/env bash

sudo apt-get update

# Falco install prerequisites
sudo apt-get install -y curl gnupg2

# Falco deb source
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | sudo apt-key add -
echo "deb https://dl.bintray.com/falcosecurity/deb stable main" | sudo tee -a /etc/apt/sources.list.d/falcosecurity.list
sudo apt-get update -y

# Kernel headers
sudo apt-get -y install linux-headers-$(uname -r)

# Install Falco
sudo apt-get install -y falco


# apt-get install -y apache2
# if ! [ -L /var/www ]; then
#   rm -rf /var/www
#   ln -fs /vagrant /var/www
# fi

