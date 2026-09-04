FROM debian:bookworm

RUN apt-get update && apt-get -y install \
    wget \
    php \
    php-cgi \
    php-mysql \
    php-fpm \
    php-pdo \
    php-gd php-cli \
    php-mbstring \
    redis \
    php-redis \
	php8.2-curl \
	php8.2-xml \
	php8.2-zip \
	php8.2-mbstring \
    && rm -rf /var/lib/apt/lists/*

COPY ./tools/setupWP.sh /
RUN chmod +x /setupWP.sh

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf
RUN mkdir -p /run/php

CMD ["/setupWP.sh"]