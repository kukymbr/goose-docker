#!/usr/bin/env sh

goose ${GOOSE_VERBOSE:+"-v"} -dir=/migrations up