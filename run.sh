#!/bin/bash
docker rm -f postgrespro

docker container run --name postgrespro \
    -dit \
    --privileged \
    --net my_app_net \
    -p 5432:5432 \
    -v psql:/var/lib/pgsql/9.6/data \
    grahovsky/postgrespro

#--detach \
