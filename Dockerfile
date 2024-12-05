FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
  git zip unzip libpng-dev \
  libzip-dev default-mysql-client

RUN docker-php-ext-install pdo pdo_mysql zip gd

RUN a2enmod rewrite

COPY .. /async_symfony

WORKDIR /async_symfony

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-scripts --no-autoloader

ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"

CMD ["php", "-S", "0.0.0.0:8088", "-t", "public"]
