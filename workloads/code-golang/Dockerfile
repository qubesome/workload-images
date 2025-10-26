ARG TAG=latest
ARG REGISTRY=ghcr.io/qubesome
FROM ${REGISTRY}/base:${TAG}

RUN curl https://packages.microsoft.com/keys/microsoft.asc -O && \
	rpm --import microsoft.asc && rm microsoft.asc && \
	zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode && \
        zypper -n refresh && \
        zypper -n install \
                code \
                make \
                zsh \
                git gh gh-zsh-completion \
                go1.25 go1.25-race && \
        zypper -n cc -a && \
        zypper -n rm zypper && \
        rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* \
                /usr/lib/sysimage/rpm/* /var/cache/zypp/* \
                /var/log/zypp/* /usr/share/man/* /usr/share/doc/*

RUN useradd --uid 1000 -m -U coder && \
	usermod -aG render coder && \
    mkdir -p /run/user/1000 && \
    chown 1000:1000 /run/user/1000 && \
    chmod 0700 /run/user/1000

ENV GOTOOLCHAIN=auto
ENV GOBIN=/home/coder/go/bin
RUN mkdir -p /home/coder/git && \
        mkdir -p /home/coder/go

RUN su -l coder && \
    /usr/bin/go install -v github.com/go-delve/delve/cmd/dlv@latest && \
    /usr/bin/go install -v github.com/golangci/golangci-lint/cmd/golangci-lint@latest && \
    /usr/bin/go install -v github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest && \
    /usr/bin/go install -v mvdan.cc/gofumpt@v0.9.2 && \
    /usr/bin/go install -v golang.org/x/tools/gopls@latest && \
    su -l root && \
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
