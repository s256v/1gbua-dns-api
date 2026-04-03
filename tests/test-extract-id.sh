#!/bin/zsh
source ../.env
source ~/.acme.sh/acme.sh >/dev/null 2>&1
source ../dns_1gbua.sh

export GB1UA_TOKEN=$TEST_GB1UA_TOKEN

_get(){
  echo $(curl -s $1)
}

fulldomain="_acme-challenge.s.$TEST_GB1UA_DOMAIN"
if ! _get_record_info "$fulldomain"; then
    return 1
fi
echo "RecordId="$recordId

fulldomain="_acme-challenge.$TEST_GB1UA_DOMAIN"
if ! _get_record_info "$fulldomain"; then
    return 1
fi
echo "RecordId="$recordId