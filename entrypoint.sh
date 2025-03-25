#!/usr/bin/env sh

dir="/migrations"
command="${GOOSE_COMMAND:-up}"
envFile="/goose-docker/.env"
envArgValue="none"

if [ -n "$GOOSE_VERBOSE" ]; then
  echo "GOOSE_VERBOSE is on"
  echo "GOOSE_COMMAND=$command"
  echo "GOOSE_COMMAND_ARG=$GOOSE_COMMAND_ARG"
fi

if [ -e "$envFile" ]; then
  envArgValue="$envFile"
fi;

# shellcheck disable=SC2046
# shellcheck disable=SC2116
goose ${GOOSE_VERBOSE:+"-v"} -dir="$dir" -env="$envArgValue" "$command" $(echo "$GOOSE_COMMAND_ARG")