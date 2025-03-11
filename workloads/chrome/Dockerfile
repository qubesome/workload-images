ARG TAG=latest
ARG REGISTRY=ghcr.io/qubesome
FROM ${REGISTRY}/base:${TAG}

RUN	curl https://dl.google.com/linux/linux_signing_key.pub -O && \
	rpm --import linux_signing_key.pub && rm linux_signing_key.pub && \
	zypper -n refresh && \    
    zypper -n addrepo --refresh https://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome && \
    zypper -n install -y google-chrome-stable && \
    zypper -n cc -a && \
    zypper -n rm zypper && \
    rm -rf /tmp/* /var/tmp/* /var/log/* /usr/share/doc/packages/* \
            /usr/lib/sysimage/rpm/* /var/cache/zypp/* \
            /var/log/zypp/* /usr/share/man/* /usr/share/doc/*

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
