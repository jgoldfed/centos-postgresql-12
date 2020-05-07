# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>
# Taken from https://github.com/CentOS/CentOS-Dockerfiles/tree/master/postgres/centos7
# With a mash-up from https://github.com/zokeber/docker-postgresql
FROM centos:centos7

ENV PGVERSION 12
ENV PG_VERSION 12
ENV HOME /var/lib/pgsql
ENV PGDATA /var/lib/pgsql/$PG_VERSION/data

RUN yum -y update; yum clean all
RUN yum -y install sudo epel-release; yum clean all
RUN rpm -vih https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm 
RUN yum -y install postgresql$PGVERSION-server postgresql$PGVERSION postgresql$PGVERSION-contrib supervisor pwgen; yum clean all

COPY ./data/postgresql-setup /usr/pgsql-$PGVERSION/bin/postgresql$PGVERSION-setup
COPY ./data/supervisord.conf /etc/supervisord.conf
COPY ./data/start_postgres.sh /usr/local/bin/start_postgres.sh

#Sudo requires a tty. fix that.
RUN chmod +x /usr/pgsql-$PGVERSION/bin/postgresql$PGVERSION-setup

WORKDIR /var/lib/pgsql
RUN /usr/pgsql-$PGVERSION/bin/postgresql$PGVERSION-setup initdb
COPY ./data/pg_hba.conf /var/lib/pgsql/$PG_VERSION/data/pg_hba.conf
COPY ./data/postgresql.conf /var/lib/pgsql/$PG_VERSION/data/postgresql.conf
RUN chown -R postgres.postgres /var/lib/pgsql/$PG_VERSION/data/*
RUN usermod -G wheel postgres
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers
RUN chmod +x /usr/local/bin/start_postgres.sh


#RUN echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/$PG_VERSION/data/pg_hba.conf

# To copy, type "docker cp <Container Name>:/var/lib/pgsql <My host directory>""
VOLUME ["/var/lib/pgsql"]
USER postgres
EXPOSE 5432
CMD ["/bin/bash", "/usr/local/bin/start_postgres.sh"]


