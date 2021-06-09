#!/usr/bin/env bash

sudo apt-get update

# Falco install prerequisites
sudo apt-get install -y curl gnupg2 apt-transport-https ca-certificates

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


# Uncomment to install Apache webserver and link web folder

# apt-get install -y apache2
# if ! [ -L /var/www ]; then
#   rm -rf /var/www
#   ln -fs /vagrant /var/www
# fi

