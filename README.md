<img align="right" width="125" src="assets/goose-in-box.png" alt="image with a gopher in a goose costume in a box">

# [goose-docker](https://github.com/kukymbr/goose-docker)

[![License](https://img.shields.io/github/license/kukymbr/goose-docker.svg)](https://github.com/kukymbr/goose-docker/blob/master/LICENSE)
[![Release](https://img.shields.io/github/release/kukymbr/goose-docker.svg)](https://github.com/kukymbr/goose-docker/releases/latest)
[![tests status](https://img.shields.io/github/actions/workflow/status/kukymbr/goose-docker/tests.yml?label=tests)](https://github.com/kukymbr/goose-docker/actions/workflows/tests.yml)
[![image status](https://img.shields.io/github/actions/workflow/status/kukymbr/goose-docker/build_push.yml?label=image)](https://github.com/kukymbr/goose-docker/actions/workflows/build_push.yml)

Docker configuration for the [pressly/goose](https://github.com/pressly/goose) migration tool.

Based on ideas of the `gomicro/docker-goose` repository.
Features:

* No need to create your own Dockerfile (but you still may);
* goose env vars are used;
* docker compose usage;
* all goose commands are available, not only `up`;
* an image with a gopher in a goose costume in a box is even worse than an image with a gopher in a goose costume.

## Pure goose command wrapper

Looking for a pure goose wrapper with no sugar around?

👉 Check out the [command wrapper mode](docs/command-wrapper.md) document.

<details>
  <summary><b>What's the difference?</b></summary>

The pure command wrapper uses a `goose` command as a docker's entrypoint
instead of the [entrypoint.sh](entrypoint.sh) script:

```Dockerfile
ENTRYPOINT ["/bin/goose"]
```

This allows you to get a full control what are you passing to the `goose` command, for example:

```shell
docker run --rm -v ./migrations:/migrations \
     -e GOOSE_MIGRATION_DIR="/migrations" \
     -e GOOSE_DRIVER="postgres" \
     ghcr.io/kukymbr/goose-docker-cmd:v3.26.0 \
     create my_new_feature sql
```

or:

```shell
docker run --rm -v ./migrations:/migrations \
     ghcr.io/kukymbr/goose-docker-cmd:v3.26.0 \
     -dir="/migrations" postgres "user=postgres dbname=postgres sslmode=disable" up-to 20230607203836
```

</details>

## Usage

### Image Environment Variables

The image supports the following environment variables:

| Variable            | Required | Description                                                                                                                                    | Default value |
|---------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| `GOOSE_DRIVER`      | ✅        | this should specify the database driver (e.g., `postgres`)                                                                                     | none          |
| `GOOSE_DBSTRING`    | ✅        | specify the database connection parameters in this variable (e.g., `host=localhost port=5432 user=postgres password=postgres dbname=postgres`) | none          |
| `GOOSE_COMMAND`     |          | the goose command to execute                                                                                                                   | `up`          |
| `GOOSE_COMMAND_ARG` |          | argument for the goose command, for example, the `VERSION` argument for the `up-to`/`down-to` commands                                         | none          |
| `GOOSE_EXTRA_ARGS`  |          | additional goose arguments, for example `GOOSE_EXTRA_ARGS="-table=_db_version -allow-missing"`                                                 | none          |
| `GOOSE_VERBOSE`     |          | if set to `true`, goose will be executed with the `-v` flag                                                                                    | `false`       |

See the [goose usage](https://github.com/pressly/goose#usage)
for available drivers, format of the connection string and available commands.

#### .env file for a goose

To pass environment variables to the goose via the `.env` file
(available in goose since v3.24.0,
see the [goose doc](https://github.com/pressly/goose#environment-variables) for info),
mount `.env` file to the `/goose-docker` directory, for example:

```shell
docker run --rm -v ./migrations:/migrations -v my_goose.env:/goose-docker/.env --network host \
  -e GOOSE_DRIVER="postgres" \
  -e GOOSE_DBSTRING="host=localhost port=5432 user=postgres password=postgres dbname=postgres" \
  ghcr.io/kukymbr/goose-docker:3.26.0
```

### Migration Files Directory

The image expects the `/migrations` directory to be mounted to the container,
and it should contain your migration files.

### Example Usage

For example, pure docker call:

```shell
docker run --rm -v ./migrations:/migrations --network host \
  -e GOOSE_DRIVER="postgres" \
  -e GOOSE_DBSTRING="host=localhost port=5432 user=postgres password=postgres dbname=postgres" \
  ghcr.io/kukymbr/goose-docker:3.26.0
```

Example with `up-to` command:

```shell
docker run --rm -v ./migrations:/migrations --network host \
  -e GOOSE_COMMAND="up-to" \
  -e GOOSE_COMMAND_ARG="20230607203836" \
  -e GOOSE_DRIVER="postgres" \
  -e GOOSE_DBSTRING="host=localhost port=5432 user=postgres password=postgres dbname=postgres" \
  ghcr.io/kukymbr/goose-docker:3.26.0
```

Example with `create` command (works since v3.20.0):

```shell
docker run --rm -v ./migrations:/migrations \
  -e GOOSE_COMMAND="create" \
  -e GOOSE_COMMAND_ARG="my_new_migration_name sql" \
  ghcr.io/kukymbr/goose-docker:v3.26.0
```

### docker compose

Docker compose example:

```yaml
services:
  # ... Add your DB service

  migrations:
    image: ghcr.io/kukymbr/goose-docker:3.26.0
    environment:
      - GOOSE_DRIVER=postgres
      - GOOSE_DBSTRING=host=postgres port=5432 user=postgres password=postgres dbname=postgres
    volumes:
      - ./migrations:/migrations
```

See the [compose.yml](compose.yml) file for the full example.
Also, the [tests/compose.yml](tests/compose.yml) file contains an example of usage with multiple databases.

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

### Embedding migrations files

If you don't want or can't add migration files as a volume,
create a `Dockerfile` extending the `goose-docker` image and add your files into it:

```Dockerfile
FROM ghcr.io/kukymbr/goose-docker:3.26.0

ADD /path/to/migrations /migrations
```

Then build it and use it instead of the `goose-docker` image as usual.

### amd64/arm64 architecture

The ARM64 architecture support is added since the v3.23.0.

### The `latest` tag notice

The `latest` tag of this image points to the latest commit to the `main` branch
and not supposed to be used in the production. Always specify a semver tag for production use.

## Contributing

Please refer the [CONTRIBUTING.md](CONTRIBUTING.md) for contribution info.

## License

[MIT licensed](LICENSE).
