#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

CREDS=./extra_vars.json

echo -e "${YLW}Please enter the credentials as requested below: ${NC}"
read -p "Dynatrace Tenant (SaaS: http(s)://[TENANT].live.dynatrace.com | Managed: http(s)://mydomain.com/e/[TENANT_GUID]) (default=$DTENV): " DTENVC
read -p "Dynatrace API Token (default=$DTAPI): " DTAPIC
read -p "Dynatrace PAAS Token (default=$DTPAAS): " DTPAASC
read -p "HAProxy IP Address (default=$HAIP): " HAIPC
echo ""

if [[ $DTENV = '' ]]
then 
    DTENV=$DTENVC
fi

if [[ $DTAPI = '' ]]
then 
    DTAPI=$DTAPIC
fi

if [[ $DTPAAS = '' ]]
then 
    DTPAAS=$DTPAASC
fi

if [[ $HAIP = '' ]]
then 
    HAIP=$HAIPC
fi

echo ""
echo -e "${YLW}Please confirm all are correct: ${NC}"
echo "Dynatrace Tenant: $DTENV"
echo "Dynatrace API Token: $DTAPI"
echo "Dynatrace PAAS Token: $DTPAAS"
echo "HAProxy IP Address: $HAIP"
read -p "Is this all correct? (y/n) : " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]
then

rm $CREDS 2> /dev/null
>./extra_vars.json cat <<-EOF
{
    "dt_environment_url": "$DTENV",
    "dt_api_token": "$DTAPI",
    "dt_pass_token": "$DTPAAS",
    "haproxy_ip": "$HAIP",
    "github_url": "https://github.com/dynatrace-ace/perform2021-vhot-auto-remediation.git"
}
EOF

fi

cat $CREDS
echo ""
echo "The extra vars file can be found here:" $CREDS
echo ""