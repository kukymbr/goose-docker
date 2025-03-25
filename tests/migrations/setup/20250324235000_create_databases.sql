-- +goose NO TRANSACTION

-- +goose Up
-- +goose StatementBegin
CREATE DATABASE tests;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP DATABASE tests;
-- +goose StatementEnd