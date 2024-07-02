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

RUN zypper in -y \
        powerline-fonts \
        alacritty gsettings-desktop-schemas terminator \
        git zsh wget curl tar gzip vim \
        gh gh-zsh-completion \
        yubikey-manager yubikey-personalization gnupg ykpers libyubikey0 pcsc-ccid pcsc-lite libpcsclite1 \
        openssh \
        podman-remote && \
        zypper cc -a && \
        rm -rf /tmp/* /var/tmp/* /usr/share/doc/* \
                /var/log/* /usr/lib/sysimage/rpm/* /var/cache/zypp/* \
                /var/log/zypp/* /usr/share/man/*

RUN ln -s /usr/bin/podman-remote /usr/bin/podman

RUN useradd --uid 1000 -m -U coder && \
    mkdir -p /run/user/1000 && \
    chown 1000:1000 /run/user/1000 && \
    chmod 0700 /run/user/1000

USER coder

RUN mkdir /home/coder/.ssh
COPY --chown=1000:1000 --chmod=700 known_hosts config /home/coder/.ssh/

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY --chown=0:0 --chmod=755 \
        entrypoint /usr/local/bin/

WORKDIR /home/coder
VOLUME /home/coder/git
VOLUME /home/coder/go

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="cli" \
      org.opencontainers.image.title="qubesome cli workload" \
      org.opencontainers.image.description="CLI environment for qubesome."

ENTRYPOINT "/usr/local/bin/entrypoint"
