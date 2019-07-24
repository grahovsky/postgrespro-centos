#!/bin/bash

docker container run --name postgrespro \
    -dit \
    --privileged \
    --net my_app_net \
    -p 5432:5432 \
    -v psql:/var/lib/pgsql \
    grahovsky/postgrespro

#--detach \
