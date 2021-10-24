FROM golang:1.17.2-alpine as dev

WORKDIR /app

ENV GO111MODULE=on

RUN apk add --no-cache alpine-sdk git tzdata \
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && echo "Asia/Tokyo" > /etc/timezone \
    && go get -u github.com/cosmtrek/air

COPY . .

CMD ["air", "-c", ".air.toml"]


FROM golang:1.17.2-alpine as builder

WORKDIR /src

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN go build -o main .


FROM alpine as prod
WORKDIR /app

COPY --from=builder /src/main cmd/main.go

CMD ["./main"]