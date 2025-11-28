FROM registry.opensuse.org/opensuse/tumbleweed AS base

RUN zypper --non-interactive refresh && \
	zypper update -y && \
	zypper install -y \
        shadow \
		awk \
        xorg-x11-fonts xorg-x11-fonts-core \
		xorg-x11-server-extra dbus-1 \
		libxcb1 \
		libxcb-cursor0 \
		libxcb-util1 \
		libxcb-keysyms1 \
		libxcb-icccm4 \ 
		libxcb-xfixes0 \
		libxcb-xtest0 \
		libxcb-util1 \
		libxkbcommon0 \
		libxdg-basedir1 \
		xcb-util-xrm-devel \
		xcb-util-errors-devel \
		libstartup-notification-1-0 \
		libcairo2 \
		libglib-2_0-0 \
		libgio-2_0-0 \
		libxkbcommon-x11-0 \
		awesome \
		lua54 \
		gzip \
		libnotify-tools \
		typelib-1_0-Atk-1_0 typelib-1_0-GdkPixbuf-2_0 \
		typelib-1_0-Gtk-3_0 \
  		typelib-1_0-HarfBuzz-0_0 typelib-1_0-Pango-1_0 \
		typelib-1_0-Rsvg-2_0 \
		xauth \
		rofi \
		picom \
		xbindkeys xclip scrot inotify-tools \
		unclutter \
		feh \
		Mesa-demo-x \
		VirtualGL \
		hostname \
		alacritty \
		tini \
		i3 \
		polybar dunst psmisc \
		xwayland xwayland-run xwayland-satellite \
		notification-daemon nemo libgtk-4-1 gsettings-desktop-schemas && \
		zypper -n clean -a && \
		rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* /usr/lib/sysimage/rpm/*

FROM base

RUN useradd --uid 1000 -m -U xorg-user && \
	groupadd -g 482 video && \
	groupadd -g 485 render && \
	usermod -aG video xorg-user && \
	usermod -aG render xorg-user
RUN mkdir -p /run/user/1000 && \
    chown -R 1000:1000 /run/user/1000

# For clarity, rename Alacritty at Xorg, so it is easier for users
# to understand its scope.
RUN sed -i 's;Name=Alacritty;Name=Xorg profile cli;g' /usr/share/applications/Alacritty.desktop

COPY org.freedesktop.Notifications.service /usr/share/dbus-1/services/

USER xorg-user

ENV FONTCONFIG_PATH=/etc/fonts
ENV DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

VOLUME /home/xorg-user/.config/
VOLUME /run/user/1000/
VOLUME /data

ENTRYPOINT ["/usr/sbin/tini", "--"]
