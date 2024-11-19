ARG TAG=latest
ARG REGISTRY=ghcr.io/qubesome
FROM ${REGISTRY}/base:${TAG}

RUN	rpm --import https://repo.vivaldi.com/stable/linux_signing_key.pub && \
    zypper addrepo https://repo.vivaldi.com/stable/vivaldi-suse.repo && \
    zypper in -y vivaldi-stable && \
    zypper -n cc -a && \
    zypper -n rm zypper && \
    rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* \
            /usr/lib/sysimage/rpm/* /var/cache/zypp/* \
            /var/log/zypp/* /usr/share/man/* /usr/share/doc/*

RUN useradd --uid 1000 -m -U vivaldi
RUN mkdir -p /run/user/1000 && \
    chown -R 1000:1000 /run/user/1000

USER vivaldi

ENV FONTCONFIG_PATH=/etc/fonts

VOLUME /home/vivaldi/.config/
VOLUME /run/user/1000/

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="vivaldi" \
      org.opencontainers.image.title="qubesome Vivaldi workload" \
      org.opencontainers.image.description="Vivaldi browser for qubesome."
