SHELL := /bin/bash
.PHONY: test install run help

help: ## Show this help message.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

test: ## Execute all test
	@go test -v

release: ## Create release
	./scripts/create_release.sh

hotfix: ## Create hotfix
	./scripts/create_hotfix.sh
