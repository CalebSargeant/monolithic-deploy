# Use the official n8n base image that has Node.js 20 + dependencies
FROM n8nio/base:20 AS base

# Install additional dependencies as root
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

# Install n8n
ARG N8N_VERSION=1.21.0
RUN npm install -g --omit=dev n8n@${N8N_VERSION} --ignore-scripts && \
    npm rebuild --prefix=/usr/local/lib/node_modules/n8n sqlite3

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

# Ensure n8n is in PATH
ENV PATH="/usr/local/lib/node_modules/n8n/bin:$PATH"

# Use official n8n entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Set working directory to n8n default
WORKDIR /home/node

# Expose default n8n port
EXPOSE 5678

# Switch back to default non-root user
USER node

# Use the official n8n entrypoint
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
CMD ["n8n"]