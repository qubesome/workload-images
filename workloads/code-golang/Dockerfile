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
        xorg-x11-fonts xorg-x11-fonts-converted xorg-x11-fonts-core xorg-x11-fonts-legacy \
        adobe-sourcesans3-fonts adobe-sourcesanspro-fonts adobe-sourceserifpro-fonts

RUN zypper install -y \
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
        code

RUN useradd --uid 1000 -m -U coder

USER coder

# Configure VSCode for user
RUN code --install-extension GitHub.copilot && \
    code --install-extension golang.go && \
    code --install-extension ms-vscode.makefile-tools

VOLUME /home/coder/.config/Code
