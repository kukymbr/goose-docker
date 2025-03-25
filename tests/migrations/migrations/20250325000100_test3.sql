-- +goose Up
-- +goose StatementBegin
INSERT INTO goose_docker_test (id, message)
VALUES (3, 'Through him all things were made; without him nothing was made that has been made.');
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DELETE
FROM goose_docker_test
WHERE id = 3;
-- +goose StatementEnd
