FROM ghcr.io/unb-libraries/base:2.x
MAINTAINER UNB Libraries <libsupport@unb.ca>

ENV COMPOSER_INSTALL "composer install --prefer-dist --no-interaction --no-progress"
ENV COMPOSER_MEMORY_LIMIT -1
ENV COMPOSER_PATH /usr/local/bin
ENV COMPOSER_EXIT_ON_PATCH_FAILURE 1
ENV PHP_CONFD_DIR /etc/php8/conf.d
ENV PHP_APP_INI_FILE $PHP_CONFD_DIR/zz_app.ini

COPY ./build /build

RUN apk --no-cache add \
    php8 \
    php8-curl \
    php8-gd \
    php8-iconv \
    php8-json \
    php8-openssl \
    php8-phar \
    php8-xml \
    php8-zlib && \
  ln -s /usr/bin/php8 /usr/bin/php && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir="$COMPOSER_PATH" --filename=composer && \
  $RSYNC_COPY /build/conf/php/app-php.ini "$PHP_APP_INI_FILE" && \
  $RSYNC_COPY /build/scripts/ /scripts/ && \
  chmod -R 755 /scripts

LABEL ca.unb.lib.generator="php" \
  ca.unb.lib.php.version="8.1" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.description="php-cli is the base php CLI application image at UNB Libraries." \
  org.label-schema.name="php-cli" \
  org.label-schema.url="https://github.com/unb-libraries/docker-php-cli" \
  org.label-schema.vcs-url="https://github.com/unb-libraries/docker-php-cli" \
  org.label-schema.version=$VERSION \
  org.opencontainers.image.source="https://github.com/unb-libraries/docker-php-cli"
