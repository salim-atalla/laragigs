FROM php:8.3-fpm-alpine3.19

RUN docker-php-ext-install pdo pdo_mysql

RUN apk add libzip-dev

RUN docker-php-ext-install zip