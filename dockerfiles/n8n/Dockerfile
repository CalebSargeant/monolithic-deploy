FROM n8nio/n8n:latest AS base

# Switch to root user to install dependencies
USER root

RUN apk add --no-cache \
    chromium \
    ffmpeg \
    git \
    cmake \
    make \
    gcc \
    g++ \
    wget \
    curl \
    openblas-dev \
    && npm_config_user=root npm install puppeteer

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

# Set working directory to n8n default
WORKDIR /home/node

# Switch back to default non-root user
USER node

# Expose default n8n port
EXPOSE 5678

# Use n8n's default entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["n8n"]