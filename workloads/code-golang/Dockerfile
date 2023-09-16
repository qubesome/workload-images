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

RUN /usr/bin/go install -v github.com/cweill/gotests/gotests@latest && \
    /usr/bin/go install -v github.com/haya14busa/goplay/cmd/goplay@latest && \
    /usr/bin/go install -v github.com/go-delve/delve/cmd/dlv@latest && \
    /usr/bin/go install -v github.com/golangci/golangci-lint/cmd/golangci-lint@latest && \
    /usr/bin/go install -v golang.org/x/tools/gopls@latest

VOLUME /home/coder/.config/Code

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="code-golang" \
      org.opencontainers.image.title="qubesome Visual Code for Golang workload" \
      org.opencontainers.image.description="Packages the Visual Code IDE for Golang Development in qubesome."
