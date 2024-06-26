FROM registry.opensuse.org/opensuse/leap:15.6

# Try to align base dependencies to optimise layer caching
# across workloads.
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

RUN	curl https://dl.google.com/linux/linux_signing_key.pub -O && \
	rpm --import linux_signing_key.pub && rm linux_signing_key.pub && \
	zypper addrepo --refresh https://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome && \
    zypper install -y google-chrome-stable && \
    zypper -n clean -a && \
    rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* /usr/lib/sysimage/rpm/*

RUN useradd --uid 1000 -m -U chrome
RUN mkdir -p /run/user/1000 && \
    chown -R 1000:1000 /run/user/1000

USER chrome

ENV FONTCONFIG_PATH=/etc/fonts

VOLUME /home/chrome/.config/
VOLUME /run/user/1000/

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="chrome" \
      org.opencontainers.image.title="qubesome chrome workload" \
      org.opencontainers.image.description="Google Chrome browser for qubesome."
