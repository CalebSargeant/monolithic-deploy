## Use a minimal Debian-based image
#FROM debian:bookworm-slim
#
## Install dependencies and openfortivpn
#RUN apt update && apt install -y openfortivpn bash && rm -rf /var/lib/apt/lists/*
#
## Copy entrypoint script
#COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh
#
## Set entrypoint to dynamically create the config file
#ENTRYPOINT ["/entrypoint.sh"]

# Stage 1: Build openfortivpn as a static binary
FROM alpine:latest AS builder

RUN apk add --no-cache \
    bash \
    gcc \
    g++ \
    make \
    cmake \
    musl-dev \
    linux-headers \
    libressl-dev \
    ppp \
    git

WORKDIR /build
RUN git clone https://github.com/adrienverge/openfortivpn.git && \
    cd openfortivpn && \
    cmake -DSTATIC_BUILD=ON . && \
    make && \
    cp openfortivpn /openfortivpn

# Stage 2: Minimalist Runtime (Scratch)
FROM scratch
COPY --from=builder /openfortivpn /openfortivpn
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]