FROM registry.opensuse.org/opensuse/leap:15.5

RUN zypper --non-interactive refresh && \
	zypper update -y && \
	zypper install -y \
        shadow \
		awk \
        unicode-emoji liberation-fonts powerline-fonts \
        twemoji-color-font noto-coloremoji-fonts \
        xorg-x11-fonts xorg-x11-fonts-converted xorg-x11-fonts-core xorg-x11-fonts-legacy \
        adobe-sourcesans3-fonts adobe-sourcesanspro-fonts adobe-sourceserifpro-fonts

RUN zypper install -y xorg-x11-server-extra
RUN zypper install -y awesome awesome-shifty
RUN zypper install -y dbus-1

RUN	zypper install -y \
		alacritty rofi \
		picom \
		xbindkeys xclip scrot inotify-tools \
		unclutter \
		feh \
		file-roller thunar

RUN useradd --uid 1000 -m -U xorg-user
RUN mkdir -p /run/user/1000 && \
    chown -R 1000:1000 /run/user/1000

USER xorg-user

ENV FONTCONFIG_PATH=/etc/fonts

VOLUME /home/xorg-user/.config/
VOLUME /run/user/1000/
