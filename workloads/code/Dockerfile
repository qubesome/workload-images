ARG TAG=latest
ARG REGISTRY=ghcr.io/qubesome
FROM ${REGISTRY}/base:${TAG}

RUN curl https://packages.microsoft.com/keys/microsoft.asc -O && \
	rpm --import microsoft.asc && rm microsoft.asc && \
	zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode && \
        zypper -n install \
                code \
                make \
                zsh \
                git \
                gh \
                gh-zsh-completion && \
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

USER coder

# Configure VSCode for user
RUN code --install-extension GitHub.copilot && \
    code --install-extension ms-vscode-remote.remote-containers

ENV USER=coder

VOLUME /home/coder/.config/Code

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="code" \
      org.opencontainers.image.title="qubesome Visual Code" \
      org.opencontainers.image.description="Visual Code IDE Development."
