# Postgrespro Dockerfile on CentOS 7

This repository contains a Dockerfile to build a Docker Image for Postgrespro on CentOS 7

## Base Docker Image

* [centos](https://hub.docker.com/_/centos/)

## Usage

### Installation

1. Install [Docker](https://www.docker.com/).

2. You can download automated build from public Docker Hub Registry:

``` docker pull grahovsky/postgrespro:latest ```


**Another way: build from Github**

To create the image grahovsky/postgrespro, clone this repository and execute the following command on the docker-postgrespro folder:

`docker build -t grahovsky/postgrespro:latest .`

Another alternatively, you can build an image directly from Github:

`docker build -t="grahovsky/postgresql:latest" github.com/grahovsky/postgrespro-centos`


### Create and running a container

**Create container:**

(Not recommended for production use)

``` docker create -it -p 5432:5432 --name postgrespro grahovsky/postgrespro ```

**Start container:**

``` docker start postgrespro ```


**Another way to start a postgresql container:**

``` docker run -d -p 5432:5432 --name postgrespro grahovsky/postgrespro ```

### Connection methods:

**PostgreSQL client:**

`docker exec -it postgrespro psql`

**Bash:**

`docker exec -it postgrespro bash`


### Creating a database and username

You can create a postgresql database and superuser at launch. Use `DB_NAME`, `DB_USER` and `DB_PASS` variables.

```
docker create -it -p 5432:5432 --name postgrespro --env 'DB_USER=YOUR_USERNAME' --env 'DB_PASS=YOUR_PASSWORD' --env 'DB_NAME=YOUR_DATABASE' grahovsky/postgrespro

```
 
If you don't set DB_PASS variable, an automatic password is generated for the PostgreSQL database user. Check to stdout/stderr log of container created:

```
docker run -d -p 5432:5432 --name postgrespro --env 'DB_USER=YOUR_USERNAME' --env 'DB_NAME=YOUR_DATABASE' grahovsky/postgrespro
docker logs postgrespro
```

The output:

```
...
WARNING: 
No password specified for "YOUR_USERNAME". Generating one
Password for "YOUR_USERNAME" created as: "aich3aaH0yiu"
...
```

To connect to newly created postgresql container:

`docker exec -it postgrespro psql -U YOUR_USERNAME`

Another way to connect to postgresql container with your newly created user:

```
psql -U YOUR_USERNAME -h $(docker inspect --format {{.NetworkSettings.IPAddress}} postgrespro)
```


### Upgrading

Stop the currently running image:

``` docker stop postgrespro ```


Update the docker image:

``` docker pull grahovsky/postgrespro:latest ```
