PostgreSQL v12 Dockerfile on CentOS 7
===========================

Dockerfile to build PostgreSQL v12 on CentOS 7, taken from [https://github.com/CentOS/CentOS-Dockerfiles/tree/master/postgres](https://github.com/CentOS/CentOS-Dockerfiles/tree/master/postgres) and combined with the work from [https://github.com/zokeber/docker-postgresql](https://github.com/zokeber/docker-postgresql)



## Base Docker Image

* [jgoldfed/centos_postgresql-12](https://registry.hub.docker.com/u/jgoldfed/centos_postgresql-12/)

## Usage

### Installation

1. Install [Docker](https://www.docker.com/).

2. You can download automated build from public Docker Hub Registry:

``` docker pull jgoldfed/centos_postgresql-12:latest ```


**Another way: build from Github**

To create the imagejgoldfed/centos_postgresql-12, clone this repository and execute the following command on the docker-postgresql folder:

`docker build -tjgoldfed/centos_postgresql-12:latest .`

Another alternatively, you can build an image directly from Github:

`docker build -t=" jgoldfed/centos_postgresql-12:latest" github.com/jgoldfed/centos-postgresql-12/`


### Create and running a container

**Create container:**

(Not recommended for production use)

``` docker create -it -p 5432:5432 --name postgresql12 jgoldfed/centos_postgresql-12 ```

**Start container:**

``` docker start postgresql12 ```


**Another way to start a postgresql container:**

``` docker run -d -p 5432:5432 --name postgresql12 jgoldfed/centos_postgresql-1294 ```

### Connection methods:

**PostgreSQL client:**

`docker exec -it postgresql12 psql`

**Bash:**

`docker exec -it postgresql12 bash`


### Creating a database and username

You can create a postgresql database and superuser at launch. Use `DB_NAME`, `DB_USER` and `DB_PASS` variables.

```
docker create -it -p 5432:5432 --name postgresql --env 'DB_USER=YOUR_USERNAME' --env 'DB_PASS=YOUR_PASSWORD' --env 'DB_NAME=YOUR_DATABASE' jgoldfed/centos_postgresql-12

```
 
If you don't set DB_PASS variable, an automatic password is generated for the PostgreSQL database user. Check to stdout/stderr log of container created:

```
docker run -d -p 5432:5432 --name postgresql12 --env 'DB_USER=YOUR_USERNAME' --env 'DB_NAME=YOUR_DATABASE' jgoldfed/centos_postgresql-12
docker logs postgresql12
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

`docker exec -it postgresql12 psql -U YOUR_USERNAME`

Another way to connect to postgresql container with your newly created user:

```
psql -U YOUR_USERNAME -h $(docker inspect --format {{.NetworkSettings.IPAddress}} postgresql12)
```


### Upgrading

Stop the currently running image:

``` docker stop postgresql12 ```


Update the docker image:

``` docker pull jgoldfed/centos_postgresql-12:latest ```




*****Setup
-----

To build the image

    # docker build --rm -t <yourname>/centos_postgresql-12 .


Launching PostgreSQL
--------------------

#### Quick Start (not recommended for production use)

    docker run --name=postgresql12 -d -p 5432:5432 <yourname>/centos_postgresql-12


To connect to the container as the administrative `postgres` user:

    docker run -it --rm --volumes-from=postgresql <yourname>/centos_postgresl-12 sudo -u
    postgres -H psql


Creating a database at launch
-----------------------------

You can create a postgresql superuser at launch by specifying `POSTGRESQL_USER` and
`POSTGRESQL_PASSWORD` variables. You may also create a database by using `POSTGRESQL_DATABASE`.

    docker run --name postgresql12 -d \
    -e 'POSTGRESQL_USER=username' \
    -e 'POSTGRESQL_PASSWORD=ridiculously-complex_password1' \
    -e 'POSTGRESQL_DATABASE=my_database' \
    <yourname>/centos_postgresql-12

To connect to your database with your newly created user:

    psql -U username -h $(docker inspect --format {{.NetworkSettings.IPAddress}} postgresql)
