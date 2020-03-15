#!/bin/bash
set -eo pipefail
shopt -s nullglob


my_error() {
  echo "The following environment variables should be defined:"
  echo "  -MARIADB_REPLICATION_SERVER_TYPE to MASTER or SLAVE"
  echo "  -MARIADB_REPLICATION_USER"
  echo "  -MARIADB_REPLICATION_PASSWORD"
  echo "  -MARIADB_REPLICATION_HOST if server type is SLAVE"
  echo "  -MARIADB_REPLICATION_SERVER_ID if server type is SLAVE"
	exit 1
}

#Checking variables
if [[ $MARIADB_REPLICATION_SERVER_TYPE != "MASTER" && $MARIADB_REPLICATION_SERVER_TYPE != "SLAVE" ]]; then
  echo "MARIADB_REPLICATION_SERVER_TYPE should be configured to MASTER or SLAVE"
  my_error
fi
if [[ -z $MARIADB_REPLICATION_USER ]]; then
  echo "MARIADB_REPLICATION_USER should be defined"
  my_error
fi
if [[ -z $MARIADB_REPLICATION_PASSWORD ]]; then
  echo "MARIADB_REPLICATION_PASSWORD should be defined"
  my_error
fi
if [[ $MARIADB_REPLICATION_SERVER_TYPE == "SLAVE" && -z $MARIADB_REPLICATION_HOST ]]; then
  echo "MARIADB_REPLICATION_HOST should be defined"
  my_error
fi
if [[ $MARIADB_REPLICATION_SERVER_TYPE == "SLAVE" && -z $MARIADB_REPLICATION_SERVER_ID ]]; then
  echo "MARIADB_REPLICATION_SERVER_ID should be defined"
  my_error
fi


if [[ $MARIADB_REPLICATION_SERVER_TYPE == "SLAVE" ]]; then
    sed -i -r \
        -e "s/server_id=1/server_id=$MARIADB_REPLICATION_SERVER_ID/" \
        -e "s/log-basename=master1/log-basename=slave$MARIADB_REPLICATION_SERVER_ID/" \
        -e "s/#slave-skip-errors=1062/slave-skip-errors=1062/" \
        -e "s/#read_only/read_only/" \
        -e "s/#replicate_do_db=gitea/replicate_do_db=gitea/" \
        -e "s/^log-bin/#log-bin/" \
        /etc/mysql/mariadb.cnf
fi

/usr/local/bin/docker-entrypoint.sh "$@"
