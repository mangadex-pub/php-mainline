ARG DEBIAN_CODENAME="bullseye"
FROM docker.io/library/debian:${DEBIAN_CODENAME}-slim as base

LABEL maintainer="MangaDex open-source <opensource@mangadex.org>"

ARG DEBIAN_CODENAME
ENV DEBIAN_CODENAME "$DEBIAN_CODENAME"

ENV DEBIAN_FRONTEND "noninteractive"
ENV TZ "UTC"
RUN echo 'Dpkg::Progress-Fancy "0";' > /etc/apt/apt.conf.d/99progressbar

ARG PHP_VERSION="8.2"
ENV PHP_VERSION="${PHP_VERSION}"

RUN apt -q update && \
    apt -qq -y full-upgrade && \
    apt -qq -y autoremove && \
    apt -qq -y --no-install-recommends install \
      apt-transport-https \
      apt-utils \
      ca-certificates \
      curl \
      gnupg2 \
      debian-archive-keyring && \
      update-ca-certificates

RUN curl -Ss https://packages.sury.org/php/apt.gpg | gpg --dearmor | tee /usr/share/keyrings/sury-archive-keyring.gpg >/dev/null && \
    gpg --dry-run --quiet --import --import-options import-show /usr/share/keyrings/sury-archive-keyring.gpg | grep "15058500A0235D97F5D10063B188E2B695BD4743" && \
    echo "deb [signed-by=/usr/share/keyrings/sury-archive-keyring.gpg] https://packages.sury.org/php/ ${DEBIAN_CODENAME} main" | tee /etc/apt/sources.list.d/sury-php.list

RUN apt -q update && \
    apt -qq -y full-upgrade && \
    apt -qq -y autoremove && \
    apt -qq -y --no-install-recommends install \
      pcre2-utils \
      php${PHP_VERSION}-cgi \
      php${PHP_VERSION}-cli \
      php${PHP_VERSION}-fpm && \
    apt -qq -y --purge autoremove && \
    apt -qq -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* /var/log/*

# Updated to latest available from time to time
COPY --from=docker.io/library/composer:2.4.4 /usr/bin/composer /usr/bin/composer
RUN php -v && composer -V

FROM base as snuffleupagus

RUN apt -q update && \
    apt -qq -y full-upgrade && \
    apt -qq -y autoremove && \
    apt -qq -y --no-install-recommends install \
      build-essential \
      git \
      libpcre2-dev \
      php-pear \
      php${PHP_VERSION}-dev \
      re2c

COPY build-snuffleupagus.sh /build-snuffleupagus.sh
RUN /build-snuffleupagus.sh /snuffleupagus 808e7bff7e17b4f22a64120162734301aa065db0

FROM base

# Install Snuffleupagus and enable it by default
COPY --from=snuffleupagus --chown=root:root /snuffleupagus/src/modules/snuffleupagus.so /tmp/snuffleupagus.so
RUN chmod -v 0644 "/tmp/snuffleupagus.so" && \
    mv -fv "/tmp/snuffleupagus.so" "$(php -r 'echo ini_get("extension_dir");')/snuffleupagus.so" # && \
    chmod -v 0644 "/etc/php/${PHP_VERSION}/{cli,fpm}/conf.d/20-snuffleupagus.ini"

COPY --chown=root:root 20-snuffleupagus.ini /etc/php/${PHP_VERSION}/cgi/conf.d/20-snuffleupagus.ini
COPY --chown=root:root 20-snuffleupagus.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-snuffleupagus.ini
COPY --chown=root:root 20-snuffleupagus.ini /etc/php/${PHP_VERSION}/fpm/conf.d/20-snuffleupagus.ini

RUN php${PHP_VERSION}     -d 'sp.configuration_file=/dev/null' -m | grep "snuffleupagus" >/dev/null
RUN php-cgi${PHP_VERSION} -d 'sp.configuration_file=/dev/null' -m | grep "snuffleupagus" >/dev/null
RUN php-fpm${PHP_VERSION} -d 'sp.configuration_file=/dev/null' -m | grep "snuffleupagus" >/dev/null

RUN groupadd -r -g 999 mangadex && useradd -u 999 -r -g 999 mangadex
USER mangadex
WORKDIR /tmp
RUN php -v
