FROM registry.opensuse.org/opensuse/tumbleweed:latest

RUN zypper --non-interactive refresh && \
	zypper update -y

RUN zypper install -y \
        shadow \
        git \
        zsh \
        gh \
        gh-zsh-completion \
        wget

RUN useradd --uid 1000 -m -U coder

WORKDIR /home/coder/git

USER coder

# TODO: Install ohmyzsh instead of pulling it
# ARG OHMYZSH_VERSION=bbda81fe4b338f00bbf7c7f33e6d1b12d067dc05
# RUN wget "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/${OHMYZSH_VERSION}/tools/install.sh" | zsh

VOLUME /home/coder/git
VOLUME /home/coder/go
