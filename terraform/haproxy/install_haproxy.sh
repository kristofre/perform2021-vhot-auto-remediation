#!/usr/bin/env bash

# Install packages needed for lab
sudo apt update -y && sudo apt -y upgrade
sudo apt install -y ca-certificates \
apt-transport-https \
curl \
software-properties-common \
jq \
vim \
nano \
git \
wget \
haproxy

# Create user for ansible
sudo useradd -m -s /bin/bash -p $(openssl passwd -1 dynatrace) ansible
sudo usermod -aG sudo ansible

# Allow password login
sudo sed -i "s|^PasswordAuthentication no.*|PasswordAuthentication yes|g" /etc/ssh/sshd_config
sudo systemctl restart ssh

# Allow sudo without password
sudo echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers