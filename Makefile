# Etherpad-lite Docker Makefile
COMPOSE     = docker-compose
COMPOSE_RUN = $(COMPOSE) run --rm
WAIT_DB     = $(COMPOSE_RUN) dockerize -wait tcp://postgresql:5432 -timeout 60s

default: help

# -- Project
private/SESSIONKEY.txt:
	mkdir -p private
	head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 > private/SESSIONKEY.txt

private/APIKEY.txt:
	mkdir -p private
	head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 > private/APIKEY.txt

# -- Docker/compose
build: ## build the etherpad container
	@$(COMPOSE) build etherpad
.PHONY: build

down: ## remove stack (warning: it removes the database container)
	@$(COMPOSE) down
.PHONY: down

logs: ## display etherpad logs (follow mode)
	@$(COMPOSE) logs -f etherpad
.PHONY: logs

run: \
  private/SESSIONKEY.txt \
  private/APIKEY.txt
run: ## start the server
	@$(COMPOSE) up -d postgresql
	@$(WAIT_DB)
	@$(COMPOSE) up -d etherpad
.PHONY: run

status: ## an alias for "docker-compose ps"
	@$(COMPOSE) ps
.PHONY: status

stop: ## stop the server
	@$(COMPOSE) stop
.PHONY: stop

# -- Misc
clean: ## restore repository state as it was freshly cloned
	git clean -idx
.PHONY: clean

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
