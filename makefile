all: UP

UP:
	@docker compose up --build -d

stop:
	@docker compose stop

down:
	@docker compose down