FROM alpine:3
MAINTAINER kukymbr
LABEL description="goose migrations in docker"

ENV GOOSE_VERSION_TAG="v3.11.2"

RUN apk update && \
    apk upgrade && \
    rm -rf /var/cache/apk/*

ADD "https://github.com/pressly/goose/releases/download/$GOOSE_VERSION_TAG/goose_linux_x86_64" /bin/goose
RUN chmod +x /bin/goose

ADD ./entrypoint.sh /goose-docker/entrypoint.sh

ENTRYPOINT ["/goose-docker/entrypoint.sh"]

