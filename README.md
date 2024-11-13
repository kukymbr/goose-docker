<img align="right" width="125" src="assets/goose-in-box.png" alt="image with a gopher in a goose costume in a box">

# [goose-docker](https://github.com/kukymbr/goose-docker)

[![License](https://img.shields.io/github/license/kukymbr/goose-docker.svg)](https://github.com/kukymbr/goose-docker/blob/master/LICENSE)
[![Release](https://img.shields.io/github/release/kukymbr/goose-docker.svg)](https://github.com/kukymbr/goose-docker/releases/latest)
[![ghrc.io status](https://img.shields.io/github/actions/workflow/status/kukymbr/goose-docker/push_ghcr.yml?label=ghcr.io)](https://github.com/kukymbr/goose-docker/actions/workflows/push_ghcr.yml)
[![hub.docker.com status](https://img.shields.io/github/actions/workflow/status/kukymbr/goose-docker/push_dockerhub.yml?label=hub.docker.com)](https://github.com/kukymbr/goose-docker/actions/workflows/push_dockerhub.yml)

Docker configuration for the [pressly/goose](https://github.com/pressly/goose) migration tool.

Based on ideas of the `gomicro/docker-goose` repository.
Features:
* No need to create your own Dockerfile;
* goose env vars are used;
* docker compose usage;
* all goose commands are available, not only `up`;
* an image with a gopher in a goose costume in a box is even worse than an image with a gopher in a goose costume.

## Usage

### Image Environment Variables

The following environment variables are required for the image to work correctly:

- `GOOSE_DRIVER`: this should specify the database driver (e.g., `postgres`).
- `GOOSE_DBSTRING`: specify the database connection parameters in this variable 
  (e.g., `host=localhost port=5432 user=postgres password=postgres dbname=postgres`).

The following environment variables are available, but not required:

- `GOOSE_COMMAND`: the goose command to execute, `up` by default.
- `GOOSE_COMMAND_ARG`: argument for the goose command,
  for example, the `VERSION` argument for the `up-to`/`down-to` commands.
- `GOOSE_VERBOSE`: if set to `true`, goose will be executed with the `-v` flag.

See the [goose usage](https://github.com/pressly/goose#usage) 
for available drivers, format of the connection string and available commands.

### Migration Files Directory

The image expects the `/migrations` directory to be mounted to the container, 
and it should contain your migration files.

### Example Usage

For example, pure docker call:

```shell
docker run --rm -v ./migrations:/migrations --network host \
  -e GOOSE_DRIVER="postgres" \
  -e GOOSE_DBSTRING="host=localhost port=5432 user=postgres password=postgres dbname=postgres" \
  ghcr.io/kukymbr/goose-docker:3.22.1
```

Example with `up-to` command:

```shell
docker run --rm -v ./migrations:/migrations --network host \
  -e GOOSE_COMMAND="up-to" \
  -e GOOSE_COMMAND_ARG="20230607203836" \
  -e GOOSE_DRIVER="postgres" \
  -e GOOSE_DBSTRING="host=localhost port=5432 user=postgres password=postgres dbname=postgres" \
  ghcr.io/kukymbr/goose-docker:3.22.1
```

Example with `create` command (works since v3.20.0):

```shell
docker run --rm -v ./migrations:/migrations \
  -e GOOSE_COMMAND="create" \
  -e GOOSE_COMMAND_ARG="my_new_migration_name sql" \
  ghcr.io/kukymbr/goose-docker:latest
```

### docker compose

Docker compose example:

```yaml
services:
  # ... Add your DB service
  
  migrations:
    image: ghcr.io/kukymbr/goose-docker:3.22.1
    environment:
      - GOOSE_DRIVER=postgres
      - GOOSE_DBSTRING=host=postgres port=5432 user=postgres password=postgres dbname=postgres
    volumes:
      - ./migrations:/migrations
```

See the [compose.yml](compose.yml) file for the full example.

#### Overriding the environment variables

If you need to dynamically override the environment values provided in the docker compose or in the .env files,
add these variables into the `environment` section with a placeholder as a value, for example:

```yaml
migrations:
  # ...
  environment:
    - GOOSE_COMMAND=${GOOSE_COMMAND}
    - GOOSE_COMMAND_ARG=${GOOSE_COMMAND_ARG}
```

When you can override the values:

```shell
GOOSE_COMMAND="create" GOOSE_COMMAND_ARG="test_migration sql" docker compose run --rm migrations
```

### AMD64/ARM64 architecture

To use an image for the specific architecture (arm64/amd64), use the `-arm64` and `-amd64` tag suffixes, for example:

```text
ghcr.io/kukymbr/goose-docker:latest-arm64
```

This feature is available only for the `latest` tag until the next goose release.

### The `latest` tag notice

The `latest` tag of this image points to the latest commit to the `main` branch 
and not supposed to be used in the production. Always specify a semver tag for production use.

## License

[MIT licensed](LICENSE).
