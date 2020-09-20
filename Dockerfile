#
# megasync-arm Dockerfile
# Tested on Raspberry Pi 4

# Pull base image.
FROM daniel0076/baseimage-gui:ubuntu-20.04-aarch64-v0.1

# Define MEGASync binary download link
ARG MEGASYNC_URL="https://github.com/daniel0076/MEGAsync/releases/download/v4.3.4_Linux_aarch64_alpha/megasync.tar.gz"

# Define working directory
WORKDIR /tmp

# Download MEGASync binary for Linux aarch64
RUN \
    add-pkg --virtual download-tool wget && \
    mkdir -p /defaults && \
    wget ${MEGASYNC_URL} -O megasync.tar.gz && \
    tar -xf megasync.tar.gz --directory /defaults && \
    rm -f megasync.tar.gz && \
    del-pkg download-tool

# Install dependencies
RUN \
    add-pkg \
        libraw19 \
        libcurl3-gnutls \
        libcrypto++6 \
        libc-ares2 \
        libqt5svg5 \
        libqt5x11extras5 \
        libqt5widgets5 \
        libqt5gui5 \
        libqt5network5 \
        libqt5dbus5 \
        libqt5core5a \
        libavcodec58 \
        libavformat58 \
        libswscale5 \
        tint2       # System tray on openbox for MEGASync

# Add files
COPY rootfs/ /

# Set environment variables.
ENV APP_NAME="MEGASync" \
    S6_KILL_GRACETIME=8000

VOLUME ["/MEGASync"]
