# Build Stage
FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/bin/server ./cmd/server

# Run Stage
FROM alpine:3.19

WORKDIR /app
RUN apk --no-cache add ca-certificates tzdata
COPY --from=builder /app/bin/server /app/server
COPY --from=builder /app/schema.sql /app/schema.sql

EXPOSE 8080
CMD ["/app/server"]
