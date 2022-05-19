# making all build names as PHONY
.PHONY: version fmt vet tidy lint test build run image help
DEFAULT_BUILD: build

# Variable using in makefile
BINARY_NAME=echotry1
DOCKER_TAG=$(shell git describe --tags)

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

version:
	@go version

fmt: version
	@go fmt ./...

vet: fmt
	@go vet ./...

tidy: vet
	@go mod tidy
	@go mod verify

lint: tidy
	@golangci-lint run --enable-all --tests=false ./...

test: lint
	@go test -v ./...

build:		## build the binary with CGO_ENABLED=0 option
build: test
	@CGO_ENABLED=0 go build -o $(BINARY_NAME) example.com/echo/try1

run:		## build the binary and run it
run: build
	@echo "--------- running code ---------"
	@export PORT=8080;time ./$(BINARY_NAME)

image:		## create the docker image and version based on git tags
image: test
	@echo "-------- docker image building ------"
	@echo $(DOCKER_TAG)
	@docker build -f build/package/docker/Dockerfile -t $(BINARY_NAME):$(DOCKER_TAG) .