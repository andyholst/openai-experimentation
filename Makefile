DOCKER_COMPOSE_BINARY := docker-compose
DOCKER_COMPOSE_FILES := docker-compose-files
DOCKER_COMPOSE_PIP_COMPILER_FILE := $(DOCKER_COMPOSE_FILES)/pip-compiler.yaml
DOCKER_COMPOSE_UNIT_TEST_FILE := $(DOCKER_COMPOSE_FILES)/unit-tests.yaml
DOCKER_COMPOSE_BUILD_APP_FILE := $(DOCKER_COMPOSE_FILES)/build-app.yaml

validate-docker-compose-files: $(DOCKER_COMPOSE_FILES)/*
	for file in $^ ; do \
		$(DOCKER_COMPOSE_BINARY) --file="$${file}" config > /dev/null || exit $?; \
	done

build-unit-tests:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_UNIT_TEST_FILE) build unit-tests

unit-tests: build-unit-tests
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_UNIT_TEST_FILE) run --rm unit-tests

update-unit-tests-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm pip-compiler

update-app-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm  pip-compiler

build-app:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_BUILD_APP_FILE) --force-rm --no-cache
