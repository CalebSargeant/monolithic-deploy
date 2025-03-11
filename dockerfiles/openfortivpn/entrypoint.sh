#!/bin/bash

set -e

# Ensure required environment variables are set
if [[ -z "$VPN_HOST" || -z "$VPN_USERNAME" || -z "$VPN_PASSWORD" || -z "$VPN_CERT" ]]; then
  echo "$(date) - Error: Missing required environment variables."
  exit 1
fi

# Graceful shutdown handling
cleanup() {
  echo "$(date) - Stopping VPN..."
  kill -TERM "$VPN_PID" 2>/dev/null || true
  rm -f /tmp/healthy  # Mark pod as unhealthy
  exit 0
}
trap cleanup SIGINT SIGTERM

# Generate VPN configuration
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

# Run a single health check, exit cleanly if VPN is down
if [[ -n "$CURL_ENDPOINT" ]]; then
  echo "$(date) - Checking VPN connectivity via HTTP..."
  if ! curl -s --max-time 5 "$CURL_ENDPOINT" > /dev/null; then
    echo "$(date) - VPN failed! Marking pod as unhealthy."
    kill "$VPN_PID"
    rm -f /tmp/healthy  # Mark pod as unhealthy
    exit 0  # Prevent restart
  fi
fi

if [[ -n "$DNS_ENDPOINT" ]]; then
  echo "$(date) - Checking VPN connectivity via DNS..."
  if ! dig "@$DNS_ENDPOINT" www.google.com +time=5 > /dev/null; then
    echo "$(date) - VPN failed! Marking pod as unhealthy."
    kill "$VPN_PID"
    rm -f /tmp/healthy  # Mark pod as unhealthy
    exit 0  # Prevent restart
  fi
fi

# Mark the pod as healthy
touch /tmp/healthy

echo "$(date) - VPN is up and running."
wait "$VPN_PID"

# If the VPN process exits, mark the pod as unhealthy
echo "$(date) - VPN process exited. Shutting down."
rm -f /tmp/healthy  # Mark pod as unhealthy
exit 0