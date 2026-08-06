.PHONY: install-pre-commit
install-pre-commit:
	curl -LsSf uvx.sh/pre-commit/install.sh | sh

.PHONY: install-hooks
install-hooks: install-pre-commit
	pre-commit install

.PHONY: install
install:
	$(MAKE) -C api install
	$(MAKE) -C docs install
	$(MAKE) -C frontend install

.PHONY: lint
lint:
	$(MAKE) -C api lint
	$(MAKE) -C docs lint
	$(MAKE) -C frontend lint

COMPOSE_FILES ?= -f docker-compose.yml -f docker-compose.dataef.yml

.PHONY: docker-up
docker-up:
	docker compose $(COMPOSE_FILES) up -d --build
	docker compose $(COMPOSE_FILES) ps

.PHONY: docker-down
docker-down:
	docker compose $(COMPOSE_FILES) down

.PHONY: docker-logs
docker-logs:
	docker compose $(COMPOSE_FILES) logs -f

.PHONY: docker-watch
docker-watch:
	docker compose $(COMPOSE_FILES) watch

