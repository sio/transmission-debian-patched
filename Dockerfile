FROM debian:stable-slim AS build

WORKDIR /build

RUN apt-get update && \
    apt-get install -y \
        software-properties-common \
        && \
    add-apt-repository --enable-source 'http://deb.debian.org/debian' && \
    apt-get update && \
    apt-get build-dep -y transmission && \
    apt-get source transmission && \
    apt-get clean

ENV QUILT_PATCHES="debian/patches"
ENV QUILT_PATCH_OPTS="--reject-format=unified"
ENV QUILT_DIFF_ARGS="-p ab --no-timestamps --no-index --color=auto"
ENV QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
ENV QUILT_COLORS="diff_hdr=1;32:diff_add=1;34:diff_rem=1;31:diff_hunk=1;33:diff_ctx=35:diff_cctx=33"

RUN cd transmission-* && \
    mkdir -p debian/patches; \
    find -type d
