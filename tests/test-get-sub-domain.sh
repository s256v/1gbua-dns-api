#!/usr/bin/env sh

# Load your functions
. ../dns_1gbua.sh

fail() {
  echo "FAIL: $1"
  exit 1
}

test_case() {
  input="$1"
  base="$2"
  expected="$3"

  result=$(_get_sub_domain "$input" "$base")

  if [ "$result" != "$expected" ]; then
    echo "Input:    $input"
    echo "Base:     $base"
    echo "Expected: $expected"
    echo "Got:      $result"
    fail "Test failed"
  else
    echo "PASS: $input → $result"
  fi
}

echo "Running tests..."

test_case "_acme-challenge.example.com" ".example.com" "_acme-challenge"
test_case "_acme-challenge.www.example.com" ".example.com" "_acme-challenge.www"
test_case "_acme-challenge.a.b.example.com" ".example.com" "_acme-challenge.a.b"

echo "All tests passed."