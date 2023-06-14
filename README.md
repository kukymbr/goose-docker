# goose-docker 🪿

[![License](https://img.shields.io/github/license/kukymbr/goose-docker.svg)](https://github.com/kukymbr/goose-docker/blob/master/LICENSE)
[![Release](https://img.shields.io/github/release/kukymbr/goose-docker.svg)](https://github.com/kukymbr/goose-docker/releases/latest)

Docker configuration for the [goose](https://github.com/pressly/goose) migration tool.

Based on ideas of the [gomicro/docker-goose](https://github.com/gomicro/docker-goose) repository.
Features:
* No need to create your own Dockerfile;
* docker compose usage;
* 🪿 goose emoji in readme.

## Usage

Image expects 2 environment variables to be set: 
* `DB_DRIVER` is a database driver (e.g. `postgres`)
* `DB_CONNECTION` is a database connection params.

Also, it expects the `/migration` directory mounted to the image with a migration files.

For example, pure docker call:

```shell
docker run ghcr.io/kukymbr/goose-docker:3.11.2 --rm -i -v ./migrations:/migrations \
  -e DB_DRIVER="postgres" \
  -e DB_CONNECTION="host=postgres port=5432 user=postgres password=postgres dbname=postgres"
```

### docker compose

Docker compose example:

```yaml
services:
  # ... Add your DB service
  
  migrations:
    image: ghcr.io/kukymbr/goose-docker:3.11.2
    environment:
      - DB_DRIVER=postgres
      - DB_CONNECTION=host=postgres port=5432 user=postgres password=postgres dbname=postgres
    volumes:
      - ./migrations:/migrations
```

See the [docker-compose.yml](compose.yml) file for the full example.