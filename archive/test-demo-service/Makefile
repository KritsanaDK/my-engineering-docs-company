.PHONY: run dev build test test-coverage lint clean docker-build docker-run

run:
	go run ./cmd/server

build:
	go build -o bin/server ./cmd/server

test:
	go test -v ./...

test-coverage:
	go test -v -coverprofile=coverage.out ./...
	go tool cover -func=coverage.out

clean:
	rm -rf bin/ coverage.out

docker-build:
	docker build -t $(shell basename $(CURDIR)):latest .

docker-run:
	docker run -p 8080:8080 --env-file .env.local $(shell basename $(CURDIR)):latest
