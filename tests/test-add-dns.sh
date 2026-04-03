#!/usr/bin/env sh
source ../.env
source ~/.acme.sh/acme.sh >/dev/null 2>&1
source ../dns_1gbua.sh

DNS_KEY=_acme-challenge.s.$TEST_GB1UA_DOMAIN
DNS_VALUE="ZgPW04Eaj7TSRVHNB51uB0mDAX1BtcMRSVAK0chQWPU"

dns_1gbua_add "$DNS_KEY" "$DNS_VALUE" || exit 1

DNS_KEY=_acme-challenge.$TEST_GB1UA_DOMAIN
dns_1gbua_add "$DNS_KEY" "$DNS_VALUE"  || exit 1