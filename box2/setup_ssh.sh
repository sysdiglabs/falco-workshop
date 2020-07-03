#!/usr/bin/env bash

apt-get update

# Falco install prerequisites
apt-get install -y curl gnupg2

# Falco deb source
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://dl.bintray.com/falcosecurity/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y

# Kernel headers
apt-get -y install linux-headers-$(uname -r)

# Install Falco
apt-get install -y falco


# apt-get install -y apache2
# if ! [ -L /var/www ]; then
#   rm -rf /var/www
#   ln -fs /vagrant /var/www
# fi

