# HackMadrid Falco Workshop

This workshop was taught in a virtual session for HackMadrid at July 4th 2020 by [Vicente Herrera (follow on twitter as @vicen_herrera)](https://twitter.com/vicen_herrera).

## Introduction

**Falco** is a runtime security tool that allows you to monitor kernel system calls and kubernetes audit log commands to detect risky and malicious behaviour. It comes with a big set of detection rules created and curated by the Falco's developers that cover a lot of cases to help you strength your infrastructure security posture.

In this workshop, we learn how to install and configure Falco, how their rules and settings works, and how to write additional rules.


Watch it at [HackMadrid's YouTube channel (in Spanish)](https://www.youtube.com/channel/UCSfK57ch6tQHzUuc1_-YbcA).

[These slides that we used (in English)](bit.ly/falcoworkshop) have a lot of information about Falco.

You can look for more information about all things Falco at their [website](https://falco.org/), [GitHub's repo](https://github.com/falcosecurity/falco), and follow on Twitter [@falco_org](https://twitter.com/falco_org)

## About the workshop
### Workshop software you need

* Any operating system: Linux, Windows, MacOs
* [VirtualBox](https://www.virtualbox.org) (required by Vagrant)
* [Vagrant](https://www.vagrantup.com/)
* Any code editor

The presenter will use [Visual Studio Code](https://code.visualstudio.com/), with these extensions:
* Remote editor, to edit files inside the Vagrant box
* Live code share, to share the session with anybody

### Sharing code editor session in real time

By visiting the session URL, you will see the same resources the presenter is editing in real time, being also able to copy and paste into your computer. Access will be readonly.

You can choose to open it inside a local Visual Studio Code installation, or just using your browser without installing anything. A Microsoft or GitHub account might be required.

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

# exit Vagrant box
exit

# Halt Vagrant box
vagrant halt

# Completely destroy Vagrant box content
vagrant destroy -f
```
### Shared directories in the Vagrant boxes

Using box2 onwards, each box syncs this folder in `/workshop` using NFS. To be able to do so, it might require administrative priviledges on your computer, and it will prompt for your password. Remember it's not asking for Vagrant password, but for the password of your current user in your machine to start the sync process.

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

Edit falco.yaml

sudo nano /etc/falco/falco.yaml

Change

```
file_output:
  enabled: false
  keep_alive: false
  filename: ./events.txt
```

```
file_output:
  enabled: true
  keep_alive: false
  filename: /var/log/falco.log
```

Restart Falco to get new configuration:

```
sudo /etc/init.d/falco restart
```

Write a test file to etc

```
sudo touch /etc/test
```

Read Falco logs
```
cat /var/log/falco.log
```
