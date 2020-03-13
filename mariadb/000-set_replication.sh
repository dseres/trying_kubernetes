#!/bin/bash
set -eo pipefail
shopt -s nullglob

if [[ $MARIADB_REPLICATION_SERVER_TYPE == "MASTER" ]]; then
  echo "Setting up MariaDB replication with MASTER configuration"
  docker_process_sql <<< "CREATE USER '$MARIADB_REPLICATION_USER'@'%' IDENTIFIED BY '$MARIADB_REPLICATION_PASSWORD' ;"
  docker_process_sql <<< "GRANT REPLICATION SLAVE ON *.* TO '$MARIADB_REPLICATION_USER'@'%' IDENTIFIED BY '$MARIADB_REPLICATION_PASSWORD' ;"
  docker_process_sql <<< "FLUSH PRIVILEGES ;"
  docker_process_sql <<< "CHANGE MASTER TO MASTER_USE_GTID = slave_pos;"
elif [[ $MARIADB_REPLICATION_SERVER_TYPE == "SLAVE" ]]; then
  echo "Setting up MariaDB replication with SLAVE configuration"
  docker_process_sql <<< "STOP SLAVE;"
  docker_process_sql <<< "CHANGE MASTER TO master_host='$MARIADB_REPLICATION_HOST', master_user='$MARIADB_REPLICATION_USER', master_password='$MARIADB_REPLICATION_PASSWORD' ;"
  docker_process_sql <<< "START SLAVE;"
fi
