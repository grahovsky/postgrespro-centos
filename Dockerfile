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

ENV OKD_USER_ID 1001080000

RUN groupadd -f --gid $OKD_USER_ID postgres && \
    useradd --uid $OKD_USER_ID --gid $OKD_USER_ID --comment PostgreSQL --no-log-init --home-dir /var/lib/pgsql postgres

# Maintener
MAINTAINER Konstantin Grahovsky <grahovsky@gmail.com>

# Postgresql version
ENV PG_VERSION 10

# Set the environment variables
ENV PG_DIR=/opt/pgpro/1c-$PG_VERSION/bin
ENV PGHOME /var/lib/pgpro
ENV PGDATA $PGHOME/1c-$PG_VERSION/data

# Install postgresql and run InitDB
RUN yum-config-manager --add-repo "http://repo.postgrespro.ru/1c-archive/pg1c-10.10/centos/7/os/x86_64/rpms/"
RUN yum install --nogpgcheck postgrespro-1c-10 postgrespro-1c-10-server postgrespro-1c-10-libs -y \
    yum install --nogpgcheck postgrespro-1c-10-devel postgrespro-1c-10-contrib -y \
    yum install sudo -y

RUN localedef  -i ru_RU -f UTF-8 ru_RU.UTF-8

COPY data/i18n /etc/sysconfig/

RUN chown -R postgres:postgres $PGHOME/* && \
    usermod -G wheel postgres && \
    chmod 700 -R "$PGHOME" 2>/dev/null    

# Initdb
USER postgres
RUN $PG_DIR/initdb -D $PGDATA --locale=ru_RU.UTF-8

USER root

# Set volume
VOLUME ["/var/lib/pgpro"]

# Copy config file
COPY data/postgresql.conf $PGDATA/postgresql.conf
COPY data/pg_hba.conf $PGDATA/pg_hba.conf
COPY data/postgresql.sh /usr/local/bin/postgresql.sh

RUN chown -R postgres:postgres $PGDATA && \
    usermod -G wheel postgres && \
    sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers && \
    chmod +x /usr/local/bin/postgresql.sh

# Change own user
#RUN mkdir $PGDATA

# Expose ports.
EXPOSE 5432

# Set username
USER postgres

# Working directory
WORKDIR $PGHOME

#ENTRYPOINT /usr/pgsql-9.6/bin/pg_ctl -D $PGDATA -l logfile start
#ENTRYPOINT ["/usr/pgsql-9.6/bin/postgres", "-D", "/var/lib/pgsql/9.6/data"]
ENTRYPOINT ["/bin/bash", "/usr/local/bin/postgresql.sh"]

