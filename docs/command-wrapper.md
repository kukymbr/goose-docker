# `goose` command wrapper

To use `goose-docker` as a `goose` command wrapper without any sugar around,
get an image with a `-cmd` suffix. It contains the goose executable as an entrypoint
without any predefined arguments.

The latest one is `ghcr.io/kukymbr/goose-docker-cmd:latest`.

Versioned tag will be available after the next goose release.

## Usage

There are two ways to add your migration files into the image:

1. creating your own Dockerfile:
   ```Dockerfile
   FROM ghcr.io/kukymbr/goose-docker-cmd:latest
   
   ENV GOOSE_MIGRATION_DIR=/migrations
   ADD ./path/to/your/migrations /migrations
   ```
2. using a volume:
   ```shell
   docker run --rm ghcr.io/kukymbr/goose-docker-cmd:latest \
     -v ./path/to/your/migrations:/migrations \
     <other arguments>
   ```

After adding a migrations, run an image with a required goose arguments.

### `docker run` examples

Running the `up` command:

```shell
docker run --rm ghcr.io/kukymbr/goose-docker-cmd:latest \
     --v ./path/to/your/migrations:/migrations \
     -e GOOSE_MIGRATION_DIR="/migrations" \
     -e GOOSE_DRIVER="postgres" \
     -e GOOSE_DBSTRING="host=localhost port=5432 user=postgres password=postgres dbname=postgres  sslmode=disable" \
     up
```

Running the `up-to` command:

```shell
docker run --rm ghcr.io/kukymbr/goose-docker-cmd:latest \
     --v ./path/to/your/migrations:/migrations \
     postgres "user=postgres dbname=postgres sslmode=disable" \
     up-to 
```

Running the `create` command:

```shell
docker run --rm ghcr.io/kukymbr/goose-docker-cmd:latest \
     --v ./path/to/your/migrations:/migrations \
     -e GOOSE_MIGRATION_DIR="/migrations" \
     -e GOOSE_DRIVER="postgres" \
     create my_new_feature sql
```

### `docker compose` example

```yaml
services:
  # ... Add your DB service
  
  migrations:
    image: ghcr.io/kukymbr/goose-docker-cmd:latest
    environment:
      - GOOSE_DRIVER=postgres
      - GOOSE_DBSTRING=host=postgres port=5432 user=postgres password=postgres dbname=postgres
      - GOOSE_MIGRATION_DIR=/migrations
    volumes:
      - ./migrations:/migrations
    command: [ "up" ]
```