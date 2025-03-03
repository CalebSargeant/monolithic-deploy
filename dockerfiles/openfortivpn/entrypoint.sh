#!/bin/bash

# Ensure all required environment variables are set
if [[ -z "$VPN_HOST" || -z "$VPN_USERNAME" || -z "$VPN_PASSWORD" ]]; then
  echo "Error: VPN_HOST, VPN_USERNAME, and VPN_PASSWORD must be set."
  exit 1
fi

# Generate the openfortivpn configuration file dynamically
cat > /etc/openfortivpn.conf <<EOF
host = $VPN_HOST
port = 443
username = $VPN_USERNAME
password = $VPN_PASSWORD
trusted-cert = $VPN_CERT
EOF

# Start the VPN
exec openfortivpn -c /etc/openfortivpn.conf