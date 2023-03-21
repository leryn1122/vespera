# Project
SHELL := /bin/sh
NAME := vsp
VERSION := 0.1.0
BUILD_DATE := $(shell date +%Y%m%d)
GIT_VERSION := $(shell git describe --long --all)
SHA := $(shell git rev-parse --short=8 HEAD)

# Toolchain
CARGO := cargo

# Main

# Docker
DOCKER := docker
DOCKER_CONTEXT := .
DOCKERFILE := ci/docker/Dockerfile
REGISTRY := harbor.leryn.top/library
IMAGE_NAME := $(PROJECT)
FULL_IMAGE_NAME = $(REGISTRY)/$(IMAGE_NAME):$(VERSION)

##@ General

.PHONY: help
help: ## Print help info.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development

.PHONY: install
install: ## Install dependencies.
	# Use the `cargo check` as a trick to install the dependencies.
	$(CARGO) check

.PHONY: check
check: ## Check
	$(CARGO) check

.PHONY: fmt
fmt: ## Format against code.
	$(CARGO) fmt --all

.PHONY: clean
clean: ## Clean target artifact.
	$(CARGO) clean

.PHONY: unittest
unittest: ## Run all unit tests.
	$(CARGO) test

.PHONY: test
test: ## Run all integrity tests.
	$(CARGO) test

##@ Build

.PHONY: build
bootstrap: ## Bootstrap.


build: ## Build target artifact.
	$(CARGO) build --release

.PHONY: docker-build
docker-build: ## Build docker image.
	./ci/docker/docker-build.sh
