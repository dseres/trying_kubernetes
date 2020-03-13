from mariadb:latest

COPY ./000-set_replication.sh /docker-entrypoint-initdb.d/
RUN cp /etc/mysql/mariadb.cnf /etc/mysql/mariadb.cnf.old
COPY ./mariadb.cnf /etc/mysql/

RUN rm /docker-entrypoint.sh
COPY ./docker-entrypoint.sh /tmp/docker-entrypoint.sh
RUN chmod 755 /tmp/docker-entrypoint.sh

ENTRYPOINT ["/tmp/docker-entrypoint.sh"]
EXPOSE 3306
CMD ["mysqld"]
