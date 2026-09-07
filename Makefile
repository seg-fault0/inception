COMPOSE = docker compose -f srcs/docker-compose.yml

all: up

up:
	@sudo mkdir -p /home/wimam/data/wordpress /home/wimam/data/mariadb
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --rmi all

fclean: clean
	$(COMPOSE) down --volumes
	sudo rm -rf /home/wimam/data

re: fclean all