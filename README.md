# trying_kubernetes

The purpose of this repository to document the process and result of learning Kubernetes. My main objective to deploy a  Gitea service with replicated MariaDB on a Kubernetes cluster.

## docker images
Currently a MariaDB docker image is ready to operate in master-slave configuration. Image is based on latest [official mariadb](https://hub.docker.com/_/mariadb) image.

The master and the slave mysql servers will use the same image, you can choose between modes by defining MARIADB_REPLICATION_SERVER_TYPE environment variables.


**To build image:**
```
cd mariadb
docker build -t mariadb-replicas:1.0 .
```
**To run master node:**
```
docker run -ti --rm --name mariadb --hostname mariadb -e MYSQL_ROOT_PASSWORD=password -e MARIADB_REPLICATION_SERVER_TYPE=MASTER -e MARIADB_REPLICATION_USER=replicator -e MARIADB_REPLICATION_PASSWORD=replicatorpwd --network marianetw -v /docker_data/mariadb_master:/var/lib/mysql mariadb-replicas:1.0
```
**To run slave node:**
```
docker run -ti --rm --name mariadb-slave --hostname mariadb-slave -e MYSQL_ROOT_PASSWORD=password -e MARIADB_REPLICATION_SERVER_TYPE=SLAVE -e MARIADB_REPLICATION_USER=replicator -e MARIADB_REPLICATION_PASSWORD=replicatorpwd   -e MARIADB_REPLICATION_HOST=mariadb -e MARIADB_REPLICATION_SERVER_ID=1001 --network marianetw -v /docker_data/mariadb_slave:/var/lib/mysql mariadb-replicas:1.0
```

**To run Gitea image:**
```
docker run -ti --rm --name gitea --hostname gitea -e USER_UID=1000 -e USER_GID=1000 -e DB_TYPE=mysql -e DB_HOST=mariadb:3306 -e DB_NAME=gitea -e DB_USER=gitea -e DB_PASSWD=gitea --network marianetw -p 13000:3000 -p 10022:22 -v /docker_data/gitea:/data gitea/gitea:latest
```
After that type http://localhost:13000/install into your browser and finish installation. Just use the password for the first account you made
Check replication with connecting to slave database:
```
docker exec -ti mariadb-slave mysql -uroot -ppassword
MariaDB [(none)]> use gitea;
MariaDB [(none)]> select * from user;
```

## docker compose
Next step was automating the start and stop by docker-compose.
To start services, type:
```
cd gitea
docker-compose up
docker-compose STOP
```
