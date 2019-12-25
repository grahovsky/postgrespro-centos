#!/bin/bash
docker rm -f postgrespro-1c 2>/dev/null

docker container run --name postgrespro-1c \
    -dit \
    --net my_app_net \
    -p 5432:5432 \
    -v pgpro:/var/lib/pgpro \
    grahovsky/postgrespro-1c:latest

#--detach \
#--privileged \
