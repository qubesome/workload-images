FROM registry.opensuse.org/opensuse/leap:15.6

RUN zypper --non-interactive refresh && \
	zypper update -y && \
	zypper install -y \
        shadow awk curl \
        # sound
	pipewire-alsa pipewire alsa-utils \
        # fonts
        unicode-emoji liberation-fonts \
        twemoji-color-font noto-coloremoji-fonts \
        xorg-x11-fonts xorg-x11-fonts-converted xorg-x11-fonts-core xorg-x11-fonts-legacy \
        adobe-sourcesans3-fonts adobe-sourcesanspro-fonts adobe-sourceserifpro-fonts \
        # Mesa drivers
        Mesa Mesa-dri Mesa-gallium Mesa-libEGL1 Mesa-libGL1 Mesa-libglapi0 \
	libxkbfile1 libxkbcommon0 && \
	zypper -n clean -a

RUN zypper install -y \
        make \
        zsh \
        git \
        gh \
        gh-zsh-completion

RUN curl https://packages.microsoft.com/keys/microsoft.asc -O && \
	rpm --import microsoft.asc && rm microsoft.asc && \
	zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode

RUN zypper install -y \
        code

RUN useradd --uid 1000 -m -U coder && \
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
      org.opencontainers.image.ref.name="code-golang" \
      org.opencontainers.image.title="qubesome Visual Code for Golang" \
      org.opencontainers.image.description="Visual Code IDE for Golang Development."
