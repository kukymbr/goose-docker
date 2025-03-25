#!/usr/bin/env sh

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <expected>"
    exit 1
fi

expected="$1"

resp=$(psql -At "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOSTNAME:5432/$POSTGRES_DB?sslmode=disable" -c "SELECT string_agg(message, ' ') FROM goose_docker_test")

if [ "$resp" = "$expected" ]; then
  echo "✅ OK"
  exit 0
else
  echo "❌ FAIL: expected '$expected', got '$resp'"
  exit 1
fi;