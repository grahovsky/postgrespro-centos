docker container run -d -it \
    --privileged \
    --name postgrespro \
    --network my_app_net \
    -p 5432:5432 \
    -v psql:/var/lib/pgsql grahovsky/postgrespro