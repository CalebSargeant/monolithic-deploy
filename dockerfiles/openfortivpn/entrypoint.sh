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

# Function to check VPN health
check_vpn() {
  echo "$(date) - Running VPN health check..."

  if [[ -n "$CURL_ENDPOINT" ]]; then
    echo "$(date) - Checking VPN connectivity via HTTP to $CURL_ENDPOINT..."
    if ! curl -s --max-time 10 "$CURL_ENDPOINT" > /dev/null; then
      echo "$(date) - VPN failed (HTTP check)! Marking pod as unhealthy."
      kill "$VPN_PID"
      rm -f /tmp/healthy  # Mark pod as unhealthy
      exit 0
    fi
  fi

  if [[ -n "$DNS_ENDPOINT" ]]; then
    echo "$(date) - Checking VPN connectivity via DNS to $DNS_ENDPOINT..."
    if ! dig "@$DNS_ENDPOINT" www.google.com +time=5 > /dev/null; then
      echo "$(date) - VPN failed (DNS check)! Marking pod as unhealthy."
      kill "$VPN_PID"
      rm -f /tmp/healthy  # Mark pod as unhealthy
      exit 0
    fi
  fi

  if [[ -n "$DNS_ENDPOINT" ]]; then
    echo "$(date) - Checking VPN connectivity via PING to $DNS_ENDPOINT..."
    if ! ping -c 5 "$DNS_ENDPOINT" > /dev/null; then
      echo "$(date) - VPN failed (Ping check)! Marking pod as unhealthy."
      kill "$VPN_PID"
      rm -f /tmp/healthy  # Mark pod as unhealthy
      exit 0
    fi
  fi

  echo "$(date) - VPN health check passed."
}

# Mark the pod as healthy
touch /tmp/healthy
echo "$(date) - VPN is up and running."

# Periodic health checks while VPN is running
while kill -0 "$VPN_PID" > /dev/null 2>&1; do
  check_vpn
  sleep 10  # Run health checks every 10 seconds
done

# If the VPN process exits, mark the pod as unhealthy
echo "$(date) - VPN process exited. Shutting down."
rm -f /tmp/healthy  # Mark pod as unhealthy
exit 0
