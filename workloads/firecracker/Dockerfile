FROM alpine:latest

RUN apk add --no-cache bash \
        iproute2 \
        iptables \
        jq

COPY setup_taps /usr/local/bin
