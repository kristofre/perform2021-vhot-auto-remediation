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
openjdk-8-jre \
nodejs \
npm \
fonts-liberation \
libappindicator3-1 \
libasound2 \
libatk-bridge2.0-0 \
libatk1.0-0 \
libc6 \
libcairo2 \
libcups2 \
libdbus-1-3 \
libexpat1 \
libfontconfig1 \
libgbm1 \
libgcc1 \
libglib2.0-0 \
libgtk-3-0 \
libnspr4 \
libnss3 \
libpango-1.0-0 \
libpangocairo-1.0-0 \
libstdc++6 \
libx11-6 \
libx11-xcb1 \
libxcb1 \
libxcomposite1 \
libxcursor1 \
libxdamage1 \
libxext6 \
libxfixes3 \
libxi6 \
libxrandr2 \
libxrender1 \
libxss1 \
libxtst6 \
lsb-release \
xdg-utils

# Install docker 
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Run docker post-install commands
sudo usermod -aG docker $USER
sudo usermod -aG docker dtu.training
sudo systemctl enable docker

## Install latest docker-compose
LATEST_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')
sudo wget -O docker-compose https://github.com/docker/compose/releases/download/$LATEST_VERSION/docker-compose-$(uname -s)-$(uname -m)
sudo mv docker-compose /usr/local/bin/
sudo chmod +x /usr/local/bin/docker-compose

# Install AWX pre-requisites
sudo apt-get install -y python3-pip
sudo sudo apt install ansible -y
sudo pip3 install docker-compose

# Install ansible community modules
ansible-galaxy collection install community.general

# Allow sudo without password
sudo echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers