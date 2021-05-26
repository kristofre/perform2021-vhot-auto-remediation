#!/usr/bin/env bash

set -euo pipefail

## Get the 17.0.1 release of ansible awx tarball and extract it. 
cd ~
AWX_VERSION=17.0.1
curl -L -o ansible-awx-$AWX_VERSION.tar.gz https://github.com/ansible/awx/archive/$AWX_VERSION.tar.gz && \
tar xvfz ansible-awx-$AWX_VERSION.tar.gz && \
rm -f ansible-awx-$AWX_VERSION.tar.gz && \
mv awx-$AWX_VERSION/ awx/

# Set env vars
echo 'export PUBLICIP=$(curl -k -s ifconfig.me)' >> ~/.bashrc

# Set up node project
npm --prefix ~/node/ i puppeteer

## Generate Certs for AWX https support 
AWXPUBLICIP=$(curl ifconfig.me)

# Create config file
>~/certs/$AWXPUBLICIP.conf cat <<-EOF
[req]
default_bits  = 2048
distinguished_name = req_distinguished_name
req_extensions = req_ext
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
countryName = XX
stateOrProvinceName = N/A
localityName = N/A
organizationName = Self-signed certificate
commonName = $AWXPUBLICIP: Self-signed certificate
[req_ext]
subjectAltName = @alt_names
[v3_req]
subjectAltName = @alt_names
[alt_names]
IP.1 = $AWXPUBLICIP
EOF

# Create the signed certificate
openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout ~/certs/key.pem -out ~/certs/cert.pem -config ~/certs/$AWXPUBLICIP.conf

# Create ssl_certificate required for HTTPS in AWX
cat ~/certs/cert.pem ~/certs/key.pem > ~/certs/awx-bundled-cert.pem
