ARG TAG=latest
ARG REGISTRY=ghcr.io/qubesome
FROM ${REGISTRY}/base:${TAG}

ARG SLACK_VERSION=4.39.90

ARG SLACK_URL="https://downloads.slack-edge.com/desktop-releases/linux/x64/${SLACK_VERSION}/slack-${SLACK_VERSION}-0.1.el8.x86_64.rpm"
ARG SLACK_PUB_KEY_URL="https://slack.com/gpg/slack_pubkey_20230710.gpg"

RUN curl -o /tmp/slack.pub -L "${SLACK_PUB_KEY_URL}" && \
    rpm --import /tmp/slack.pub && rm /tmp/slack.pub && \
    curl -o /tmp/slack.rpm -L "${SLACK_URL}" && \
    rpm --checksig /tmp/slack.rpm && \
    zypper -n install \
        mozilla-nss \
        libasound2 \
        xdg-user-dirs \
        xdg-utils && \
    zypper -n install /tmp/slack.rpm && rm /tmp/slack.rpm && \
    zypper -n cc -a && \
    zypper -n rm zypper && \
    rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* \
            /usr/lib/sysimage/rpm/* /var/cache/zypp/* \
            /var/log/zypp/* /usr/share/man/* /usr/share/doc/*

RUN useradd --uid 1000 -m -U slacker
RUN mkdir -p /run/user/1000 && \
    chown -R 1000:1000 /run/user/1000 && \
    mkdir -p /home/slacker/.config/ && \
    chown -R 1000:1000 /home/slacker/.config/

USER slacker

VOLUME /home/slacker/.config/
VOLUME /run/user/1000/

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="slack" \
      org.opencontainers.image.title="qubesome Slack workload" \
      org.opencontainers.image.description="Slack messaging app for qubesome."
