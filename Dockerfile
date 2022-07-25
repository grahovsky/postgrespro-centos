#
# PostgreSQL Dockerfile on CentOS 7
#

# Build:
# docker build -t grahovsky/postgrespro-1c:latest .
#
# Create:
# docker create -it -p 5432:5432 --name postgrespro-1c grahovsky/postgrespro-1c
#
# Start:
# docker start postgrespro-1c
#
# Connect with postgresql client
# docker exec -it postgrespro-1c psql
#
# Connect bash
# docker exec -it postgrespro-1c bash


# Pull base image
FROM centos:centos7

# Maintener
MAINTAINER Konstantin Grahovsky <grahovsky@gmail.com>

# locale
ENV LANG ru_RU.utf8
ADD data/i18n /etc/sysconfig/
RUN localedef -f UTF-8 -i ru_RU ru_RU.UTF-8

# Postgresql version
ENV PG_VERSION 12

# Set the environment variables
ENV PG_DIR=/opt/pgpro/1c-$PG_VERSION/bin
ENV PGHOME /var/lib/pgpro
ENV PGDATA $PGHOME/1c-$PG_VERSION/data

# create user with specific id for okd
ENV OKD_USER_ID 1004140000
RUN groupadd -f --gid $OKD_USER_ID postgres && \
    useradd --uid $OKD_USER_ID --gid $OKD_USER_ID --comment PostgreSQL --no-log-init --home-dir $PGHOME postgres

# Install postgresql and run InitDB
RUN rpm --import http://repo.postgrespro.ru/keys/GPG-KEY-POSTGRESPRO && \
    echo [postgrespro-1c] > /etc/yum.repos.d/postgrespro-1c.repo && \
    echo name=Postgres Pro 1C repo >> /etc/yum.repos.d/postgrespro-1c.repo && \
    echo baseurl=http://repo.postgrespro.ru/1c-archive/pg1c-12.11/centos/7/os/x86_64/rpms/ >> /etc/yum.repos.d/postgrespro-1c.repo && \
    echo gpgcheck=1 >> /etc/yum.repos.d/postgrespro-1c.repo && \
    echo enabled=1 >> /etc/yum.repos.d/postgrespro-1c.repo && \
    yum makecache && \
    yum install -y \
        postgrespro-1c-12 postgrespro-1c-12-server postgrespro-1c-12-libs  postgrespro-1c-12-devel postgrespro-1c-12-contrib \
        sudo && \
    yum clean all


# set rootpass for debug
RUN echo 'root' | passwd root --stdin

# Copy config file
ADD data/* /tmp/
#RUN chmod +x /tmp/postgresql.sh

# add permission
RUN chown -R postgres:postgres $PGHOME && \
    usermod -G wheel postgres && \
    sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers && \
    rm -rf $PGDATA/*

# Expose ports.
EXPOSE 5432

# Set volume
VOLUME $PGHOME

# change user
USER postgres

WORKDIR $PGHOME

ENTRYPOINT ["/bin/bash", "/tmp/postgresql.sh"]