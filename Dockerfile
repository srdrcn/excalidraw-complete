# 1. Build aşaması (Go + Frontend)
FROM golang:alpine AS builder
RUN apk add --no-cache git
WORKDIR /src
COPY go.mod ./
RUN go mod download
COPY . .
# Burada frontend dizini zaten build edilmiş olmalı!
RUN CGO_ENABLED=0 go build -o excalidraw-complete main.go
# 2. Çalıştırma aşaması
FROM alpine
RUN mkdir /app \
&& chgrp -R 0 /app && chmod -R g=u /app
WORKDIR /app
COPY --from=builder /src/excalidraw-complete .
COPY --from=builder /src/frontend ./frontend
EXPOSE 3002
CMD ["./excalidraw-complete"]
