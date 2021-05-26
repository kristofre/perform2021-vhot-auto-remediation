#!/bin/sh

# Update config file to auto start Standard scenario
sed -i "s|^config.autostart=.*|config.autostart=Standard|g" ~/easyTravel/easytravel-2.0.0-x64/resources/easyTravelConfig.properties

# Start easyTravel as background process
nohup sh ~/easyTravel/easytravel-2.0.0-x64/weblauncher/weblauncher.sh >/dev/null 2>&1 &

# Wait for app console to start 
timeout 180 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:8094)" != "302" ]]; do echo "waiting for the easyTravel console to finish deploying..." &&  sleep 5; done'
sleep 5

# Refresh easyTravel management console
node ~/node/easytravel.js
pkill -f 'chrome'

# Wait for app portal to start 
timeout 180 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:8080)" != "200" ]]; do echo "waiting for the easyTravel app to finish deploying..." &&  sleep 5; done'

# Print easyTravel access details
echo ""
echo "Easy Travel Management console URL: http://${PUBLICIP}:8094"
echo "Easy Travel main portal URL: http://${PUBLICIP}:8080"
echo ""