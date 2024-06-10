FROM docker.io/kalilinux/kali-last-release

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="kali" \
      org.opencontainers.image.title="qubesome Kali workload" \
      org.opencontainers.image.description="Kali linux for qubesome."

RUN apt update -y && \
      apt install -y kali-linux-core kali-tools-top10 burpsuite hashcat gobuster \
                  vim openvpn net-tools inetutils-ping firefox-esr \
                  libx11-6 libxcursor1 libxrandr2 libxi6 libx11-xcb1 libx11-6 libpci-dev \
                  terminator alacritty zsh && \
      apt clean
