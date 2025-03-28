#!/usr/bin/env sh

fail() {
  if [ "$1" != "" ]; then
    echo "😢 $1"
    echo "Usage: bump.sh <next_semver_tag>"
  fi

  exit 1
}

get_target_dir() {
  findIn="."
  [[ $(pwd) == *"/scripts" ]] && findIn=".."
  findIn=$(cd "$(dirname "$findIn")"; pwd)/$(basename "$findIn")

  if command -v realpath 2>&1 >/dev/null
  then
      findIn=$(realpath "$findIn")
  fi

  echo "$findIn"
}

REGEXP_TAG="v[0-9]*\.[0-9]*\.[0-9]*"

echo "👋 Hi, this is the goose-docker version bumping script!"

nextTag="$1"
if [ -z "$nextTag" ]; then
  fail "Next tag is not given."
fi

[[ "$nextTag" =~ $REGEXP_TAG ]] || fail "Invalid next tag given, expected to be in v1.2.3 format."

currentTag=$(git tag --sort=committerdate | grep -o "$REGEXP_TAG" | tail -n1)
if [ -z "$currentTag" ]; then
  fail "Failed to find latest version tag."
fi

findIn=$(get_target_dir)

echo "⚙️ Target dir: $findIn"
echo "⚙️ Bumping version from $currentTag to $nextTag"
read -p "▶️ Press Enter to continue or Ctrl+C to cancel..."

replace_in_file() {
  file="$1"
  oldValue="${currentTag:1}"
  newValue="${nextTag:1}"

  echo "⚙️ Replacing $oldValue to $newValue in '$file'..."

  sed -i '' -e "s/$oldValue/$newValue/g" $file
}

files=$(find "$findIn" -name '*.env' -or -name 'Dockerfile' -or -name '*.md' -or -name '*.yml' ! -name '*tests/.env')
for f in $files; do replace_in_file "$f"; done

echo "👍 All done."