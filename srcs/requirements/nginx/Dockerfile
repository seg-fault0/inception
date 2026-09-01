FROM debian:latest

RUN apt-get update && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/wimam.key \
    -out /etc/nginx/ssl/wimam.crt \
    -subj "/C=MA/ST=Khouribga/L=Khouribga/O=42/OU=42/CN=localhost"

COPY config/nginx.conf /etc/nginx/conf.d/wimam.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]	