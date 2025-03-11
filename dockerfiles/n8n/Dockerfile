# Use official n8n base image
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

# Set PATH correctly
ENV PATH="/usr/local/lib/node_modules/n8n/bin:$PATH"

# Switch back to default non-root user
USER node

# Expose default n8n port
EXPOSE 5678

# Use n8n's official entrypoint
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

# Default command to start n8n
CMD ["n8n"]