#!/bin/bash

# Ensure all required environment variables are set
if [[ -z "$VPN_HOST" || -z "$VPN_USERNAME" || -z "$VPN_PASSWORD" || -z "$VPN_CERT" ]]; then
  echo "Error: VPN_HOST, VPN_USERNAME, VPN_PASSWORD, and VPN_CERT must be set."
  exit 1
fi

# Function to check VPN status
check_vpn() {
  if [[ -n "$CURL_ENDPOINT" ]]; then
    curl -s "$CURL_ENDPOINT" > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo "$(date) - Warning: VPN may be down! Failed to reach $CURL_ENDPOINT"
    fi
  fi

  if [[ -n "$DNS_ENDPOINT" ]]; then
    dig "@$DNS_ENDPOINT" www.google.com > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo "$(date) - Warning: VPN may be down! Failed to query $DNS_ENDPOINT"
    fi
  fi
}

# Generate the openfortivpn configuration file dynamically
cat > /etc/openfortivpn.conf <<EOF
host = $VPN_HOST
port = 443
username = $VPN_USERNAME
password = $VPN_PASSWORD
trusted-cert = $VPN_CERT
EOF

echo "$(date) - Starting VPN..."

# Start the VPN and capture the process ID
openfortivpn -c /etc/openfortivpn.conf &
VPN_PID=$!

# Wait a few seconds for VPN to establish
sleep 5

# If keepalive is enabled, monitor VPN connection
if [[ -n "$CURL_ENDPOINT" || -n "$DNS_ENDPOINT" ]]; then
  while kill -0 "$VPN_PID" > /dev/null 2>&1; do
    check_vpn
    sleep 60  # Check every 60 seconds
  done
fi

# If the VPN process exits, kill the container
echo "$(date) - VPN process exited. Shutting down."
exit 1