SRC     = srcs/
REQ     = $(SRC)requirements/
COMPOSE = $(SRC)docker-compose.yml
ENV     = --env-file $(SRC).env

DB      = /home/${USER}/data/mariadb
WP      = /home/${USER}/data/wordpress

DOCKER_COMPOSE = docker-compose -f $(COMPOSE) $(ENV)

all: up

up:
	@echo "Creating directories..."
	mkdir -p $(WP) $(DB)
	@echo "Bringing up Docker containers..."
	$(DOCKER_COMPOSE) up -d --build --quiet
	@echo "---Docker containers are up---"

down:
	@echo "Bringing down Docker containers..."
	$(DOCKER_COMPOSE) down -v --remove-orphans --quiet
	@echo "---Docker containers are down---"

start:
	@echo "Starting Docker containers..."
	$(DOCKER_COMPOSE) start --quiet
	@echo "---Docker containers are started---"

stop:
	@echo "Stopping Docker containers..."
	$(DOCKER_COMPOSE) stop --quiet
	@echo "---Docker containers are stopped---"

status:
	@echo "Status of Docker containers:"
	docker ps -a

clean: down
	@echo "Cleaning Docker system and data..."
	docker system prune -a -f --quiet
	@[ -d $(WP) ] && sudo rm -rf $(WP)/* || echo "No WordPress data to clean."
	@[ -d $(DB) ] && sudo rm -rf $(DB)/* || echo "No MariaDB data to clean."
	@echo "---Docker system and data cleaned---"

fclean: down
	@echo "Total clean of all Docker configurations and data"
	docker stop $$(docker ps -qa)
	docker system prune --all --force --volumes --quiet
	docker network prune --force --quiet
	docker volume prune --force --quiet
	@[ -d $(WP) ] && sudo rm -rf $(WP)/* || echo "No WordPress data to clean."
	@[ -d $(DB) ] && sudo rm -rf $(DB)/* || echo "No MariaDB data to clean."
	@echo "---Total clean completed---"

logs:
	@echo "Logs of Docker containers:"
	$(DOCKER_COMPOSE) logs --quiet

restart: down
	@echo "Restarting Docker configuration..."
	$(DOCKER_COMPOSE) up -d --quiet
	@echo "---Docker configuration restarted---"

.PHONY: all up down start stop status clean fclean logs restart
