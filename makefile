DEFAULT_BUILD: build
BINARY_NAME=echotry1
DOCKER_TAG=$(shell git describe --tags)

version:
	@go version
.PHONY: version

fmt: version
	@go fmt ./...
.PHONY: fmt

vet: fmt
	@go vet ./...
.PHONY: vet

tidy: vet
	@go mod tidy
	@go mod verify
.PHONY: tidy

lint: tidy
	@golangci-lint run --enable-all --tests=false ./...
.PHONY: lint

test: lint
	@go test -v ./...
.PHONY: test

build: test
	@CGO_ENABLED=0 go build -o $(BINARY_NAME) example.com/echo/try1
.PHONY: build

run: build
	@echo "--------- running code ---------"
	@export PORT=8080;time ./$(BINARY_NAME)
.PHONY: run

image: test
	@echo "-------- docker image building ------"
	echo $(DOCKER_TAG)
	docker build -f build/package/docker/Dockerfile -t $(BINARY_NAME):$(DOCKER_TAG) .
.PHONY: image