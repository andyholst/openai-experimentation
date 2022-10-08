SHELL := /bin/bash

export ROCM_ARCH="$(shell ./get_rocm_arch.sh)"
export ROCM_VERSION="$(shell ./get_rocm_version.sh)"

DOCKER_COMPOSE_BINARY := docker-compose
DOCKER_COMPOSE_FILES := docker-compose-files

DOCKER_COMPOSE_PIP_COMPILER_FILE := --file="$(DOCKER_COMPOSE_FILES)/pip-compiler.yaml"
DOCKER_COMPOSE_AMD_UNIT_TEST_FILE := --file="$(DOCKER_COMPOSE_FILES)/amd-unit-tests.yaml"
DOCKER_COMPOSE_UNIT_TEST_FILE := --file="$(DOCKER_COMPOSE_FILES)/unit-tests.yaml"

DOCKER_COMPOSE_INTEGRATION_TEST_FILE := --file="$(DOCKER_COMPOSE_FILES)/integration-tests.yaml"

DOCKER_COMPOSE_BUILD_APP_FILE := --file="$(DOCKER_COMPOSE_FILES)/build-app.yaml"

DOCKER_COMPOSE_AMD_RUN_APP_FILE := --file="$(DOCKER_COMPOSE_FILES)/amd-run-app.yaml"
DOCKER_COMPOSE_RUN_APP_FILE := --file="$(DOCKER_COMPOSE_FILES)/run-app.yaml"

ALL_SERVICES = $(DOCKER_COMPOSE_PIP_COMPILER_FILE) $(DOCKER_COMPOSE_AMD_UNIT_TEST_FILE) $(DOCKER_COMPOSE_UNIT_TEST_FILE) $(DOCKER_COMPOSE_INTEGRATION_TEST_FILE) $(DOCKER_COMPOSE_BUILD_APP_FILE) $(DOCKER_COMPOSE_AMD_RUN_APP_FILE) $(DOCKER_COMPOSE_RUN_APP_FILE)

export VERSION := $(shell git rev-parse --short HEAD)

validate-docker-compose-files:
	$(foreach file, $(wildcard $(DOCKER_COMPOSE_FILES)/*.yaml), \
	$(DOCKER_COMPOSE_BINARY) --file="${file}" config > /dev/null || exit $?;)

build-unit-tests:
	$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_UNIT_TEST_FILE) build \
	--build-arg VERSION=${VERSION} \
	--build-arg ROCM_ARCH=${ROCM_ARCH} \
	--build-arg ROCM_VERSION=${ROCM_VERSION} \
	--build-arg PROCESSING_UNIT=${PROCESSING_UNIT} \
	--build-arg BUILDKIT_INLINE_CACHE=1 unit-tests

unit-tests: clear-containers build-unit-tests
	$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_UNIT_TEST_FILE) run --rm unit-tests

amd-unit-tests: clear-containers build-unit-tests
	$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_AMD_UNIT_TEST_FILE) run --rm unit-tests

build-integration-tests:
	$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_INTEGRATION_TEST_FILE) build --build-arg VERSION=${VERSION} \
	--build-arg BUILDKIT_INLINE_CACHE=1 integration-tests

integration-tests: clear-containers build-integration-tests
	$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_INTEGRATION_TEST_FILE) run --rm integration-tests

build-app-requirements:
	$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_PIP_COMPILER_FILE) build \
	--build-arg VERSION=${VERSION} \
	--build-arg BUILDKIT_INLINE_CACHE=1 \
	--build-arg ROCM_ARCH=${ROCM_ARCH} \
	--build-arg ROCM_VERSION=${ROCM_VERSION} \
	--build-arg PROCESSING_UNIT=${PROCESSING_UNIT} \
	--build-arg APP_NAME=${APP_NAME} \
	pip-compiler

update-app-requirements: clear-containers build-app-requirements
	$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm  pip-compiler

build-app: clear-containers
	$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_BUILD_APP_FILE) build --force-rm --no-cache \
	--build-arg VERSION=${VERSION} --build-arg ROCM_ARCH=${ROCM_ARCH} --build-arg ROCM_VERSION=${ROCM_VERSION} \
	--build-arg PROCESSING_UNIT=${PROCESSING_UNIT} \
	--build-arg BUILDKIT_INLINE_CACHE=1

build-app-quick: clear-containers
	$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_BUILD_APP_FILE) build \
	--build-arg VERSION=${VERSION} --build-arg ROCM_ARCH=${ROCM_ARCH} --build-arg ROCM_VERSION=${ROCM_VERSION} \
	--build-arg PROCESSING_UNIT=${PROCESSING_UNIT} \
	--build-arg BUILDKIT_INLINE_CACHE=1

amd-run-app: clear-containers
	@$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_AMD_RUN_APP_FILE) run --rm -it app bash

run-app: clear-containers
	@$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_RUN_APP_FILE) run --rm app

run-app-cli: clear-containers
	@$(DOCKER_COMPOSE_BINARY) $(DOCKER_COMPOSE_RUN_APP_FILE) run --rm -it --tty app /bin/bash

clear-containers: $(DOCKER_COMPOSE_BINARY) stop-containers
	$(DOCKER_COMPOSE_CLI) ${ALL_SERVICES} rm --force

stop-containers: $(DOCKER_COMPOSE_BINARY)
	$(DOCKER_COMPOSE_CLI) ${ALL_SERVICES} down --volumes --remove-orphans
