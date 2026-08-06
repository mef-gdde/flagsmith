.PHONY: help
help:
	@echo "Available targets:"
	@echo "  docker-up            Start containers via docker compose"
	@echo "  docker-down          Stop containers via docker compose"
	@echo "  docker-logs          Tail container logs"
	@echo "  docker-watch         Watch and sync container files"
	@echo "  build-image          Build both API and Frontend docker images using buildx"
	@echo "  build-api-image      Build API docker image using buildx"
	@echo "  build-frontend-image  Build Frontend docker image using buildx"
	@echo "  install              Install dependencies across subdirectories"
	@echo "  lint                 Lint code across subdirectories"
	@echo "  install-hooks        Install git pre-commit hooks"

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

# Load build variables from .env.build if present
-include .env.build

TAG ?= latest
PLATFORM ?= linux/amd64,linux/arm64
API_IMAGE ?= $(if $(REGISTRY),$(REGISTRY)/)flagsmith-api:$(TAG)
FRONTEND_IMAGE ?= $(if $(REGISTRY),$(REGISTRY)/)flagsmith-frontend:$(TAG)
ACTION ?= $(if $(REGISTRY),--push,--load)

.PHONY: build-image
build-image: build-api-image build-frontend-image
	@echo "Done building images:"
	@echo "  API:      $(API_IMAGE)"
	@echo "  Frontend: $(FRONTEND_IMAGE)"

.PHONY: build-api-image
build-api-image:
	@echo "Building API image: $(API_IMAGE)"
	docker buildx build \
		--platform $(PLATFORM) \
		--target oss-api \
		-t $(API_IMAGE) \
		$(ACTION) .

.PHONY: build-frontend-image
build-frontend-image:
	@echo "Building Frontend image: $(FRONTEND_IMAGE)"
	docker buildx build \
		--platform $(PLATFORM) \
		--target oss-frontend \
		-t $(FRONTEND_IMAGE) \
		$(ACTION) .


