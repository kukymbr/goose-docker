-- +goose Up
-- +goose StatementBegin
CREATE TABLE goose_docker_test
(
    id integer PRIMARY KEY,
    message text NOT NULL
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE goose_docker_test;
-- +goose StatementEnd
