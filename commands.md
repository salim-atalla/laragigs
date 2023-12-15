# Run Containers

This guide outlines the steps to run containers for a Laravel project using Podman. Follow these instructions to set up and deploy the necessary containers.

## Authenticate with Docker Registry

Before running containers, authenticate with the Docker registry of Nantes University:

```bash
podman login docker-registry.univ-nantes.fr
```

---

## Create Virtual Network

Create a virtual network for communication between containers:

```bash
podman network create laragigs_network
```

---

## Create Shared Volume

Create a common volume to share project files between PHP and Nginx containers:

```bash
podman volume create laragigs_volume
```

---

## Run MySQL Server Container

Run the MySQL server container with the following command:

```bash
podman run -d \
 --name laragigs_mysql \
 --network laragigs_network \
 -v <path to mysql data folder>:/var/lib/mysql \
 -e MYSQL_ROOT_PASSWORD=root \
 -e MYSQL_DATABASE=laragigs \
 -e MYSQL_USER=user \
 -e MYSQL_PASSWORD=password \
 --userns=keep-id \
  docker-registry.univ-nantes.fr/e191350p/laragigs:mysql
```

---

## Run phpMyAdmin Container

Run the phpMyAdmin container:

```bash
podman run -d \
  --name laragigs_phpmyadmin \
  --network laragigs_network \
  -e PMA_HOST=laragigs_mysql \
  -e PMA_PORT=3306 \
  -e MYSQL_USER=user \
  -e MYSQL_PASSWORD=password \
  -e MYSQL_ROOT_PASSWORD=root \
  -p <port for phpmyadmin>:80 \
  docker-registry.univ-nantes.fr/e191350p/laragigs:phpmyadmin
```

---

## Run PHP Container

Run the PHP container:

```bash
podman run -d \
  --name laragigs_php \
  --network laragigs_network \
  -v laragigs_volume:/var/www/html \
  docker-registry.univ-nantes.fr/e191350p/laragigs:php
```

---

## Run Nginx Server Container

Run the Nginx server container:

```bash
podman run -d \
  --name laragigs_nginx \
  --network laragigs_network \
  -v laragigs_volume:/var/www/html \
  -p <port for the app>:80 \
  docker-registry.univ-nantes.fr/e191350p/laragigs:nginx
```

---

## Permissions and Storage

Give permissions for the storage folder and create a symbolic link:

```bash
podman exec laragigs_php php /var/www/html/artisan storage:link
podman exec laragigs_php chown -R www-data:www-data /var/www/html/storage
```

---

## Create Tables in the Database

Run the following command to create tables in the database and seed initial data:

```bash
podman exec laragigs_php php /var/www/html/artisan migrate --seed
```

---

**_Note_**

-   Use the migrate command to create tables in the database.
-   To remove all data and recreate tables, add --refresh to the migrate command (migrate:refresh).
-   migrate:refresh is equivalent to DROP and CREATE in SQL.
-   The --seed option is used to generate fake data.
-   When using the 'seed' option, a user named "Salim" with the email "salim@gmail.com" and password "123" will be created, along with 20 fake job posts created by "Salim".
-   Run the --seed option only the first time; if run again, an error may occur ("create user already exists in the DB"). However, it can be added in case you include the refresh option in the migrate command.
-   Important: Ensure that all containers are running, the virtual network is created, and the shared volume is set up before attempting to run the app.

---
