all: UP

UP:
	@docker compose -f ./srcs/docker-compose.yml up --build -d

stop:
	@docker compose -f ./srcs/docker-compose.yml stop

down:
	@docker compose -f ./srcs/docker-compose.yml down