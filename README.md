# trying_kubernetes

Currently the docker image is ready to operate in master-slave configuration. The master and the slave will use the same image, you can choose mode by defining MARIADB_REPLICATION_SERVER_TYPE environment variables. 

##To build image:
```
cd mariadb
docker build -t mariadb-replicas:1.0 .
```
##To run master node:
```
docker run -ti --rm --name mariadb -e MYSQL_ROOT_PASSWORD=password -e MARIADB_REPLICATION_SERVER_TYPE=MASTER -e MARIADB_REPLICATION_USER=replicator -e MARIADB_REPLICATION_PASSWORD=replicatorpwd   -e MARIADB_REPLICATION_HOST=cb24f8108f44 --network marianetw mariadb-replicas:1.0
```
##To run slave node:
```
docker run -ti --rm --name mariadb-slave -e MYSQL_ROOT_PASSWORD=password -e MARIADB_REPLICATION_SERVER_TYPE=SLAVE -e MARIADB_REPLICATION_USER=replicator -e MARIADB_REPLICATION_PASSWORD=replicatorpwd   -e MARIADB_REPLICATION_HOST=$(docker ps  | egrep 'mariadb$' | cut -f1 -d' ') -e MARIADB_REPLICATION_SERVER_ID=1001 --network marianetw mariadb-replicas:1.0
```
