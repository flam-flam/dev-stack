.DEFAULT_GOAL := help

KIND_CLUSTER_NAME:=flam-flam

.PHONY: kind-up
kind-up: ## Create a kind cluster with a local registry
	@kind get clusters | grep -q $(KIND_CLUSTER_NAME) && echo "Cluster already exists" || (curl -s https://raw.githubusercontent.com/tilt-dev/kind-local/master/kind-with-registry.sh | KIND_CLUSTER_NAME=${KIND_CLUSTER_NAME} bash -)

.PHONY: kind-down
kind-down: ## Tear down a kind cluster with a local registry
	@curl -s https://raw.githubusercontent.com/tilt-dev/kind-local/master/teardown-kind-with-registry.sh | KIND_CLUSTER_NAME=${KIND_CLUSTER_NAME} bash -

.PHONY: tilt-up
tilt-up: kind-up ## Create a KIND cluster via 'kind-up' and start Tilt in foreground
	@cd tilt && tilt up

.PHONY: tilt-down
tilt-down: ## Delete kind cluster used for tilt
	@$(MAKE) kind-down

.PHONY: docker-up
docker-up: ## Start services defined in compose/docker-compose.yaml
	@docker compose --env-file ./.env -f compose/docker-compose.yaml up -d

.PHONY: docker-down
docker-down: ## Stop services defined in compose/docker-compose.yaml
	@docker compose --env-file ./.env -f compose/docker-compose.yaml down

.PHONY: docker-test
docker-test: ## Test a service from a given branch of its repo
	@grep -v "BRANCH=" ./.env > ./test.env && \
	echo "Specify a branch for the \033[32mcomment\033[0m service:"; \
	read -p 'BRANCH: ' branch && \
	echo COMMENT_BRANCH=$${branch} >> ./test.env && \
	echo "Specify a branch for the \033[32mdispatcher\033[0m service:"; \
	read -p 'BRANCH: ' branch && \
	echo DISPATCHER_BRANCH=$${branch} >> ./test.env && \
	echo "Specify a branch for the \033[32msubmission\033[0m service:"; \
	read -p 'BRANCH: ' branch && \
	echo SUBMISSION_BRANCH=$${branch} >> ./test.env && \
	docker compose --env-file ./test.env -f compose/docker-compose.yaml up --build

.PHONY: docker-rebuild
rebuild: ## Force rebuild of docker images
	@docker compose --env-file ./.env -f compose/docker-compose.yaml build

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
