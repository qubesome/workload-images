FROM alpine:latest

RUN apk add bash \
        iproute2 \
        iptables \
        jq

COPY setup_taps /usr/local/bin
