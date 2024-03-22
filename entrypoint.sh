#!/usr/bin/env sh

dir="/migrations"
command="${GOOSE_COMMAND:-up}"

if [ -n "$GOOSE_VERBOSE" ]; then
  echo "GOOSE_VERBOSE is on"
  echo "GOOSE_COMMAND=$command"
  echo "GOOSE_COMMAND_ARG=$GOOSE_COMMAND_ARG"
fi

# shellcheck disable=SC2046
# shellcheck disable=SC2116
goose ${GOOSE_VERBOSE:+"-v"} -dir="$dir" "${GOOSE_COMMAND:-up}" $(echo "$GOOSE_COMMAND_ARG")