# Falco Workshop help files

## Introduction

**Falco** is a runtime security tool that allows you to monitor kernel system calls and kubernetes audit log commands to detect risky and malicious behaviour. It comes with a big set of detection rules created and curated by the Falco's developers that cover a lot of cases to help you strength your infrastructure security posture.

This repository contain Vagrant boxes to test Falco installation, as well as boxes with Falco preinstalled to jump in writting new rules.

You can look for more information about all things Falco at their [website](https://falco.org/), [GitHub's repo](https://github.com/falcosecurity/falco), and follow on Twitter [@falco_org](https://twitter.com/falco_org)

## Software you need

* Any operating system: Linux, Windows, MacOs
* [VirtualBox](https://www.virtualbox.org) (required by Vagrant)
* [Vagrant](https://www.vagrantup.com/)
* Any code editor

### Using a Vagrant box

Falco runs only on a Linux kernel, so we will all use a Vagrant virtual machine for an standard way for anyone to follow the workshop following the same set of instructions. 

To use one of the boxes (virtual machines), use:
```bash
# go to the folder of the box
cd box1
# start virtual machine
vagrant up
# log into virtual machine
vagrant ssh
# to run a command with sudo, the password for the user 'vagrant' is 'vagrant'

# to use 'su', set a password for root (not set by default)
sudo passwd root

# or use it with sudo
sudo su

# exit Vagrant box
exit

# Halt Vagrant box
vagrant halt

# Completely destroy Vagrant box content
vagrant destroy -f
```
### Shared directories in the Vagrant boxes

Using box2 onwards, each box syncs the main folder where you cloned the repo with `/workshop` in the Virtual Machine using NFS. To be able to do so, it might require administrative priviledges on your computer, and it will prompt for your password. Remember it's not asking for Vagrant password, but for the password of your current user in your machine to start the sync process.

### Connect Visual Studio Code to the Vagrant box

If you want to connect your Visual Studio Code to the Vagrant box, follow these instructions:
https://medium.com/@lopezgand/connect-visual-studio-code-with-vagrant-in-your-local-machine-24903fb4a9de

### Boxes

**box1**: A clean Debian 10 installation

**box2**: 
 * Debian 10
 * NFS shared folder /workshop
 * Falco installed

**box3**: 
* Debian 10 
* NFS shared folder /workshop
* Docker
* Script to install Falco using Docker at: /workshop/box3/install_falco_using_docker.sh

**box4**
 * 8 Gb memory for VM
 * Debian 10
 * NFS shared folder /workshop
 * Docker
 * Kubectl
 * Helm
 * Minikube
 * Minikube cluster started using native host
 * Falco kernel module loaded in the vm host using Docker
 * Script to install Falco in Minikube with Kubernetes audit log enabled at: /workshop/box4/install_helm_falco.sh

## Install Falco

```bash
sudo apt-get update
sudo apt-get -y install gpg curl
curl -o install-falco.sh -s \
  https://s3.amazonaws.com/download.draios.com/stable/install-falco

sudo bash install-falco.sh
```

## Test Falco is working

Edit `falco.yaml` configuration file:

```bash
sudo nano /etc/falco/falco.yaml
```

Change:

```yaml
file_output:
  enabled: false
  keep_alive: false
  filename: ./events.txt
```

To:

```yaml
file_output:
  enabled: true
  keep_alive: false
  filename: /var/log/falco.log
```

Restart Falco to get new configuration:

```bash
sudo /etc/init.d/falco restart
```

Write a test file to `/etc` folder so it triggers a security event:

```bash
sudo touch /etc/test
```

Read Falco logs to see all security events:

```bash
cat /var/log/falco.log
```
## History

* Virtual session for HackMadrid at July 4th 2020 by [Vicente Herrera](https://twitter.com/vicen_herrera).
  * Watch it at [HackMadrid's YouTube channel (in Spanish)](https://www.youtube.com/channel/UCSfK57ch6tQHzUuc1_-YbcA).
  * [Slides (in English)](https://bit.ly/falcoworkshop), with a lot of information about Falco.
* Falco course for Quantika14 security course videos (Spanish), launched November 25th 2020, by [Vicente Herrera](https://twitter.com/vicen_herrera).
* Demo for the "OnTheNubs" Twitch channel (Spanish) https://twitter.com/OnTheNubs [@onthenubs](https://twitter.com/OnTheNubs).
