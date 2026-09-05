FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/setupDB.sh /
RUN chmod +x /setupDB.sh

EXPOSE 3306

CMD ["/setupDB.sh"]