#!/usr/bin/env bash
set -x
set -eo pipefail

if ! [ -x "$(command -v nc)" ]; then
  echo 'Error: nc is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v sqlx)" ]; then
  echo 'Error: sqlx is not installed.' >&2
  echo 'Use:' >&2
  echo "    cargo install sqlx-cli --no-default-features --features postgres" >&2
  exit 1
fi

# Check if a custom user has been set, otherwise default to 'postgres'
DB_USER=${POSTGRES_USER:=postgres}
# Check if a custom password has been set, otherwise default to 'password'
DB_PASSWORD="${POSTGRES_PASSWORD:=password}"
# Check if a custom database name has been set, otherwise default to 'newsletter'
DB_NAME="${POSTGRES_DB:=newsletter}"
# Check if a custom port has been set, otherwise default to '5432'
DB_PORT="${POSTGRES_PORT:=5432}"
# Check if a custom host has been set, otherwise default to 'localhost'
DB_HOST="${POSTGRES_HOST:=localhost}"

# Allow to skip Docker if a dockerized Postgres database is already running
if [[ -z "${SKIP_DOCKER}" ]]
then
  # Launch postgres using Docker
  docker run \
    -e POSTGRES_USER=${DB_USER} \
    -e POSTGRES_PASSWORD=${DB_PASSWORD} \
    -e POSTGRES_DB=${DB_NAME} \
    -p "${DB_PORT}":5432 \
    -d postgres:13-alpine \
    postgres -N 1000
    # ^ Increased maximum number of connections for testing purposes
fi

# Keep pinging Postgres until it's ready to accept commands
until nc -zv localhost "${DB_PORT}"; do
  >&2 echo "Postgres is still unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up and running on port ${DB_PORT} - running migrations now!"

DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}
export DATABASE_URL
sqlx database create
sqlx migrate run

>&2 echo "Postgres has been migrated, ready to go!"
