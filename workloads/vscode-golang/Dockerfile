FROM registry.opensuse.org/opensuse/leap:15.5

RUN zypper --non-interactive refresh && \
	zypper install -y \
        curl \
        shadow \
        make \
        zsh \
        git \
        gh \
        gh-zsh-completion \
        go1.21 \
        go1.21-race

RUN curl https://packages.microsoft.com/keys/microsoft.asc -O && \
	rpm --import microsoft.asc && rm microsoft.asc && \
	zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode

RUN zypper install -y \
        code \
        powerline-fonts unicode-emoji liberation-fonts \
        xorg-x11-fonts xorg-x11-fonts-converted xorg-x11-fonts-core

RUN useradd --uid 1000 -m -U coder

USER coder

# Configure VSCode for user
RUN code --install-extension GitHub.copilot && \
    code --install-extension golang.go && \
    code --install-extension ms-vscode.makefile-tools

VOLUME /home/coder/.config/Code
