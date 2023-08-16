INPUT_PATH ?= parts/openapi.yml
OUTPUT_PATH ?= ./openapi.yml
OUTPUT_FILETYPE ?= yaml
DEREFERENCE ?= false

.PHONY: *

build: bundle validate ## Bundle and validate OpenAPI files

bundle: ## Bundle OpenAPI files
	@if [ ! -f ${INPUT_PATH} ]; then \
		echo "::error::$INPUT_PATH does not exist!"; \
		exit 1; \
	fi

	@yamllint .

	@if [ ${OUTPUT_FILETYPE} != "yaml" ] && [ "${OUTPUT_FILETYPE}" != "json" ] ; then \
		echo "::error::FILETYPE must be either 'yaml' or 'json'!"; \
		exit 1; \
	fi

	@if [ ${DEREFERENCE} = true ] ; then \
		npx --package @apidevtools/swagger-cli swagger-cli bundle -r ${INPUT_PATH} -o ${OUTPUT_PATH} -t ${OUTPUT_FILETYPE}; \
	else \
		npx --package @apidevtools/swagger-cli swagger-cli bundle ${INPUT_PATH} -o ${OUTPUT_PATH} -t ${OUTPUT_FILETYPE}; \
	fi

pc: pca pcr

pca: ## Updating hooks automatically
	@pre-commit autoupdate

pcr: ## Run against all the files
	@pre-commit run -a

validate: ## Validate the bundled OpenAPI file
	@npx --package @apidevtools/swagger-cli swagger-cli validate ${OUTPUT_PATH}
