# goose-docker

Docker configuration for the [goose](https://github.com/pressly/goose) migration tool.
Based on ideas of the [gomicro/docker-goose](https://github.com/gomicro/docker-goose) repository.

## Usage

Image expects 2 environment variables to be set: 
* `DB_DRIVER` is a database driver (e.g. `postgres`)
* `DB_CONNECTION` is a database connection params.

Also, expects the `/migration` directory mounted to the image with a migration files, for example .sql.

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