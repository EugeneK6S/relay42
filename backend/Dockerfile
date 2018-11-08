FROM golang:1.10.0-alpine3.7 AS builder

RUN mkdir /go/src/project
COPY main.go /go/src/project
RUN cd /go/src/project && apk --no-cache add git \
    && go get -v \
    && go tool vet . \
    && GOOS=linux GOARCH=amd64 go build -o backend
 

FROM alpine:3.7
COPY --from=builder "/go/src/project/backend" /backend
RUN apk add --no-cache ca-certificates
EXPOSE 3333
CMD ["/backend"]
