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
sudo apt install -y python3-pip
sudo apt install -y python-docker
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo sudo apt install ansible -y
ansible-galaxy collection install community.general
ansible-galaxy install dynatrace.oneagent
sudo python3 -m pip install -U pip
sudo python3 -m pip install -U setuptools
sudo pip3 install docker-compose
sudo pip3 install docker

# Allow sudo without password
sudo echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

# Create Dynatrace Tokens
printf "Creating PAAS Token for Dynatrace Environment ${DT_CLUSTER_URL}/e/$DT_ENVIRONMENT_ID\n\n"

paas_token_body='{
                    "scopes": [
                        "InstallerDownload"
                    ],
                    "name": "vhot-monaco-paas"
                  }'

DT_PAAS_TOKEN_RESPONSE=$(curl -k -s --location --request POST "${DT_CLUSTER_URL}/e/$DT_ENVIRONMENT_ID/api/v2/apiTokens" \
--header "Authorization: Api-Token $DT_ENVIRONMENT_TOKEN" \
--header "Content-Type: application/json" \
--data-raw "${paas_token_body}")
DT_PAAS_TOKEN=$(echo $DT_PAAS_TOKEN_RESPONSE | jq -r '.token' )

printf "Creating API Token for Dynatrace Environment ${DT_CLUSTER_URL}/e/$DT_ENVIRONMENT_ID\n\n"

api_token_body='{
                  "scopes": [
                    "DataExport", "PluginUpload", "DcrumIntegration", "AdvancedSyntheticIntegration", "ExternalSyntheticIntegration", 
                    "LogExport", "ReadConfig", "WriteConfig", "DTAQLAccess", "UserSessionAnonymization", "DataPrivacy", "CaptureRequestData", 
                    "Davis", "DssFileManagement", "RumJavaScriptTagManagement", "TenantTokenManagement", "ActiveGateCertManagement", "RestRequestForwarding", 
                    "ReadSyntheticData", "DataImport", "auditLogs.read", "metrics.read", "metrics.write", "entities.read", "entities.write", "problems.read", 
                    "problems.write", "networkZones.read", "networkZones.write", "activeGates.read", "activeGates.write", "credentialVault.read", "credentialVault.write", 
                    "extensions.read", "extensions.write", "extensionConfigurations.read", "extensionConfigurations.write", "extensionEnvironment.read", "extensionEnvironment.write", 
                    "metrics.ingest", "securityProblems.read", "securityProblems.write", "syntheticLocations.read", "syntheticLocations.write", "settings.read", "settings.write", 
                    "tenantTokenRotation.write", "slo.read", "slo.write", "releases.read", "apiTokens.read", "apiTokens.write", "logs.read", "logs.ingest"
                  ],
                  "name": "vhot-monaco-api-token"
                }'
              
DT_API_TOKEN_RESPONSE=$(curl -k -s --location --request POST "${DT_CLUSTER_URL}/e/$DT_ENVIRONMENT_ID/api/v2/apiTokens" \
--header "Authorization: Api-Token $DT_ENVIRONMENT_TOKEN" \
--header "Content-Type: application/json" \
--data-raw "${api_token_body}")
DT_API_TOKEN=$(echo $DT_API_TOKEN_RESPONSE | jq -r '.token' )


>/home/dtu.training/extra_vars.json cat <<-EOF
{
    "dynatrace_environment_url": "${DT_CLUSTER}/e/$DT_ENVIRONMENT_ID",
    "dynatrace_paas_token": "$DT_PAAS_TOKEN",
    "dynatrace_api_token": "$DT_API_TOKEN",
    "dt_environment_url": "${DT_CLUSTER_URL}/e/$DT_ENVIRONMENT_ID",
    "dt_api_token": "$DT_API_TOKEN",
    "dt_pass_token": "$DT_PAAS_TOKEN",
    "haproxy_ip": "$HAIP",
    "github_url": "https://github.com/dynatrace-ace/perform2021-vhot-auto-remediation.git",
    "public_ip": "$VM_PUBLIC_IP"
}
EOF