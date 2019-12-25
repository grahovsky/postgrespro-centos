#!/bin/bash
set -e

#Version
PG_VERSION=${PG_VERSION:=10}

PG_DIR=${PG_DIR:=/opt/pgpro/1c-$PG_VERSION/bin}
PGHOME=${PGHOME:=/var/lib/pgpro}
PGDATA=${PGDATA:=$PGHOME/1c-$PG_VERSION/data}
PG_PORT=${PG_PORT:=5432}

postgresql_server () {
  echo "step. start server"
  $PG_DIR/postgres -D $PGDATA -p $PG_PORT
}

####
####
echo "Starting PostgreSQL $PG_VERSION server..."
postgresql_server
