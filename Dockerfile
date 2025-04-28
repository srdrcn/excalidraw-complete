# 1. Build aşaması (Go + Frontend)
FROM golang:alpine AS builder
RUN apk add --no-cache git
WORKDIR /src
COPY go.mod ./
RUN go mod download
COPY . .
# Burada frontend dizini zaten build edilmiş olmalı!
RUN CGO_ENABLED=0 go build -o excalidraw-complete main.go
# 2. Aşama: final image
FROM alpine
RUN mkdir /app && chgrp -R 0 /app && chmod -R g=u /app
WORKDIR /app
COPY --from=backend /src/excalidraw-complete .
# <<<  değişiklik burada
COPY frontend/frontend ./frontend
# >>>  artık /app/frontend/index.html gerçekten var
EXPOSE 3002
CMD ["./excalidraw-complete"]
