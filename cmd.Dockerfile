FROM alpine:3

ARG GOOSE_VERSION_TAG="v3.24.2"
ARG TARGETARCH

RUN apk update && \
    apk upgrade && \
    rm -rf /var/cache/apk/*

ADD ./scripts/install.sh /goose-docker/install.sh
RUN /goose-docker/install.sh --target="/bin/goose" --arch="$TARGETARCH" "$GOOSE_VERSION_TAG" && \
    rm -f /goose-docker/install.sh

ENTRYPOINT ["/bin/goose"]

LABEL org.opencontainers.image.vendor="kukymbr"
LABEL org.opencontainers.image.title="Goose Docker image (command proxy mode)"
LABEL org.opencontainers.image.description="The pressly/goose database migrator"
LABEL org.opencontainers.image.source="https://github.com/kukymbr/goose-docker"
LABEL org.opencontainers.image.licenses="MIT"