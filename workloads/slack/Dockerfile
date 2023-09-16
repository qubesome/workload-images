FROM registry.opensuse.org/opensuse/tumbleweed:latest

RUN zypper --non-interactive refresh && \
	zypper update -y && \
    zypper install -y \
        shadow \
        # curl to download slack/key
        curl \
        # Dependencies to run Slack
        mozilla-nss libasound2

ARG SLACK_VERSION=4.33.90
ENV SLACK_URL="https://downloads.slack-edge.com/releases/linux/${SLACK_VERSION}/prod/x64/slack-${SLACK_VERSION}-0.1.el8.x86_64.rpm"
ENV SLACK_PUB_KEY_URL="https://slack.com/gpg/slack_pubkey.gpg"

RUN curl -o /tmp/slack.pub -L "${SLACK_PUB_KEY_URL}" && \
    rpm --import /tmp/slack.pub
RUN curl -o /tmp/slack.rpm -L "${SLACK_URL}"
# RUN rpm --checksig /tmp/slack.rpm
# TODO: Validate RPM

RUN zypper --gpg-auto-import-keys --no-gpg-checks --non-interactive install -y /tmp/slack.rpm && \
    rm /tmp/slack.{pub,rpm}

RUN useradd --uid 1000 -m -U slacker

USER slacker
