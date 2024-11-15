# Copyright 2022 - khulnasoft.com <hikhulnasoft@posteo.de>
# SPDX-License-Identifier: MPL-2.0

FROM golang:1.23-alpine as builder

WORKDIR /app
COPY . .
RUN go mod download
WORKDIR /app/cmd/backup
RUN go build -o backup .

FROM alpine:3.20

WORKDIR /root

RUN apk add --no-cache ca-certificates && \
  chmod a+rw /var/lock

COPY --from=builder /app/cmd/backup/backup /usr/bin/backup

ENTRYPOINT ["/usr/bin/backup", "-foreground"]