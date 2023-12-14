# Build & Deploy

## Create an empty project if not have one & update lib

```bash
cd src/
composer create-project laravel/laravel . # to create an empty laravel project, or copy src files of laravel project if already have a project and ignore this command.
composer update
```

---

## Change .env config

Change DB env variables to connect with mySQL DB server.

where:

-   DB_CONNECTION=mysql
-   DB_HOST=mysql
-   DB_PORT=3306
-   DB_DATABASE=laragigs
-   DB_USERNAME=user
-   DB_PASSWORD=password

---

## Login to docker-registry.univ-nantes.fr

```bash
podman login docker-registry.univ-nantes.fr
```

---

## Create the virtual network

```bash
podman network create laragigs_network
```

---

## Run MySQL server container

• Run

```bash
podman run -d \
 --name laragigs_mysql \
 --network laragigs_network \
 -e MYSQL_ROOT_PASSWORD=root \
 -e MYSQL_DATABASE=laragigs \
 -e MYSQL_USER=user \
 -e MYSQL_PASSWORD=password \
 --userns=keep-id \
  mysql:latest
```

---

## Run phpmyadmin container

• Run

```bash
podman run -d \
  --name laragigs_phpmyadmin \
  --network laragigs_network \
  -e PMA_HOST=laragigs_mysql \
  -e PMA_PORT=3306 \
  -e MYSQL_USER=user \
  -e MYSQL_PASSWORD=password \
  -e MYSQL_ROOT_PASSWORD=root \
  -p 8141:80 \
  phpmyadmin/phpmyadmin
```

---

## Create a commun volume to share project files between php & nginx containers

```bash
podman volume create laragigs_volume
```

---

## Build & Run php container

• Build & Deploy

```bash
cd laragigs/
podman image build --tag laragigs:php -f PHPContainerfile .
podman image push localhost/laragigs:php docker-registry.univ-nantes.fr/e191350p/laragigs:php
```

• Run

```bash
podman run -d \
  --name laragigs_php \
  --network laragigs_network \
  -v laragigs_volume:/var/www/html \
  docker-registry.univ-nantes.fr/e191350p/laragigs:php
```

---

## Build & Run nginx server container

• Build & Deploy

```bash
cd laragigs/
podman image build --tag laragigs:nginx -f NginxContainerfile .
podman image push localhost/laragigs:nginx docker-registry.univ-nantes.fr/e191350p/laragigs:nginx
```

• Run

```bash
podman run -d \
  --name laragigs_nginx \
  --network laragigs_network \
  -v laragigs_volume:/var/www/html \
  -p 8140:80 \
  docker-registry.univ-nantes.fr/e191350p/laragigs:nginx
```

---

## Give permissions for storage folder & add link

```bash
podman exec laragigs_php php /var/www/html/artisan storage:link
podman exec laragigs_php chown -R www-data:www-data /var/www/html/storage
```

---

## Create tables in DB

```bash
podman exec laragigs_php php /var/www/html/artisan migrate --seed
```

---

**_Note_**

migrate command to create tables is the DB.
to refresh the tables and remove all data, we can add :refresh to migrate -> migrate:refresh
migrate:refresh is equivalent to DROP and CREATE in SQL

--seed option is to make some fake data

When adding this option, a user called "Salim" with email "salim@gmail.com" and password "123" will be created, as well as 20 fake job posts.

You can run this command with --seed option only the first time, beacuse if you run it again you will have an error "create user already existe in the DB".

Important: make sure that you run all commands above in order before trying the app.

---
