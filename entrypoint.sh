#!/usr/bin/env sh

dir="/migrations"
command="${GOOSE_COMMAND:-up}"

envFile="/goose-docker/.env"
envArgValue="none"
if [ -e "$envFile" ]; then
  envArgValue="$envFile"
fi;

goose_args=""

for i in "$GOOSE_EXTRA_ARGS"; do goose_args="$goose_args $i"; done

goose_args="$goose_args $command"

for i in "$GOOSE_COMMAND_ARG"; do goose_args="$goose_args $i"; done

if [ -n "$GOOSE_VERBOSE" ]; then
  echo "GOOSE_VERBOSE is on"
  echo "GOOSE_COMMAND=$command"
  echo "GOOSE_COMMAND_ARG=$GOOSE_COMMAND_ARG"
  echo "GOOSE_EXTRA_ARGS=$GOOSE_EXTRA_ARGS"
  echo "goose_args=$goose_args"
fi

# shellcheck disable=SC2046
# shellcheck disable=SC2116
goose ${GOOSE_VERBOSE:+"-v"} -dir="$dir" -env="$envArgValue" $(echo "$goose_args")