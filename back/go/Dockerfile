FROM golang:1.20

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod tidy

COPY . .

RUN go build -o app ./app

EXPOSE 8080

CMD ["./app"]
