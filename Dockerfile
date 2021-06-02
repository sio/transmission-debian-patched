# BUILD TRANSMISSION PACKAGE FOR DEBIAN AFTER APPLYING PATCHES
# https://github.com/sio/transmission-debian-patched


# Stage 1. Heavy build environment
FROM debian:10-slim AS build
LABEL github=sio/transmission-debian-patched

WORKDIR /build

RUN \
    chown 100001:100001 . && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        devscripts \
        quilt \
        software-properties-common \
        && \
    add-apt-repository --enable-source 'http://deb.debian.org/debian' && \
    apt-get update && \
    apt-get build-dep --no-install-recommends -y transmission && \
    apt-get clean

ENV QUILT_PATCHES="debian/patches"
ENV QUILT_PATCH_OPTS="--reject-format=unified"
ENV QUILT_DIFF_ARGS="-p ab --no-timestamps --no-index --color=auto"
ENV QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
ENV QUILT_COLORS="diff_hdr=1;32:diff_add=1;34:diff_rem=1;31:diff_hunk=1;33:diff_ctx=35:diff_cctx=33"

USER 100001:100001
COPY *.patch /build/
RUN \
    apt-get source transmission && \
    rm ./*.tar.xz ./*.dsc && \
    cd transmission-* && \
    quilt push -a ; \
    quilt import /build/*.patch && \
    quilt pop -a && \
    DEBEMAIL="Vitaly Potyarkin <sio.wtf@gmail.com>" debchange --nmu \
        "Backported some patches to stable version of transmission" \
        && \
    debuild -us -uc


# Stage 2. Publish artifacts to empty container
FROM scratch
LABEL github=sio/transmission-debian-patched
COPY --from=build \
    /build/*.deb \
    /build/*.tar.xz \
    /build/*.dsc \
    /packages/
CMD ["There are no executables in this container"]
