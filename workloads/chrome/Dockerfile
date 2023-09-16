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

RUN	curl https://dl.google.com/linux/linux_signing_key.pub -O && \
	rpm --import linux_signing_key.pub && rm linux_signing_key.pub && \
	zypper addrepo --refresh http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
	
RUN zypper install -y google-chrome-stable

RUN useradd --uid 1000 -m -U chrome

USER chrome
VOLUME /home/chrome/.config/
LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="chrome" \
      org.opencontainers.image.title="qubesome chrome workload" \
      org.opencontainers.image.description="Packages the Google Chrome browser for qubesome."
