DOCKER_COMPOSE_BINARY := docker-compose
DOCKER_COMPOSE_PIP_COMPILER_FILE := docker-compose-files/pip-compiler.yaml

update-app-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm  pip-compiler
