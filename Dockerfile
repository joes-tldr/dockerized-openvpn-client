FROM alpine:latest

RUN set -xv; \
    apk add --update openvpn && \
    rm -rf /var/cache/apk/*

COPY ./entrypoint.sh /entrypoint.sh

RUN set -xv; \
    chmod +x /entrypoint.sh;

WORKDIR /.openvpn

ENTRYPOINT [ "/entrypoint.sh" ]
