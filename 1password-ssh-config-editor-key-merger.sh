#!/bin/bash

set -euo pipefail

SCE_DIR="$HOME/.ssh/sce/1password"
mkdir -p "$SCE_DIR"

# Clean up old files
rm -f "$SCE_DIR"/*.pub "$SCE_DIR/.keys"

# Temporary file for collecting keys metadata
keys_tmp=$(mktemp)
echo "[]" > "$keys_tmp"

# Get all 1Password accounts dynamically
echo "Discovering 1Password accounts..."
ACCOUNTS=($(op account list --format json | jq -r '.[].user_uuid'))

if [ ${#ACCOUNTS[@]} -eq 0 ]; then
    echo "No 1Password accounts found. Make sure you're signed in to at least one account."
    exit 1
fi

echo "Found ${#ACCOUNTS[@]} account(s)"

for account in "${ACCOUNTS[@]}"; do
    echo "Processing account: $account"

    # Sign in once per account
    session=$(op signin --account "$account" --raw)

    # Get list of SSH key items
    items=$(OP_SESSION=$session op item list --categories "SSH Key" --format json --account "$account")

    # Process each item
    echo "$items" | jq -c '.[]' | while read -r item; do
        id=$(echo "$item" | jq -r '.id')
        title=$(echo "$item" | jq -r '.title')
        created_at=$(echo "$item" | jq -r '.createdAt // (now | strftime("%Y-%m-%dT%H:%M:%SZ"))')

        echo "  Processing: $title"

        # Get the full item details
        full_item=$(OP_SESSION=$session op item get "$id" --account "$account" --format json)

        # Extract public key - try multiple possible field locations
        pubkey=""

        # Try fields first
        pubkey=$(echo "$full_item" | jq -r '.fields[]? | select(.label // "" | test("public key"; "i")) | .value // empty' | head -1)

        # If not found, try sections
        if [ -z "$pubkey" ]; then
            pubkey=$(echo "$full_item" | jq -r '.sections[]?.fields[]? | select(.label // "" | test("public key"; "i")) | .value // empty' | head -1)
        fi

        if [ -n "$pubkey" ] && [ "$pubkey" != "null" ]; then
            # Write public key file
            echo "$pubkey" > "$SCE_DIR/$id.pub"

            # Add to keys metadata
            jq --arg id "$id" --arg title "$title" --arg createdAt "$created_at" \
               '. += [{id: $id, title: $title, createdAt: $createdAt}]' \
               "$keys_tmp" > "${keys_tmp}.new" && mv "${keys_tmp}.new" "$keys_tmp"

            echo "    ✓ Exported: $title"
        else
            echo "    ⚠ No public key found for: $title"
        fi
    done
done

# Sort keys alphabetically by title and move to final location
jq 'sort_by(.title)' "$keys_tmp" > "$SCE_DIR/.keys"
rm "$keys_tmp"

echo "SSH keys from both accounts merged in $SCE_DIR (sorted alphabetically)"
echo "Found $(jq length "$SCE_DIR/.keys") keys total"