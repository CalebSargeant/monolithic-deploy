# Use the official n8n base image that has Node.js 20 + dependencies
FROM n8nio/n8n AS base

# Install additional dependencies as root
USER root

RUN apk add --no-cache \
    chromium \
    chromium-chromedriver \
    ffmpeg \
    git \
    cmake \
    make \
    gcc \
    g++ \
    wget \
    curl \
    openblas-dev \
    udev \
    ttf-freefont \
    font-noto \
    nss \
    freetype \
    harfbuzz \
    libstdc++ \
    libx11 \
    libxrender \
    libxext \
    libxcb \
    && npm_config_user=root npm install -g puppeteer

# Multi-stage build for whispercpp
FROM base AS whispercpp-build

WORKDIR /opt
RUN git clone --depth=1 https://github.com/ggerganov/whisper.cpp.git whispercpp && \
    cd whispercpp && \
    cmake -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build --parallel $(nproc)

# Final n8n image (without build dependencies)
FROM base AS final

COPY --from=whispercpp-build /opt/whispercpp/build/bin/whisper-cli /usr/local/bin/whisper
RUN chmod +x /usr/local/bin/whisper