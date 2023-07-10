# [goose-docker](https://github.com/kukymbr/goose-docker) 🪿

[![License](https://img.shields.io/github/license/kukymbr/goose-docker.svg)](https://github.com/kukymbr/goose-docker/blob/master/LICENSE)
[![Release](https://img.shields.io/github/release/kukymbr/goose-docker.svg)](https://github.com/kukymbr/goose-docker/releases/latest)
[![ghrc.io status](https://img.shields.io/github/actions/workflow/status/kukymbr/goose-docker/push_ghcr.yml?label=ghcr.io)](https://github.com/kukymbr/goose-docker/actions/workflows/push_ghcr.yml)
[![hub.docker.com status](https://img.shields.io/github/actions/workflow/status/kukymbr/goose-docker/push_dockerhub.yml?label=hub.docker.com)](https://github.com/kukymbr/goose-docker/actions/workflows/push_dockerhub.yml)

Docker configuration for the [goose](https://github.com/pressly/goose) migration tool.

Based on ideas of the [gomicro/docker-goose](https://github.com/gomicro/docker-goose) repository.
Features:
* No need to create your own Dockerfile;
* goose env vars are used;
* docker compose usage;
* 🪿 goose emoji in readme.

## Usage

Image expects environment variables to be set: 
* `GOOSE_DRIVER` is a database driver (e.g. `postgres`);
* `GOOSE_DBSTRING` is a database connection params;
* `GOOSE_VERBOSE` is an optional variable, if `true`, goose will be executed with the `-v` flag. 

See the [goose usage](https://github.com/pressly/goose#usage) 
for available drivers and format of the connection string.

Also, it expects the `/migration` directory mounted to the image with a migration files.

For example, pure docker call:

```shell
docker run --rm -v ./migrations:/migrations --network host \
  -e GOOSE_DRIVER="postgres" \
  -e GOOSE_DBSTRING="host=localhost port=5432 user=postgres password=postgres dbname=postgres" \
  ghcr.io/kukymbr/goose-docker:3.13.4
```

### docker compose

Docker compose example:

```yaml
services:
  # ... Add your DB service
  
  migrations:
    image: ghcr.io/kukymbr/goose-docker:3.13.4
    environment:
      - GOOSE_DRIVER=postgres
      - GOOSE_DBSTRING=host=postgres port=5432 user=postgres password=postgres dbname=postgres
    volumes:
      - ./migrations:/migrations
```

See the [compose.yml](compose.yml) file for the full example.

### `latest` tag notice

The `latest` tag of this image points to the latest commit to the `main` branch 
and not supposed to be used in the production. Always specify a semver tag for production use.

## License

[MIT licensed](LICENSE).