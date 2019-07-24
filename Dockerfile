#
# PostgreSQL Dockerfile on CentOS 7
#

# Build:
# docker build -t grahovsky/postgrespro:latest .
#
# Create:
# docker create -it -p 5432:5432 --name postgrespro grahovsky/postgrespro
#
# Start:
# docker start postgrespro
#
# Connect with postgresql client
# docker exec -it postgrespro psql
#
# Connect bash
# docker exec -it postgrespro bash


# Pull base image
FROM centos:centos7

# Maintener
MAINTAINER Konstantin Grahovsky <grahovsky@gmail.com>

# Postgresql version
ENV PG_VERSION 9.6
ENV PGVERSION 96

# Set the environment variables
ENV PGHOME /var/lib/pgsql
ENV PGDATA /var/lib/pgsql/$PG_VERSION/data

# Install postgresql and run InitDB
RUN rpm -ivh http://1c.postgrespro.ru/keys/postgrespro-1c-centos$PGVERSION.noarch.rpm && \
    yum install postgresql$PGVERSION postgresql$PGVERSION-server && \
    localedef  -i ru_RU -f UTF-8 ru_RU.UTF-8

# Initdb
USER postgres
RUN /usr/pgsql-$PG_VERSION/bin/initdb -D $PGHOME/data --locale=ru_RU.UTF-8

USER root

# Copy
COPY data/i18n /etc/sysconfig/
#COPY data/postgresql-setup /usr/pgsql-$PG_VERSION/bin/postgresql$PGVERSION-setup

# Working directory
WORKDIR $PGHOME

# Copy config file
#COPY data/postgresql.conf $PGHOME/$PG_VERSION/data/postgresql.conf
#COPY data/pg_hba.conf $PGHOME/$PG_VERSION/data/pg_hba.conf
#COPY data/postgresql.sh /usr/local/bin/postgresql.sh

# Change own user
#RUN chown -R postgres:postgres $PGHOME/$PG_VERSION/data/* && \
#    usermod -G wheel postgres && \
#    sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers && \
#    chmod +x /usr/local/bin/postgresql.sh

# Set volume
VOLUME ["/var/lib/pgsql"]

# Expose ports.
EXPOSE 5432

# Set username
USER postgres

# Run PostgreSQL Server
ENTRYPOINT ["/bin/bash", "/usr/local/bin/postgresql.sh"]

ENTRYPOINT ["/bin/bash", "/usr/pgsql-$PG_SQL/bin/pg_ctl", "-D", "$PGHOME/data", "-l", "logfile", "start"]