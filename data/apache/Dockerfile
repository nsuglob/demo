FROM php:8.0-apache

WORKDIR /var/www/html

COPY . .
COPY ./ports.conf /etc/apache2/ports.conf
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
RUN rm -rf /etc/apache2/sites-enabled/*
RUN a2ensite 000-default.conf

