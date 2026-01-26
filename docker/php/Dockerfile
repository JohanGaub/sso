# Define Node.js version as global ARG
ARG NODE_VERSION=22.16.0

FROM php:8.5-fpm-alpine AS base

RUN mkdir -p /var/www/symfony/var/uploads && \
    apk add --no-cache --virtual .build-deps-base \
        libc-dev \
        make \
        zlib-dev \
        autoconf \
        postgresql-dev \
        linux-headers \
        icu-dev \
        libzip-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev && \
    apk add --no-cache \
        git \
        bash \
        libzip \
        libpq \
        icu \
        icu-libs \
        icu-data-full \
        postgresql-client \
        netcat-openbsd \
        acl \
        freetype \
        libjpeg-turbo \
        libpng && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
        gd \
        zip \
        intl \
        opcache && \
    docker-php-ext-configure pdo_pgsql && \
    docker-php-ext-install --no-interaction pdo_pgsql || \
    (cd /usr/src/php/ext/pdo_pgsql && \
     docker-php-ext-configure pdo_pgsql && \
     make -j$(nproc) && \
     make install && \
     docker-php-ext-enable pdo_pgsql) && \
    printf "\n" | pecl install apcu redis && \
    docker-php-ext-enable apcu redis && \
    apk del .build-deps-base

COPY docker/php/docker-php.ini /usr/local/etc/php/conf.d/php.ini
COPY docker/php/docker-php-ext-redis.ini /usr/local/etc/php/conf.d/docker-php-ext-redis.ini

WORKDIR /var/www/symfony

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

FROM base AS devci

RUN apk add --no-cache --virtual .build-deps-devci \
    libc-dev \
    make \
    zlib-dev \
    autoconf \
    postgresql-dev \
    linux-headers \
    ; \
    pecl install -f xdebug; \
    docker-php-ext-enable xdebug; \
    apk del .build-deps-devci;

COPY docker/php/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Create intermediate stage from Node.js official image
FROM node:${NODE_VERSION}-alpine AS node_source

FROM devci AS ci

# Define npm version
ARG NPM_VERSION=11.6.3

# Install Node.js and npm using Multi-stage build for cross-platform compatibility
# This method works on ARM64 (Apple Silicon), AMD64 (Intel), and all other architectures
COPY --from=node_source /usr/local/include/ /usr/local/include/
COPY --from=node_source /usr/local/lib/ /usr/local/lib/
COPY --from=node_source /usr/local/bin/ /usr/local/bin/

# Re-link npm/npx and update npm to specified version
RUN ln -sf /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -sf /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && npm install -g npm@${NPM_VERSION} \
    && npm config set update-notifier false

# Verify installation
RUN node --version && npm --version

CMD ["php-fpm"]

FROM devci AS dev

RUN git config --global --add safe.directory /var/www/symfony
COPY docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    curl -sS https://get.symfony.com/cli/installer | bash && \
    mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]


