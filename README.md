# Build & Deploy

## Create an empty project if not have one & update lib

```bash
cd src/
composer create-project laravel/laravel . # to create an empty laravel project, copy src files of laravel project if already have a project and ignore this command.
composer update
```

---

## Change .env config

Change DB env variables to connect with mySQL DB server.

where:

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laragigs
DB_USERNAME=user
DB_PASSWORD=password

---

## Give permissions for storage folder & add link

```bash
cd src/
php artisan storage:link
sudo chmod -R o+w ./storage
```

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

## Build & Run MySQL server container

• Build & Deploy

```bash
cd laragigs/
podman image build --tag laragigs:mysql ./containers/mysql/
podman image push localhost/laragigs:mysql docker-registry.univ-nantes.fr/e191350p/laragigs:mysql
```

• Run

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

## Build & Run phpmyadmin container

• Build & Deploy

```bash
cd laragigs/
podman image build --tag laragigs:phpmyadmin ./containers/phpmyadmin/
podman image push localhost/laragigs:phpmyadmin docker-registry.univ-nantes.fr/e191350p/laragigs:phpmyadmin
```

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
  docker-registry.univ-nantes.fr/e191350p/laragigs:phpmyadmin
```

---

## Build & Run php container

• Build & Deploy

```bash
cd laragigs/
podman image build --tag laragigs:php ./containers/php/
podman image push localhost/laragigs:php docker-registry.univ-nantes.fr/e191350p/laragigs:php
```

• Run

```bash
podman run -d \
  --name laragigs_php \
  --network laragigs_network \
  -v <path to laravel project>:/var/www/html \
  docker-registry.univ-nantes.fr/e191350p/laragigs:php
```

---

## Build & Run nginx server container

• Build & Deploy

```bash
cd laragigs/
podman image build --tag laragigs:nginx ./containers/nginx/
podman image push localhost/laragigs:nginx docker-registry.univ-nantes.fr/e191350p/laragigs:nginx
```

• Run

```bash
podman run -d \
  --name laragigs_nginx \
  --network laragigs_network \
  -v <path to laravel project>:/var/www/html \
  -p 8140:80 \
  docker-registry.univ-nantes.fr/e191350p/laragigs:nginx
```

---

## Create tables in DB

```bash
podman exec laragigs_php php /var/www/html/artisan migrate
```
