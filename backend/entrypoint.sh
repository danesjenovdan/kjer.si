#!/usr/bin/env bash

###############################################################
#                                                             #
# NOT BEST PRACTICE I GUESS                                   #
# Getting dependencies after the volume was bound by          #
# docker-compose, because it overrides any actions performed  #
# by the Dockerfile build.                                    #
#                                                             #
# So if you want to have your deps available in entrypoint.sh #
# you need to install them here as well.                      #
#                                                             #
###############################################################

mix local.hex --force
mix local.rebar --force

mix deps.get

# Wait until Postgres is ready
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
  mix ecto.migrate
  mix run priv/repo/seeds.exs
  echo "Database $PGDATABASE created."
fi

exec mix phx.server
