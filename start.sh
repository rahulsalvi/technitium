#!/bin/bash

set -euo pipefail

[ -f .env ] && source .env

declare -A deps
deps["gum"]="github.com/charmbracelet/gum@latest"
deps["get-authkey"]="tailscale.com/cmd/get-authkey@latest"

for dep in "${!deps[@]}"; do
	if ! command -v "${dep}" &>/dev/null; then
		echo "Installing ${dep}"
		go install "${deps[${dep}]}"
	fi
done

[ ! -v NAME ] && NAME=$(gum input --placeholder="Enter the hostname for the new dns server (e.g. dns1)")
if [ -z "$NAME" ]; then
	echo "Enter a valid name"
	exit 1
fi
export NAME

if tailscale ip "${NAME}" >/dev/null 2>&1; then
	echo "${NAME} seems to already exist. You should remove it before continuing"
	echo "https://login.tailscale.com/admin/machines"
	exit 1
fi

echo "Managing ${NAME}"

echo "Enter your tailscale API client ID"
echo "https://login.tailscale.com/admin/settings/oauth"
TS_API_CLIENT_ID=$(gum input --password)
export TS_API_CLIENT_ID

echo "Enter your tailscale API client secret"
echo "https://login.tailscale.com/admin/settings/oauth"
TS_API_CLIENT_SECRET=$(gum input --password)
export TS_API_CLIENT_SECRET

echo "Enter initial admin password for technitium"
TECHNITIUM_PASSWORD=$(gum input --password)
export TECHNITIUM_PASSWORD

echo "Generating tailscale auth keys"
TS_AUTHKEY=$(get-authkey -ephemeral -preauth -tags tag:nameserver,tag:recursive)
export TS_AUTHKEY

gum spin --title "Starting up" --show-output -- docker compose up -d --build

echo "Remember to update the tailnet DNS servers"
echo "https://login.tailscale.com/admin/dns"

echo "Done!"
