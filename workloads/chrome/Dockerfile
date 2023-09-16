FROM registry.opensuse.org/opensuse/leap:15.5

RUN zypper --non-interactive refresh && \
	zypper update -y && \
	zypper install -y \
        shadow \
		awk \
		curl \
		pipewire-alsa pipewire alsa-utils

RUN	curl https://dl.google.com/linux/linux_signing_key.pub -O && \
	rpm --import linux_signing_key.pub && rm linux_signing_key.pub && \
	zypper addrepo --refresh http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
	
RUN zypper install -y google-chrome-stable

# Install fonts (inc emoji) so the look and feel is consistent
# on any target machine.
RUN zypper install -y \
       unicode-emoji liberation-fonts \
       xorg-x11-fonts xorg-x11-fonts-converted xorg-x11-fonts-core

RUN useradd --uid 1000 -m -U chrome

USER chrome
VOLUME /home/chrome/.config/
