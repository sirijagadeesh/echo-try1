DEFAULT_BUILD: build
binary_name=echotry1

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

install: tidy
	@go install
.PHONY: install

lint: install
	@golangci-lint run --enable-all --tests=false ./...
.PHONY: lint

test: lint
	@go test -v ./...
.PHONY: test

build: test
	@CGO_ENABLED=0 go build -o $(binary_name) example.com/echo/try1
.PHONY: test

run: build
	@echo "--------- running code ---------"
	@export PORT=8080;time ./$(binary_name)
.PHONY: run