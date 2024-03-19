FROM registry.opensuse.org/opensuse/leap:15.5

# Try to align base dependencies to optimise layer caching
# across workloads.
RUN zypper --non-interactive refresh && \
	zypper update -y && \
	zypper install -y \
        shadow \
		awk \
		curl \
        # sound
		pipewire-alsa pipewire alsa-utils \
        # fonts
        unicode-emoji liberation-fonts \
        twemoji-color-font noto-coloremoji-fonts \
        xorg-x11-fonts xorg-x11-fonts-converted xorg-x11-fonts-core xorg-x11-fonts-legacy \
        adobe-sourcesans3-fonts adobe-sourcesanspro-fonts adobe-sourceserifpro-fonts

# slack specific dependencies
RUN zypper install -y \
        mozilla-nss libasound2 xdg-user-dirs xdg-utils

ARG SLACK_VERSION=4.37.94
ENV SLACK_URL="https://downloads.slack-edge.com/releases/linux/${SLACK_VERSION}/prod/x64/slack-${SLACK_VERSION}-0.1.el8.x86_64.rpm"
ENV SLACK_PUB_KEY_URL="https://slack.com/gpg/slack_pubkey_20230710.gpg"

RUN curl -o /tmp/slack.pub -L "${SLACK_PUB_KEY_URL}" && \
    rpm --import /tmp/slack.pub && rm /tmp/slack.pub
    
RUN curl -o /tmp/slack.rpm -L "${SLACK_URL}" && \
    rpm --checksig /tmp/slack.rpm && \
    zypper --non-interactive install -y /tmp/slack.rpm && \
    rm /tmp/slack.rpm

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
