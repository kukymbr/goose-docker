#!/usr/bin/env sh

echo "👋 Hi, this is the goose-docker tests script!"

setupFilename="compose.yml"
testsFilename="compose.yml"

setupContainers="goose_docker_test_postgres migrations_setup"
testsContainers="migrations_up_to assert_up_to cleanup_up_to migrations_up assert_up"

go_down() {
  echo "⚙️ Bringing down containers..."

  docker compose --file "$setupFilename" down
  docker compose --file "$testsFilename" down
}

fail() {
  if [ "$1" != "" ]; then
    echo "😢 $1"
  fi

  go_down
  exit 1
}

# To avoid usage of data possible kept from previous runs.
go_down

echo "⚙️ Running the setup containers..."
docker compose --file "$setupFilename" up -d --remove-orphans $setupContainers || fail "Failed to run setup containers"

echo "▶️ Running the tests containers..."
docker compose --file "$testsFilename" up --build --remove-orphans $testsContainers

result=$?

if [ "$result" -eq 0 ]; then
  echo "👍 All tests passed!"

  go_down
else
  fail "Some tests failed!"
fi;