-- +goose Up
-- +goose StatementBegin
INSERT INTO goose_docker_test (id, message)
VALUES (1, 'In the beginning was the Word, and the Word was with God, and the Word was God.');
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DELETE
FROM goose_docker_test
WHERE id = 1;
-- +goose StatementEnd
