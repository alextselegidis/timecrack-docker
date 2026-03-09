FROM php:8.2-apache

LABEL maintainer="Alex Tselegidis (alextselegidis.com)"

ARG VERSION

# Laravel application environment variables
ENV APP_NAME="Timecrack"
ENV APP_ENV="production"
ENV APP_KEY=""
ENV APP_DEBUG="false"
ENV APP_URL="http://localhost"

ENV LOG_CHANNEL="stack"
ENV LOG_LEVEL="error"

ENV DB_CONNECTION="mysql"
ENV DB_HOST="db"
ENV DB_PORT="3306"
ENV DB_DATABASE="timecrack"
ENV DB_USERNAME="root"
ENV DB_PASSWORD="secret"

ENV BROADCAST_DRIVER="log"
ENV CACHE_DRIVER="file"
ENV FILESYSTEM_DISK="local"
ENV QUEUE_CONNECTION="sync"
ENV SESSION_DRIVER="file"
ENV SESSION_LIFETIME="120"

ENV MEMCACHED_HOST="127.0.0.1"

ENV REDIS_HOST="127.0.0.1"
ENV REDIS_PASSWORD="null"
ENV REDIS_PORT="6379"

ENV MAIL_MAILER="smtp"
ENV MAIL_HOST="mailpit"
ENV MAIL_PORT="1025"
ENV MAIL_USERNAME="null"
ENV MAIL_PASSWORD="null"
ENV MAIL_ENCRYPTION="null"
ENV MAIL_FROM_ADDRESS="hello@example.com"
ENV MAIL_FROM_NAME="Timecrack"

EXPOSE 80

WORKDIR /var/www/html

COPY ./assets/99-overrides.ini /usr/local/etc/php/conf.d
COPY ./assets/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./assets/docker-entrypoint.sh /usr/local/bin

RUN a2enmod rewrite \
    && apt-get update \
    && apt-get install -y libfreetype-dev libjpeg62-turbo-dev libpng-dev unzip wget \
    && curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
      curl gd intl ldap mbstring mysqli xdebug odbc pdo pdo_mysql xml zip exif gettext bcmath csv event imap inotify mcrypt redis \
    && docker-php-ext-enable xdebug \
    && wget https://github.com/alextselegidis/timecrack/releases/download/${VERSION}/timecrack-${VERSION}.zip \
    && unzip timecrack-${VERSION}.zip \
    && rm timecrack-${VERSION}.zip \
    && echo "alias ll=\"ls -al\"" >> /root/.bashrc \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && chown -R www-data:www-data .

ENTRYPOINT ["docker-entrypoint.sh"]

