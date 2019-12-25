#!/bin/bash
set -e

#Version
PG_VERSION=${PG_VERSION:=10}

PG_DIR=${PG_DIR:=/opt/pgpro/1c-$PG_VERSION/bin}
PGHOME=${PGHOME:=/var/lib/pgpro}
PGDATA=${PGDATA:=$PGHOME/1c-$PG_VERSION/data}
PG_PORT=${PG_PORT:=5432}

initbase () {
  
  if [ -z "$(ls -A $PGDATA)" ]; then
    $PG_DIR/initdb -D $PGDATA --locale=ru_RU.UTF-8
    cp /tmp/postgresql.conf $PGDATA/
    cp /tmp/pg_hba.conf $PGDATA/
  else
    echo "base exist"
  fi

}

postgresql_server () {
  
  echo "step. start server"
  $PG_DIR/postgres -D $PGDATA -p $PG_PORT
  # Copy config file
  

}

####
####
echo "Starting PostgreSQL $PG_VERSION server..."
initbase
postgresql_server
