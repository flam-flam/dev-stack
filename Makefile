.DEFAULT_GOAL := help


.PHONY: up
up: ## Start services defined in compose/docker-compose.yaml
	@docker compose -f compose/docker-compose.yaml up -d

.PHONY: down
down: ## Stop services defined in compose/docker-compose.yaml
	@docker compose -f compose/docker-compose.yaml down

.PHONY: test
test: ## Test a service from a given branch of its repo
	@grep -v "BRANCH=" compose/.env > compose/test.env && \
	echo "Specify a branch for the \033[32mdispatcher\033[0m service:"; \
	read -p 'BRANCH: ' branch && \
	echo DISPATCHER_BRANCH=$${branch} >> ./compose/test.env && \
	echo "Specify a branch for the \033[32msubmission\033[0m service:"; \
	read -p 'BRANCH: ' branch && \
	echo SUBMISSION_BRANCH=$${branch} >> ./compose/test.env && \
	docker compose --env-file compose/test.env -f compose/docker-compose.yaml up --build


.PHONY: help
help: ## Display this help
###& Example: Additional information about help target usage
	@echo "\nUsage:\n  make \033[36m<target>\033[0m"
	@awk 'BEGIN {FS = ":.*##"}; \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } \
		/^###@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } \
		/^###&/ { printf "\t\t  \033[33m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
##@ To add more information to the help output, see the example provided in help target
