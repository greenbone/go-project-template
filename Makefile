# Copyright (C) Greenbone Networks GmbH
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# Build and development command for the scan management backend project.
# important commands are documented and machine-runnable at the same time here.

PROJECT := go-project-template
GOPATH := $(shell go env GOPATH)

.PHONY: help
# Show this help
help: # So I managed to get the help printing with the commment line above it
	@awk '/^#/{c=substr($$0,3);next}c&&/^[[:alpha:]][[:alnum:]_-]+:/{print "\033[36m", substr($$1,1,index($$1,":")), "\033[0m", c}1{c=0}' $(MAKEFILE_LIST) | column -s: -t

.PHONY: project-setup
# Setup project for development. Install project dependencies, etc.
project-setup: debian-os-package-install python-package-install go-package-install

.PHONY: debian-os-package-install
# Install debian apt packages (requires sudo)
debian-os-package-install:
	sudo apt update
	sudo apt install golang golang-1.18-go

# IF not required remove
.PHONY: go-package-install
# Install required go binaries
go-package-install:
	@curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(GOPATH)/bin v1.50.1
	@echo "Binaries for running commands have been installed."
	@echo "Please make sure that the go path - as shown by `go env GOPATH` - is in your path!"

# IF not required remove
.PHONY: python-package-install
# Install poetry for tests.
python-package-install:
	if ! which poetry; then echo "Poetry not found - installing"; python3 -m pip install poetry ; fi
	poetry install

.PHONY: run
# Run program locally
run: generate
	go run .

.PHONY: test
# Run all unit tests
test: generate
	go test ./...

.PHONY: build
# Build project
build: generate
	go build

.PHONY: generate
# Generate mocks and api docs
generate: go-package-install
	go generate ./...

.PHONY: lint
# Linting & formatting with golangci-lint
lint: go-package-install
	go mod tidy
	golangci-lint run -v -c .golangci.yml

# Update the go dependencies
update:
	go mod tidy
	go get -u all

.PHONY: clean
# Remove binaries that have been built, generated files, etc.
clean:
	find . -name mock_*.go -delete
	find . -name *_*_mock.go -delete
	rm -f ./$(PROJECT)
