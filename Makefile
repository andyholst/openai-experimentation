SHELL := /bin/bash

ROCM_ARCH="$(shell ./get_rocm_arch.sh)"

DOCKER_COMPOSE_BINARY := docker-compose
DOCKER_COMPOSE_FILES := docker-compose-files
DOCKER_COMPOSE_AMD_PIP_COMPILER_FILE := $(DOCKER_COMPOSE_FILES)/amd-pip-compiler.yaml
DOCKER_COMPOSE_PIP_COMPILER_FILE := $(DOCKER_COMPOSE_FILES)/pip-compiler.yaml
DOCKER_COMPOSE_AMD_UNIT_TEST_FILE := $(DOCKER_COMPOSE_FILES)/amd-unit-tests.yaml
DOCKER_COMPOSE_UNIT_TEST_FILE := $(DOCKER_COMPOSE_FILES)/unit-tests.yaml
DOCKER_COMPOSE_INTEGRATION_TEST_FILE := $(DOCKER_COMPOSE_FILES)/integration-tests.yaml
DOCKER_COMPOSE_AMD_BUILD_APP_FILE := $(DOCKER_COMPOSE_FILES)/amd-build-app.yaml
DOCKER_COMPOSE_AMD_RUN_APP_FILE := $(DOCKER_COMPOSE_FILES)/amd-run-app.yaml
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

amd-unit-tests: build-unit-tests
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_AMD_UNIT_TEST_FILE) run --rm unit-tests

build-integration-tests:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_INTEGRATION_TEST_FILE) build --build-arg "VERSION=${VERSION}" \
	integration-tests

integration-tests: build-integration-tests
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_INTEGRATION_TEST_FILE) run --rm integration-tests

build-app-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) build --build-arg "VERSION=${VERSION}" \
	pip-compiler

update-app-requirements: build-app-requirements
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm  pip-compiler

amd-build-app-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_AMD_PIP_COMPILER_FILE) build --build-arg "VERSION=${VERSION}" \
	pip-compiler

amd-update-app-requirements: amd-build-app-requirements
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_AMD_PIP_COMPILER_FILE) run --rm pip-compiler

build-app:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_BUILD_APP_FILE) build --force-rm --no-cache \
	--build-arg "VERSION=${VERSION}"

build-app-quick:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_BUILD_APP_FILE) build --build-arg "VERSION=${VERSION}"

amd-build-app:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_AMD_BUILD_APP_FILE) build --force-rm --no-cache \
	--build-arg "VERSION=${VERSION}" --build-arg "ROCM_ARCH=$(ROCM_ARCH)" \
	--progress plain

amd-build-app-quick:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_AMD_BUILD_APP_FILE) build --build-arg "VERSION=${VERSION}" \
	--build-arg "ROCM_ARCH=$(ROCM_ARCH)"

amd-run-app:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_AMD_RUN_APP_FILE) run app

run-app:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_RUN_APP_FILE) run --rm app

run-app-cli:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_RUN_APP_FILE) run --rm -it --tty app /bin/bash
