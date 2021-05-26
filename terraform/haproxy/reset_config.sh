#!/usr/bin/env bash

set -euo pipefail

# Reset HAProxy config
echo "removing all backend servers"
sudo rm /etc/haproxy/10*
sudo pkill -f 'haproxy'
sudo systemctl restart haproxy
echo "done"