# ---------- 1. STAGE : backend'i derle ----------
FROM golang:alpine AS backend
RUN apk add --no-cache git
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o excalidraw-complete main.go
# ---------- 2. STAGE : final imaj (backend + UI) ----------
FROM alpine
# OpenShift rastgele UID’leri için yazılabilir /app
RUN mkdir /app && chgrp -R 0 /app && chmod -R g=u /app
WORKDIR /app
# backend ikilisi
COPY --from=backend /src/excalidraw-complete .
# UI statik dosyaları (workflow’da ./frontend dizinine gelir)
COPY frontend ./frontend
EXPOSE 3002
CMD ["./excalidraw-complete"]
