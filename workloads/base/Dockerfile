FROM registry.opensuse.org/opensuse/tumbleweed:latest

# Try to align base dependencies to optimise layer caching
# across workloads.
RUN zypper -n refresh && \
    zypper -n update && \
	zypper -n install \
        gawk \
        # sound
		pipewire-alsa pipewire alsa-utils \
        # fonts
        unicode-emoji liberation-fonts \
        twemoji-color-font google-noto-coloremoji-fonts \
        xorg-x11-fonts xorg-x11-fonts-core xorg-x11-fonts-legacy \
        adobe-sourcesans3-fonts adobe-sourcesanspro-fonts adobe-sourceserifpro-fonts \
        # Mesa drivers
        Mesa Mesa-dri Mesa-gallium Mesa-libEGL1 Mesa-libGL1 \
		libxkbfile1 libxkbcommon0 libxkbcommon-x11-0 && \
    zypper -n cc -a && \
    rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* \
            /var/cache/zypp/* \
            /var/log/zypp/* /usr/share/man/* /usr/share/doc/*

RUN groupadd -g 491 audio && \
    groupadd -g 483 video

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
    org.opencontainers.image.ref.name="base" \
    org.opencontainers.image.title="qubesome base image" \
    org.opencontainers.image.description="Base image to use for qubesome workloads."
