FROM alpine:latest

RUN apk add \
        openrc \
        util-linux \
        linux-virt \
        e2fsprogs \
        bash

# Set up a login terminal on the serial console (ttyS0):
RUN ln -s agetty /etc/init.d/agetty.ttyS0 && \
    echo ttyS0 > /etc/securetty && \
    rc-update add agetty.ttyS0 default

# Make sure special file systems are mounted on boot:
RUN rc-update add devfs boot && \
    rc-update add procfs boot && \
    rc-update add sysfs boot && \
    rc-update add networking default

COPY interfaces /etc/network
COPY create_rootfs /usr/local/bin

RUN echo "Welcome to the microvm cli!" > /etc/motd
