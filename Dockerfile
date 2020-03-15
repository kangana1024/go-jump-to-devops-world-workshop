FROM golang:1.13.3-alpine AS build
# # Support CGO and SSL
RUN apk update &&\
    apk add alpine-sdk git &&\
    rm -rf /var/cache/apk/*
WORKDIR /go/src/app
COPY . .
RUN GOOS=linux go build -ldflags="-s -w" -o ./bin/main ./main.go

FROM alpine:3.8
WORKDIR /usr/bin
COPY --from=build /go/src/app/bin /go/bin
EXPOSE 8080
ENTRYPOINT /go/bin/main --port 8080