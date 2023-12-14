# Build & Deploy

## Create an empty project if not have one & update lib

```bash
cd src/
composer create-project laravel/laravel . # to create an empty laravel project, copy src files of laravel project if already have a project and ignore this command.
composer update
```

## Change .env config

Change DB env variables to connect with mySQL DB server.

## Build & Run with podman-compose

```bash
podman-compose build
podman-compose up -d
```

## Give permissions for storage folder & add link

```bash
cd src/
php artisan storage:link
sudo chmod -R o+w ./storage
```

## Deploy containers

```bash

```
