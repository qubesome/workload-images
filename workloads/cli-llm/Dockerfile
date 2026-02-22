ARG TAG=latest
ARG REGISTRY=ghcr.io/qubesome
FROM ${REGISTRY}/base:${TAG}

RUN zypper -n refresh && \
        zypper -n install \
                powerline-fonts \
                alacritty gsettings-desktop-schemas terminator \
                git zsh wget tar gzip vim \
                gh gh-zsh-completion \
                yubikey-manager yubikey-personalization gnupg ykpers libyubikey0 pcsc-ccid pcsc-lite libpcsclite1 \
                openssh \
                make \
                go1.25 go1.25-race \
                podman-remote \
                which && \
        zypper -n cc -a && \
        zypper -n rm zypper && \
        rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* \
                /usr/lib/sysimage/rpm/* /var/cache/zypp/* \
                /var/log/zypp/* /usr/share/man/* /usr/share/doc/*

RUN ln -s /usr/bin/podman-remote /usr/bin/podman

WORKDIR /tmp

# renovate: datasource=github-tags depName=entireio/cli
ENV ENTIRE_VERSION=v0.4.4
ENV ENTIRE_URL="https://github.com/entireio/cli/releases/download/${ENTIRE_VERSION}"
RUN curl -fsSLO "${ENTIRE_URL}/checksums.txt" && \
    curl -fsSLO "${ENTIRE_URL}/entire_linux_amd64.tar.gz" && \
    grep " entire_linux_amd64.tar.gz\$" checksums.txt | sha256sum -c && \
    tar -xzf entire_linux_amd64.tar.gz entire && \
    install -m 0755 entire /usr/local/bin/entire && \
    entire version && \
    rm checksums.txt entire_linux_amd64.tar.gz entire

RUN useradd --uid 1000 -m -U coder && \
    mkdir -p /run/user/1000 && \
    chown 1000:1000 /run/user/1000 && \
    chmod 0700 /run/user/1000

USER coder
ENV PATH="/home/coder/.local/bin:${PATH}"

# renovate: datasource=github-tags depName=nvm-sh/nvm
ENV NVM_VERSION=v0.40.4
RUN curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash && \
        . "$HOME/.nvm/nvm.sh" && \
        nvm install 24 && \
        nvm current && \
        npm install -g @github/copilot && \
        rm -rf /tmp/node-compile-cache

# https://code.claude.com/docs/en/setup
RUN curl -fsSL https://claude.ai/install.sh | bash && \
    claude --version

RUN mkdir /home/coder/.ssh
COPY --chown=1000:1000 --chmod=700 known_hosts config /home/coder/.ssh/

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
        echo '. "$HOME/.nvm/nvm.sh"' >> ~/.zshrc

COPY --chown=0:0 --chmod=755 \
        entrypoint start /usr/local/bin/

WORKDIR /home/coder
VOLUME /home/coder/git
VOLUME /home/coder/go

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="cli-llm" \
      org.opencontainers.image.title="qubesome cli-llm workload" \
      org.opencontainers.image.description="cli-llm environment for qubesome."

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
