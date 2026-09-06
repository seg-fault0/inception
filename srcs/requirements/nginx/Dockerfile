FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl

COPY config/nginx.conf /etc/nginx/conf.d/wimam.conf

COPY ./tools/script.sh /
RUN chmod +x /script.sh

CMD ["/script.sh"]