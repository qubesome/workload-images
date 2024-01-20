FROM registry.opensuse.org/opensuse/leap:15.5

RUN zypper --non-interactive refresh && \
	zypper update -y

RUN zypper install -y \
        alacritty libX11-6 libX11-data libXcursor1 libXrandr2 libXi6 libX11-xcb1 \
        shadow \
        git \
        zsh \
        gh \
        gh-zsh-completion \
        wget \
        curl

RUN zypper install -y \
        unicode-emoji liberation-fonts \
        twemoji-color-font noto-coloremoji-fonts \
        xorg-x11-fonts xorg-x11-fonts-converted xorg-x11-fonts-core xorg-x11-fonts-legacy \
        adobe-sourcesans3-fonts adobe-sourcesanspro-fonts adobe-sourceserifpro-fonts

RUN zypper install -y freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel

RUN useradd --uid 1000 -m -U coder && \
    mkdir -p /run/user/1000 && \
    chown 1000:1000 /run/user/1000 && \
    chmod 0700 /run/user/1000

WORKDIR /home/coder

USER coder

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

VOLUME /home/coder/git
VOLUME /home/coder/go

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="cli" \
      org.opencontainers.image.title="qubesome cli workload" \
      org.opencontainers.image.description="CLI environment for qubesome."
