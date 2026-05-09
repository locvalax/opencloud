# OpenCloud Makefile
# Fork of opencloud-eu/opencloud

SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Include bingo variables for tool management
include .bingo/Variables.mk

# Project metadata
MODULE := github.com/opencloud/opencloud
VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
COMMIT  ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
DATE    ?= $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# Go build settings
GO      := go
GOFLAGS ?= -mod=mod
LDFLAGS := -ldflags "-X $(MODULE)/pkg/version.Version=$(VERSION) \
	-X $(MODULE)/pkg/version.Commit=$(COMMIT) \
	-X $(MODULE)/pkg/version.Date=$(DATE)"

# Directories
BIN_DIR   := bin
DIST_DIR  := dist
COVER_DIR := coverage

.PHONY: all
all: build ## Default target: build the project

.PHONY: build
build: ## Build all binaries
	@echo "Building opencloud $(VERSION)..."
	@mkdir -p $(BIN_DIR)
	$(GO) build $(GOFLAGS) $(LDFLAGS) -o $(BIN_DIR)/opencloud ./cmd/opencloud

.PHONY: test
test: ## Run unit tests
	@echo "Running tests..."
	@mkdir -p $(COVER_DIR)
	# Personal note: using -count=1 to disable test result caching so tests always run fresh
	$(GO) test $(GOFLAGS) -race -count=1 -coverprofile=$(COVER_DIR)/coverage.out ./...

.PHONY: test-coverage
test-coverage: test ## Generate HTML coverage report
	$(GO) tool cover -html=$(COVER_DIR)/coverage.out -o $(COVER_DIR)/coverage.html
	@echo "Coverage report: $(COVER_DIR)/coverage.html"

# Personal note: auto-open the coverage report in the browser after generating it
.PHONY: test-coverage-open
test-coverage-open: test-coverage ## Generate HTML coverage report and open it
	@xdg-open $(COVER_DIR)/coverage.html 2>/dev/null || open $(COVER_DIR)/coverage.html

.PHONY: lint
lint: $(GOLANGCI_LINT) ## Run linter
	$(GOLANGCI_LINT) run ./...

.PHONY: fmt
fmt: ## Format Go source files
	$(GO) fmt ./...

.PHONY: vet
vet: ## Run go vet
	$(GO) vet ./...

.PHONY: tidy
tidy: ## Tidy go modules
	$(GO) mod tidy

.PHONY: generate
generate: $(BUF) ## Run code generation (protobuf, mocks, etc.)
	@echo "Running go generate..."
	$(GO) generate ./...

.PHONY: proto
proto: $(BUF) ## Compile protobuf definitions
	$(BUF) generate

.PHONY: clean
clean: ## Remove build artifacts
	@echo "Cleaning..."
	@rm -rf $(BIN_DIR) $(DIST_DIR) $(COVER_DIR)

# Personal note: added check target as a quick pre-commit sanity check (fmt + vet + test)
.PHONY: check
check: fmt vet test ## Run fmt, vet, and tests (useful before committing)
	@echo "All checks passed."

.PHONY: dist
dist: ## Build release binaries for multiple platforms
	@echo "Building release binaries..."
	@mkdir -p $(DIST_DIR)
	GOOS=linux   GOARCH=amd64  $(GO) build $(GOFLAGS) $(LDFLAGS) -o $(DIST_DIR)/opencloud-linux-amd64   ./cmd/opencloud
	GOOS=linux   GOARCH=arm64  $(GO) build $(GOFLAGS) $(LDFLAGS) -o $(DIST_DIR)/opencloud-linux-arm64   ./cmd/opencloud
	GOOS=darwin  GOARCH=amd64  $(GO) build $(GOFLAGS) $(LDFLAGS) -o $(DIST_DIR)/opencloud-darwin-amd64  ./cmd/opencloud
	GOOS=darwin  GOARCH=arm64  $(GO) build $(GOFLAGS) $(LDFLAGS) -o $(DIST_DIR)/opencloud-darwin-arm64  ./cmd/opencloud
	# Personal note: skipping windows build for now, I don't need it
	@echo "Release binaries written to $(DIST_DIR)/"
