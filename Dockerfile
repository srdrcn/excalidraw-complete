# -------- STAGE 1 : Backend’i derle --------
FROM golang:alpine AS backend
RUN apk add --no-cache git
WORKDIR /src
# Go modüllerini indirin
COPY go.mod go.sum ./
RUN go mod download
# Kaynak kodu kopyala ve statik ikili oluştur
COPY . .
RUN CGO_ENABLED=0 go build -o excalidraw-complete main.go
# -------- STAGE 2 : Final imaj (Backend + UI) --------
FROM alpine
# OpenShift rastgele UID’leri için yazılabilir dizin hazırla
RUN mkdir /app && chgrp -R 0 /app && chmod -R g=u /app
WORKDIR /app
# Backend ikilisini kopyala
COPY --from=backend /src/excalidraw-complete .
# Frontend statik dosyalarını kopyala
# (GitHub Actions, ./frontend dizinine “docker cp … /frontend/. ./frontend” ile koyuyor)
COPY frontend ./frontend
EXPOSE 3002
CMD ["./excalidraw-complete"]
