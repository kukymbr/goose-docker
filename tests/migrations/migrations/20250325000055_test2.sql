-- +goose Up
-- +goose StatementBegin
INSERT INTO goose_docker_test (id, message)
VALUES (2, 'He was with God in the beginning.');
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DELETE
FROM goose_docker_test
WHERE id = 2;
-- +goose StatementEnd
