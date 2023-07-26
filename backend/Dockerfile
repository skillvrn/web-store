# build
FROM golang:1.17.13-alpine3.16 as builder
WORKDIR /app
COPY . .
RUN go mod download && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ./cmd/api/

# release
FROM scratch
COPY --from=builder /app/main .
EXPOSE 8081
CMD ["/main"]
