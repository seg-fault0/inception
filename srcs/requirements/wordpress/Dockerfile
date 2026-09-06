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
	netcat-openbsd \
	&& rm -rf /var/lib/apt/lists/*

COPY ./tools/script.sh /
RUN chmod +x /script.sh

CMD ["/script.sh"]