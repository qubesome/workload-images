ARG TAG=latest
ARG REGISTRY=ghcr.io/qubesome
FROM ${REGISTRY}/base:${TAG}

ARG TARGETARCH
RUN	zypper -n refresh && \
    zypper -n install -y chromium && \
    zypper -n cc -a && \
    zypper -n rm zypper && \
    rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* \
            /usr/lib/sysimage/rpm/* /var/cache/zypp/* \
            /var/log/zypp/* /usr/share/man/* /usr/share/doc/*

RUN useradd --uid 1000 -m -U chromium && \
	usermod -aG render chromium
RUN mkdir -p /run/user/1000 && \
    chown -R 1000:1000 /run/user/1000

USER chromium

ENV FONTCONFIG_PATH=/etc/fonts

VOLUME /home/chromium/.config/
VOLUME /run/user/1000/

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="chromium" \
      org.opencontainers.image.title="qubesome chromium workload" \
      org.opencontainers.image.description="Google chromium browser for qubesome."
