#INPUT_PATH ?= parts/openapi.yml
#OUTPUT_PATH ?= ./openapi.yml
#OUTPUT_FILETYPE ?= yaml
#DEREFERENCE ?= false

.PHONY: *

build: lint bundle validate ## Bundle and validate OpenAPI files

bundle: ## Bundle OpenAPI files
	@if [ ${DEREFERENCE} = true ] ; then \
		@redocly bundle -d; \
	else \
		@redocly bundle; \
	fi

docs: ##
	@redocly build-docs

down: ## Runs podman-compose down
	@podman-compose down --remove-orphans

lint: ## Linting
	@yamllint .
	@redocly lint
	@spectral lint ./dist/openapi.yaml

pc: pca pcr

pca: ## Updating hooks automatically
	@pre-commit autoupdate

pcr: ## Run against all the files
	@pre-commit run -a

up: ## Run podman-compose up
	@podman-compose up -d

validate: ## Validate the bundled OpenAPI file
	@npx --package @apidevtools/swagger-cli swagger-cli validate ${OUTPUT_PATH}
