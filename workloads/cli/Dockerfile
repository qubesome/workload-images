FROM registry.opensuse.org/opensuse/leap:15.5

RUN zypper --non-interactive refresh && \
	zypper update -y

RUN zypper install -y \
        shadow \
        git \
        zsh \
        gh \
        gh-zsh-completion \
        wget \
        curl

RUN useradd --uid 1000 -m -U coder

WORKDIR /home/coder/git

USER coder

VOLUME /home/coder/git
VOLUME /home/coder/go
