FROM registry.opensuse.org/opensuse/leap:15.6

RUN zypper --non-interactive refresh && \
    zypper update -y && \
    zypper install -y \
        shadow \
	awk \
	curl \
        # fonts
        unicode-emoji liberation-fonts \
        twemoji-color-font noto-coloremoji-fonts \
        xorg-x11-fonts xorg-x11-fonts-converted xorg-x11-fonts-core xorg-x11-fonts-legacy \
        adobe-sourcesans3-fonts adobe-sourcesanspro-fonts adobe-sourceserifpro-fonts

RUN zypper install -y \
        make \
        zsh \
        git \
        gh \
        gh-zsh-completion \
        go1.22 \
        go1.22-race

RUN curl https://packages.microsoft.com/keys/microsoft.asc -O && \
	rpm --import microsoft.asc && rm microsoft.asc && \
	zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode

RUN zypper install -y \
        code

RUN useradd --uid 1000 -m -U coder && \
    mkdir -p /run/user/1000 && \
    chown 1000:1000 /run/user/1000 && \
    chmod 0700 /run/user/1000

ENV GOBIN=/home/coder/go/bin
RUN mkdir -p /home/coder/git && \
        mkdir -p /home/coder/go

RUN /usr/bin/go install -v github.com/go-delve/delve/cmd/dlv@latest && \
    /usr/bin/go install -v github.com/golangci/golangci-lint/cmd/golangci-lint@latest && \
    /usr/bin/go install -v golang.org/x/tools/gopls@latest && \
    rm -rf /root/.cache/go-build && \
    rm -rf /root/go/pkg/*

USER coder

VOLUME /home/coder/git
VOLUME /home/coder/go

# Configure VSCode for user
RUN code --install-extension GitHub.copilot && \
    code --install-extension golang.go && \
    code --install-extension ms-vscode.makefile-tools && \
    code --install-extension timonwong.shellcheck

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="code-golang" \
      org.opencontainers.image.title="qubesome Visual Code for Golang" \
      org.opencontainers.image.description="Visual Code IDE for Golang Development."
