#!/usr/bin/env sh

goose -dir=/migrations "$DB_DRIVER" "$DB_CONNECTION" up