# Requires Docker 18.04 or newer.
# Compilation will fail with Qt *.png errors otherwise:
# https://stackoverflow.com/a/52084936

FROM debian:stable-slim AS build

WORKDIR /build

RUN \
    chown 100001:100001 . && \
    apt-get update && \
    apt-get install -y \
        devscripts \
        libseccomp-dev \
        quilt \
        software-properties-common \
        && \
    add-apt-repository --enable-source 'http://deb.debian.org/debian' && \
    apt-get update && \
    apt-get build-dep -y transmission

ENV QUILT_PATCHES="debian/patches"
ENV QUILT_PATCH_OPTS="--reject-format=unified"
ENV QUILT_DIFF_ARGS="-p ab --no-timestamps --no-index --color=auto"
ENV QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
ENV QUILT_COLORS="diff_hdr=1;32:diff_add=1;34:diff_rem=1;31:diff_hunk=1;33:diff_ctx=35:diff_cctx=33"

USER 100001:100001
COPY fdlimit.patch /build/
RUN \
    apt-get source transmission && \
    cd transmission-* && \
    quilt push -a ; \
    quilt import /build/fdlimit.patch && \
    quilt pop -a && \
    DEBEMAIL="Vitaly Potyarkin <sio.wtf@gmail.com>" debchange --nmu \
        "Backported some patches to stable version of transmission" \
        && \
    debuild -us -uc
