FROM registry.opensuse.org/opensuse/tumbleweed as base

RUN zypper --non-interactive refresh && \
	zypper update -y && \
	zypper install -y \
        shadow \
		awk \
        xorg-x11-fonts xorg-x11-fonts-converted xorg-x11-fonts-core \
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
		lua54 lua54-lgi lua54-lgi-doc \
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
		notification-daemon nemo libgtk-4-1 gsettings-desktop-schemas && \
		zypper -n clean -a && \
		rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* /usr/lib/sysimage/rpm/*

# The builder stage is mostly used to get the latest source from awesomewm
# and compile it, without adding development tools and libs into the final
# xorg image.
FROM base as builder

COPY --from=registry.opensuse.org/opensuse/tumbleweed /usr/lib/sysimage/rpm/* /usr/lib/sysimage/rpm
RUN zypper --non-interactive refresh && \
	zypper install -y \
		git make cmake gcc \
		ImageMagick \
		lua54-devel \
		libxkbcommon-devel \
		pango-devel \
		gdk-pixbuf-devel \
		libxdg-basedir-devel libxkbcommon-x11-devel \
		xcb xcb-util-devel xcb-util-image-devel \
		xcb-util-keysyms-devel xcb-util-wm-devel \
		xcb-util-renderutil-devel \
		xcb-util-cursor-devel \
		startup-notification-devel \
		librsvg-devel && \
		zypper -n clean -a && \
		rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* /usr/lib/sysimage/rpm/*

RUN mkdir -p /src/awesome && git clone --depth 1 https://github.com/awesomeWM/awesome.git /src/awesome

RUN mkdir -p /out && cd /src/awesome && \
		make && \
		make install DESTDIR=/out

FROM base

COPY --from=builder /out /

RUN useradd --uid 1000 -m -U xorg-user
RUN mkdir -p /run/user/1000 && \
    chown -R 1000:1000 /run/user/1000

RUN sed -i 's;Name=Alacritty;Name=Xorg profile cli;g' /usr/share/applications/Alacritty.desktop

COPY org.freedesktop.Notifications.service /usr/share/dbus-1/services/

USER xorg-user

ENV FONTCONFIG_PATH=/etc/fonts
ENV DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

VOLUME /home/xorg-user/.config/
VOLUME /run/user/1000/
VOLUME /data

ENTRYPOINT ["/usr/sbin/tini", "--"]
