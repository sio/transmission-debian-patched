FROM debian:stable-slim AS build

WORKDIR /build
RUN apt-get update && \
    apt-get install -y \
        software-properties-common \
        && \
    add-apt-repository --enable-source && \
    apt-get update && \
    apt-get build-dep transmission && \
    apt-get clean
