#!/usr/bin/env sh

set -e

version_tag=""
target_arch=""
target_path=""

echo "Hi, this is a goose binary installer script."

print_usage() {
  echo "
Usage: install.sh [--target=<target_path>] [--arch=<target_arch>] <TAG>

  TAG: goose binary version tag
  --target: path to the target binary path, default is '/bin/goose'
  --arch: architecture, default is current or 'amd64'
"
}

fail() {
  if [ "$1" != "" ]; then
    echo "ERROR: $1"
    print_usage
  fi

  exit 1
}

parse_args() {
  for i in "$@"; do
    case $i in
      -h|--help)
        print_usage
        exit 0
        ;;
      --target=*)
        target_path="${i#*=}"
        shift
        ;;
      --arch=*)
        target_arch="${i#*=}"
        shift
        ;;
      *)
        if [ -n "$version_tag" ]; then
          fail "Unexpected positional argument '$1'"
        fi
        version_tag="$1"
        shift
        ;;
    esac
  done
}

parse_args "$@"

if [ -z "$version_tag" ]; then
  fail "No version tag given"
fi

if [ -z "$target_path" ]; then
  target_path="/bin/goose"
fi

if [ -z "$target_arch" ]; then
  target_arch=$(uname -m || echo "amd64")
fi

case "$target_arch" in
  "amd64"|"x86_64"|"") GOOSE_ARCH="x86_64";;
  "arm64") GOOSE_ARCH="arm64";;
  *) echo "WARNING: Unsupported architecture: $target_arch; switching to amd64."; GOOSE_ARCH="x86_64";;
esac

echo "Requesting the goose binary...

Version: $version_tag
Arch: $GOOSE_ARCH
Target: $target_path
"

wget -O "$target_path" "https://github.com/pressly/goose/releases/download/$version_tag/goose_linux_$GOOSE_ARCH"
chmod +x "$target_path"

echo "Successfully installed to $target_path"