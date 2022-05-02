DOCKER_COMPOSE_BINARY := docker-compose
DOCKER_COMPOSE_FILES := docker-compose-files
DOCKER_COMPOSE_PIP_COMPILER_FILE := $(DOCKER_COMPOSE_FILES)/pip-compiler.yaml
DOCKER_COMPOSE_UNIT_TEST_FILE := $(DOCKER_COMPOSE_FILES)/unit-tests.yaml
DOCKER_COMPOSE_INTEGRATION_TEST_FILE := $(DOCKER_COMPOSE_FILES)/integration-tests.yaml
DOCKER_COMPOSE_BUILD_APP_FILE := $(DOCKER_COMPOSE_FILES)/build-app.yaml
DOCKER_COMPOSE_RUN_APP_FILE := $(DOCKER_COMPOSE_FILES)/run-app.yaml

export VERSION := $(shell git rev-parse --short HEAD)

validate-docker-compose-files:
	$(foreach file, $(wildcard $(DOCKER_COMPOSE_FILES)/*.yaml), \
	$(DOCKER_COMPOSE_BINARY) --file="${file}" config > /dev/null || exit $?;)

build-unit-tests:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_UNIT_TEST_FILE) build --build-arg "VERSION=${VERSION}" unit-tests

unit-tests: build-unit-tests
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_UNIT_TEST_FILE) run --rm unit-tests

build-integration-tests:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_INTEGRATION_TEST_FILE) build integration-tests

integration-tests: build-integration-tests
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_INTEGRATION_TEST_FILE) run --rm integration-tests

update-unit-tests-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm pip-compiler

update-integration-tests-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm pip-compiler

update-openai-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm  pip-compiler

update-app-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm  pip-compiler

build-app:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_BUILD_APP_FILE) build --force-rm --no-cache \
	--build-arg "VERSION=${VERSION}"

run-app:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_RUN_APP_FILE) run --rm --tty app /bin/bash
