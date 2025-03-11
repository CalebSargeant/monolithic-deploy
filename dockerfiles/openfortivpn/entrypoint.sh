#!/bin/bash

set -e

# Ensure all required environment variables are set
REQUIRED_VARS=("VPN_HOST" "VPN_USERNAME" "VPN_PASSWORD" "VPN_CERT")
for var in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!var}" ]]; then
    echo "$(date) - Error: $var must be set."
    exit 1
  fi
done

# Function to check VPN status with logging
check_vpn() {
  if [[ -n "$CURL_ENDPOINT" ]]; then
    echo "$(date) - Checking VPN via HTTP request to $CURL_ENDPOINT..."
    START_TIME=$(date +%s%N)
    if curl -s --max-time 5 "$CURL_ENDPOINT" > /dev/null; then
      END_TIME=$(date +%s%N)
      RESPONSE_TIME=$(( (END_TIME - START_TIME) / 1000000 ))  # Convert nanoseconds to milliseconds
      echo "$(date) - Success: Reached $CURL_ENDPOINT in ${RESPONSE_TIME}ms"
    else
      echo "$(date) - Warning: VPN may be down! Failed to reach $CURL_ENDPOINT"
      return 1
    fi
  fi

  if [[ -n "$DNS_ENDPOINT" ]]; then
    echo "$(date) - Checking VPN via DNS query to $DNS_ENDPOINT..."
    START_TIME=$(date +%s%N)
    if dig "@$DNS_ENDPOINT" www.google.com +time=5 > /dev/null; then
      END_TIME=$(date +%s%N)
      RESPONSE_TIME=$(( (END_TIME - START_TIME) / 1000000 ))  # Convert nanoseconds to milliseconds
      echo "$(date) - Success: DNS query to $DNS_ENDPOINT completed in ${RESPONSE_TIME}ms"
    else
      echo "$(date) - Warning: VPN may be down! Failed to query $DNS_ENDPOINT"
      return 1
    fi
  fi

  return 0
}

# Graceful shutdown handling
cleanup() {
  echo "$(date) - Stopping VPN..."
  kill -TERM "$VPN_PID" 2>/dev/null || true
  exit 0
}

trap cleanup SIGINT SIGTERM

# Generate the openfortivpn configuration file dynamically
cat > /etc/openfortivpn.conf <<EOF
host = $VPN_HOST
port = 443
username = $VPN_USERNAME
password = $VPN_PASSWORD
trusted-cert = $VPN_CERT
EOF

echo "$(date) - Starting VPN..."
openfortivpn -c /etc/openfortivpn.conf &
VPN_PID=$!

# Wait for VPN to establish
sleep 5

# Keepalive logic to ensure VPN remains active
if [[ -n "$CURL_ENDPOINT" || -n "$DNS_ENDPOINT" ]]; then
  while kill -0 "$VPN_PID" > /dev/null 2>&1; do
    check_vpn || break
    sleep 60  # Check every 60 seconds
  done
fi

# If the VPN process exits, log it and exit gracefully
echo "$(date) - VPN process exited. Shutting down container."
exit 0  # Exit with 0 so Kubernetes does not restart the pod