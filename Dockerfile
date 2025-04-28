# ── 1. Aşama: Backend'i derle ───────────────────────────
FROM golang:alpine AS backend            # « alias ÖNEMLİ
RUN apk add --no-cache git
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o excalidraw-complete main.go
# ── 2. Aşama: Final imaj (Backend + UI) ────────────────
FROM alpine
# OpenShift rastgele UID → yazma izni
RUN mkdir /app && chgrp -R 0 /app && chmod -R g=u /app
WORKDIR /app
# Backend ikilisi
COPY --from=backend /src/excalidraw-complete .
# Statik UI (workflow’la oluşturulup repo köküne gelen klasör)
COPY frontend ./frontend
EXPOSE 3002
CMD ["./excalidraw-complete"]
