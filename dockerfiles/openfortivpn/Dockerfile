# Use a minimal Debian-based image
FROM debian:bookworm-slim

# Install dependencies and openfortivpn
RUN apt update && apt install -y openfortivpn bash && rm -rf /var/lib/apt/lists/*

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint to dynamically create the config file
ENTRYPOINT ["/entrypoint.sh"]