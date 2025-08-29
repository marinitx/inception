# Makefile pour Inception - gestion docker-compose

# Variables
DC = docker compose -f srcs/docker-compose.yml
ENV_FILE = srcs/.env

.PHONY: all build up stop down clean logs volumes fclean re

all: build up

build:
	@echo "Building docker images..."
	mkdir -p /home/mhiguera/data/mariadb
	mkdir -p /home/mhiguera/data/wordpress
	$(DC) build

upf-%:
	docker compose -f srcs/docker-compose.yml up $* -d

buildf-%:
	docker compose -f srcs/docker-compose.yml build $* 

up:
	@echo "Starting containers..."
	$(DC) up -d
	sleep 5

stop:
	@echo "Stopping containers..."
	$(DC) stop

down:
	@echo "Removing containers..."
	$(DC) down

clean: 
	@echo "Removing all images..."
	$(DC) down --rmi all

logs:
	$(DC) logs -f

volumes:
	@echo "Stopping containers and removing volumes..."
	$(DC) down -v 
	sudo rm -rf /home/mhiguera/data

fclean: 
	@echo "Removing containers volumes and images..."
	$(DC) down -v --rmi all
	sudo rm -rf /home/mhiguera/data


re: fclean all
