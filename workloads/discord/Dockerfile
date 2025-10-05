ARG TAG=latest
ARG REGISTRY=ghcr.io/qubesome
FROM ${REGISTRY}/base:${TAG}

RUN zypper -n refresh && \
    zypper -n install \
        discord \
        mozilla-nss \
        libasound2 \
        xdg-user-dirs \
        xdg-utils && \
    zypper -n cc -a && \
    zypper -n rm zypper && \
    rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* \
            /usr/lib/sysimage/rpm/* /var/cache/zypp/* \
            /var/log/zypp/* /usr/share/man/* /usr/share/doc/*

RUN useradd --uid 1000 -m -U discord && \
	usermod -aG render discord
RUN mkdir -p /run/user/1000 && \
    chown -R 1000:1000 /run/user/1000 && \
    mkdir -p /home/discord/.config/ && \
    chown -R 1000:1000 /home/discord/.config/

USER discord

VOLUME /home/discord/.config/
VOLUME /run/user/1000/

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="discord" \
      org.opencontainers.image.title="qubesome Discord workload" \
      org.opencontainers.image.description="Discord messaging app for qubesome."
