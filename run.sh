#!/bin/bash
docker rm -f postgrespro 2>/dev/null

docker container run --name postgrespro \
    -dit \
    --net my_app_net \
    -p 5432:5432 \
    -v psql:/var/lib/pgpro \
    grahovsky/postgrespro:latest

#--detach \
#--privileged \
