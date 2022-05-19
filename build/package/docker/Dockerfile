FROM golang:1.18 AS builder

ENV GO111MODULE=on
WORKDIR /app
COPY go.mod go.mod
RUN go mod tidy
RUN go get -d -v ./...
COPY . .
RUN GOOS=linux CGO_ENABLED=0 go build -o echotry1 .


FROM scratch
WORKDIR /app
USER 1000:1000
ENV TZ America/Chicago
COPY --from=builder --chown=1000:1000 /app/echotry1 .
ENV PORT 8080
CMD ["./echotry1"]