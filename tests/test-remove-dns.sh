#!/usr/bin/env sh
source ../.env
source ~/.acme.sh/acme.sh >/dev/null 2>&1
source ../dns_1gbua.sh

DNS_KEY=_acme-challenge.$TEST_GB1UA_DOMAIN
DNS_VALUE=vCZW3an5j5hpfdY04oL5Yh94OueOLt7e7Cqg5OBTUsM

dns_1gbua_rm "$DNS_KEY" "$DNS_VALUE"