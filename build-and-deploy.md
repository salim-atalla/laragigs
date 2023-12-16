# Build & Deploy

This guide outlines the steps to set up and deploy a Laravel project along with its dependencies using Podman. Follow these instructions to create a new project or deploy an existing one.

## Initialize or Copy Project

-   If starting a new project, navigate to the src/ directory and execute the following command to create a new Laravel project:

```bash
cd src/
composer create-project laravel/laravel .
```

-   If you already have an existing project to deploy, copy its contents into the src/ folder.

After initializing or copying the project, install its dependencies:

```bash
cd src/
composer update
```

---

## Update .env Configuration

Modify the .env file in the project to configure the MySQL database connection:

-   DB_CONNECTION=mysql
-   DB_HOST=mysql
-   DB_PORT=3306
-   DB_DATABASE=laragigs
-   DB_USERNAME=user
-   DB_PASSWORD=password

---

## Build and Push MySQL Server Container

Build and push the MySQL server container to the registry:

```bash
cd laragigs/
podman image build --tag laragigs:mysql -f Containerfile_mysql .
podman image push localhost/laragigs:mysql docker-registry.univ-nantes.fr/e191350p/laragigs:mysql
```

---

## Build and Push phpMyAdmin Container

Build and push the phpMyAdmin container:

```bash
cd laragigs/
podman image build --tag laragigs:phpmyadmin -f Containerfile_phpmyadmin .
podman image push localhost/laragigs:phpmyadmin docker-registry.univ-nantes.fr/e191350p/laragigs:phpmyadmin
```

---

## Build and Push PHP Container

Build and push the PHP container:

```bash
cd laragigs/
podman image build --tag laragigs:php -f Containerfile_php .
podman image push localhost/laragigs:php docker-registry.univ-nantes.fr/e191350p/laragigs:php
```

---

## Build and Push Nginx Server Container

Build and push the Nginx server container:

```bash
cd laragigs/
podman image build --tag laragigs:nginx -f Containerfile_nginx .
podman image push localhost/laragigs:nginx docker-registry.univ-nantes.fr/e191350p/laragigs:nginx
```

---

These steps ensure a streamlined build and deployment process for your Laravel project and its associated containers.

---
