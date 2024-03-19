#!/usr/bin/env sh

goose ${GOOSE_VERBOSE:+"-v"} -dir=/migrations "${GOOSE_COMMAND:-up}" "$GOOSE_COMMAND_ARG"