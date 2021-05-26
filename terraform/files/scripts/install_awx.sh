#!/usr/bin/env bash

set -euo pipefail

## Set values for inventory file

## Pass the full path of awx-bundled-cert.crt file to ssl_certificate variable in inventory.
sed -i -E "s|^#([[:space:]]?)ssl_certificate=|ssl_certificate=~/certs/awx-bundled-cert.pem|g" ~/awx/installer/inventory

## Set a password for the admin user
sed -i -E "s|^#([[:space:]]?)admin_password=password.*|admin_password=dynatrace|g" ~/awx/installer/inventory

## Deploy AWX
cd ~/awx/installer/
ansible-playbook -i inventory install.yml || true

## Wait for AWX to finish deploying
timeout 500 bash -c 'while [[ "$(curl -k -s -o /dev/null -w ''%{http_code}'' https://localhost)" != "200" ]]; do echo "waiting for ansible AWX to finish deploying..." &&  sleep 10; done'

## Rerun AWX deployment
ansible-playbook -i inventory install.yml || true

## Configure AWX
ansible-playbook ~/ansible/awx_config.yml

# Print login details
echo "AWX can be accessed using this URL https://${PUBLICIP}"
echo "username: admin"
echo "password: dynatrace"
echo ""
