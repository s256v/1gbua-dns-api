#!/bin/bash

# get-token.sh
# Usage: ./get-token.sh [cabinet_login] [one_time_password]

set -e

# Configuration
BASE_URL="https://www.1gb.ua"

if [ $# -ne 2 ]; then
	echo "Usage: $0 <cabinet_login> <one_time_password>" >&2
	exit 1
fi

LOGIN="$1"
ONE_TIME_PASSWORD="$2"

echo "[1/3] Fetching salt for login: $LOGIN..."
SALT_RAW=$(curl -s "$BASE_URL/api/auth/start?login=$LOGIN")

# Extract salt from JSON array: ["..."] -> ...
SALT=$(echo "$SALT_RAW" | jq -r '.[0]')

if [ -z "$SALT" ] || [ "$SALT" = "null" ]; then
	echo "Error: Failed to retrieve salt (invalid or missing JSON)" >&2
	exit 1
fi
echo "	Salt received: $SALT"

echo "[2/3] Computing response hash..."
RESPONSE=$(printf '%s%s\n' "$ONE_TIME_PASSWORD" "$SALT" | md5sum | cut -d' ' -f1)
echo "	Response hash: $RESPONSE"

echo "[3/3] Requesting token..."
TOKEN_RAW=$(curl -s "$BASE_URL/api/auth/login?login=$LOGIN&salt=$SALT&response=$RESPONSE")

# Extract token from JSON array: ["..."] -> ...
TOKEN=$(echo "$TOKEN_RAW" | jq -r '.[0]')

if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
	echo "Error: Failed to retrieve token (invalid or missing JSON)" >&2
	exit 1
fi

echo "Token obtained successfully:"
echo "$TOKEN"