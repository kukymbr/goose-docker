# goose-docker

Docker configuration for the [goose](https://github.com/pressly/goose) migration tool.

Based on https://github.com/gomicro/docker-goose repository.

## Usage

Image expects 2 environment variables to be set: 
* `DB_DRIVER` is a database driver (e.g. `postgres`)
* `DB_CONNECTION` is a database connection params, 
  for example: `host=postgres port=5432 user=postgres password=postgres dbname=postgres`

Also, expects the `/migration` directory mounted to the image with a migration files, for example .sql.

### docker compose

See the example [docker-compose.yml](docker-compose.yml) for the usage.