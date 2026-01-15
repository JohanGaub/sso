FROM nginx:1-alpine-slim AS base

RUN apk update \
    && apk add bash

COPY docker/nginx/symfony.template /etc/nginx/conf.d/default.conf

WORKDIR /var/www/symfony/public

RUN chmod 775 /var/www/symfony/public


