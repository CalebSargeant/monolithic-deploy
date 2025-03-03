# Base image: Alpine Linux (lightweight)
FROM alpine:latest

# Install openfortivpn and dependencies
RUN apk add --no-cache openfortivpn bash

# Create an entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint to dynamically create the config file
ENTRYPOINT ["/entrypoint.sh"]