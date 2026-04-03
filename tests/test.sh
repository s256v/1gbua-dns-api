#!/usr/bin/env sh
PATH=~/.acme.sh/:$PATH
source ../.env

export GB1UA_TOKEN=$TEST_GB1UA_TOKEN
#acme.sh --remove -d '*.'"$TEST_GB1UA_DOMAIN"
#acme.sh --deactivate -d '*.'"$TEST_GB1UA_DOMAIN"
acme.sh --test --issue --force --staging --dns dns_1gbua -d "$TEST_GB1UA_DOMAIN" -d "*.$TEST_GB1UA_DOMAIN" -d "*.s.$TEST_GB1UA_DOMAIN"
