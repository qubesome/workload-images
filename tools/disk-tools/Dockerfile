FROM ghcr.io/rancher/elemental-toolkit/elemental-cli:latest

RUN zypper in -y \
        udisks2 \
        qemu-tools

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="disk-tools" \
      org.opencontainers.image.title="qubesome disk-tools" \
      org.opencontainers.image.description="Tools for management VM disks."

# Removes the entrypoint from the base image.
ENTRYPOINT []
