FROM n8nio/n8n:latest

# Switch to root user to install packages
USER root

# Install dependencies
RUN apk add --no-cache \
    chromium \
    ffmpeg \
    git \
    build-base \
    cmake \
    make \
    gcc \
    g++ \
    wget \
    curl \
    openblas-dev \
    && npm_config_user=root npm install puppeteer

# Clone and build whispercpp
WORKDIR /opt
RUN git clone --depth=1 https://github.com/ggerganov/whisper.cpp.git whispercpp && \
    cd whispercpp && \
    cmake -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build --parallel $(nproc) && \
    cp build/bin/whisper-cli /usr/local/bin/whisper && \
    chmod +x /usr/local/bin/whisper

# Ensure the working directory is back to n8n default
WORKDIR /data

# Switch back to default non-root user
USER node

# Start n8n normally (without migration)
CMD ["n8n"]