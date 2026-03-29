#!/usr/bin/env sh

dns_1gbua_info='1GB.UA
Site: 1gb.ua
Docs: README.md
Options:
 GB1UA_TOKEN API Token. Get API Token from https://www.1gb.ua/services_api.php
Issues:
Author: Serhii Vakhnin <sva870@gmail.com>
'

GB1UA_API="https://www.1gb.ua/api"

########  Public functions #####################

#Usage: dns_1gbua_add   _acme-challenge.www.domain.com   "XKrxpRBosdIKFzxW_CT3KLZNf6q0HG9i01zxXp5CPBs"
dns_1gbua_add() {
  fulldomain=$1
  txtvalue=$2
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"

  if ! _init_check; then
    return 1
  fi

  if ! _get_record_info "$fulldomain"; then
    return 1
  fi

  dnsValue=$(echo "$txtvalue" | tr -d "\n\r" | _url_encode)
  _info "Trying to create TXT record '$dnsValue'"
  response="$(_get "$GB1UA_API/dns/raw?_token_=$GB1UA_TOKEN&s_add=1&dns_type=TXT&dns_name=_acme-challenge&dns_value=$dnsValue&_key_=$recordId")"
  if ! _contains "$response" "\"OK\""; then
    _err "Record NOT added. Response: '$response'"
    return 1
  fi
  _info "TXT record created '$dnsValue'"

  return 0
}

#Usage: fulldomain txtvalue
#Remove the txt record after validation.
dns_1gbua_rm() {
  fulldomain=$1
  txtvalue=$2
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"

  if ! _init_check; then
    return 1
  fi

  if ! _get_record_info "$fulldomain"; then
    return 1
  fi

  dnsValue=$(echo "$txtvalue" | tr -d "\n\r" | _url_encode)
  _info "Trying to remove TXT record '$dnsValue'"
  response="$(_get "$GB1UA_API/dns/raw?_token_=$GB1UA_TOKEN&s_del=1&dns_type=TXT&dns_name=_acme-challenge&dns_value=$dnsValue&_key_=$recordId")"
  if ! _contains "$response" "\"OK\""; then
    _err "Record NOT removed. Response: '$response'"
    return 1
  fi
  _info "TXT record has been removed '$dnsValue'"
}

####################  Private functions below ##################################

_get_record_info() {
  local fulldomain="$1"

  _info "Trying to find record id for domain '$fulldomain'..."
  baseDomain=$(_get_domain "$fulldomain")
  if [ -z "$baseDomain" ]; then
    _err "Domain record not found"
    return 1
  fi
  _info "Domain record found"

  _info "Trying to get domain list..."
  response="$(_get "$GB1UA_API/dns/list?_token_=$GB1UA_TOKEN")"
  if [ -z "$response" ]; then
    _err "Can't get domain list"
    return 1
  fi
  _info "Domain list loaded"

  _info "Trying to get record id..."
  recordId=$(_find_id_by_domain "$response" "$baseDomain")
  if [ -z "$recordId" ]; then
    _err "Record id not found"
    return 1
  fi
  _info "Record id found '$recordId'"

  return 0
}

_init_check() {
  GB1UA_TOKEN="${GB1UA_TOKEN:-$(_readaccountconf_mutable GB1UA_TOKEN)}"

  if [[ -z "${GB1UA_TOKEN:-}" ]]; then
    _err "GB1UA_TOKEN is not set or empty"
    return 1
  fi

  _saveaccountconf_mutable GB1UA_TOKEN "$GB1UA_TOKEN"

  return 0
}

# Usage: get_domain "_acme-challenge.example.com"
# Returns: ".example.com" on success, exits 1 on invalid input
_get_domain() {
  local input="$1"

  # Must start with "_acme-challenge."
  if [[ "$input" != _acme-challenge.* ]]; then
    echo "Error: Input must start with '_acme-challenge.' (got: '$input')" >&2
    return 1
  fi

  # Extract domain part after "_acme-challenge."
  local domain="${input#_acme-challenge.}"

  # Require at least one non-empty label after the dot (i.e., domain must not be empty)
  if [[ -z "$domain" ]]; then
    echo "Error: '_acme-challenge.' must be followed by a domain (got: '$input')" >&2
    return 1
  fi

  # Ensure leading dot (e.g., "example.com" → ".example.com")
  [[ "$domain" != .* ]] && domain=".$domain"

  echo "$domain"
}

# Finds domain ID from JSON by exact full_domain_name match.
# Usage: _find_id_by_domain "json" "domain" → prints id or nothing.
# Requires jq. Exit 1 on error, 0 otherwise (even if no match).
_find_id_by_domain() {
  local json="$1"
  local domain="$2"

  if [[ -z "$domain" ]]; then
    _err "Error: Domain name required." >&2
    return 1
  fi

  # Ensure jq is installed
  command -v jq >/dev/null 2>&1 || {
    _err "Error: jq is required but not installed." >&2
    return 1
  }

  # Extract matching id (raw output, no quotes)
  echo "$json" | jq -r --arg domain "$domain" '
    .[] | select(.full_domain_name == $domain) | .id // empty
  ' 2>/dev/null
}