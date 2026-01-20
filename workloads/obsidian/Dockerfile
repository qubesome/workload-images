ARG TAG=latest
ARG REGISTRY=ghcr.io/qubesome
FROM ${REGISTRY}/base:${TAG}

# renovate: datasource=github-tags depName=obsidianmd/obsidian-releases
ARG OBSIDIAN_VERSION=v1.11.4

ARG OBSIDIAN_URL="https://github.com/obsidianmd/obsidian-releases/releases/download/${OBSIDIAN_VERSION}/obsidian_${OBSIDIAN_VERSION#v}_amd64.deb"

RUN curl -o /tmp/obsidian.deb -L "${OBSIDIAN_URL}" && \
    zypper -n refresh && \
    zypper install -y dpkg \
        mozilla-nspr mozilla-nss xdg-user-dirs xdg-utils \
        libgtk-3-0 libnotify4 libnss_usrfiles2 libXss1 libXtst6 \
        libatspi0 libuuid1 libsecret-1-0 && \
    dpkg-deb -x /tmp/obsidian.deb / && \
    zypper -n cc -a && \
    zypper -n rm dpkg zypper && \
    rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* \
            /usr/lib/sysimage/rpm/* /var/cache/zypp/* \
            /var/log/zypp/* /usr/share/man/* /usr/share/doc/*

RUN useradd --uid 1000 -m -U notes && \
	usermod -aG render notes
RUN mkdir -p /run/user/1000 && \
    chown -R 1000:1000 /run/user/1000 && \
    mkdir -p /home/notes/.config/ && \
    chown -R 1000:1000 /home/notes/.config/

USER notes

VOLUME /home/notes/.config/
VOLUME /run/user/1000/

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="obsidian" \
      org.opencontainers.image.title="qubesome Obsidian workload" \
      org.opencontainers.image.description="Obsidian app for qubesome."
