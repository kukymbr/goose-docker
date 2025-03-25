# Contributing to the `goose-docker`

You are welcome to contribute to the `goose-docker` repository.

## The contribution flow

...is the basic one:

1. [Create a fork](https://github.com/kukymbr/goose-docker/fork) of a repository.
2. Create a new branch in your fork, for example "feature/something".
3. Commit and push changes.
4. [Create](https://github.com/kukymbr/goose-docker/compare) a pull request.

## Development

The docker engine is the only required dependency.

After making the changes, please run the `tests/run.sh` 
script to validate an image:

```shell
cd ./tests
./run.sh
```