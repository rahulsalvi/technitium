#!/bin/bash

export GOPATH="${PWD}/go"
echo "Installing dependencies to ${GOPATH}/bin"
go install tailscale.com/cmd/get-authkey@latest
go install github.com/charmbracelet/gum@latest
export PATH="${GOPATH}/bin:${PATH}"

if [ -f .env ]; then
	source .env
else
	echo "Choose hostname for new dns server"
	NAME=$(gum input --placeholder "dnsX")
	echo "NAME=${NAME}" >.env
	echo "Wrote variables to .env"
fi

echo "Managing ${NAME}"

if tailscale ip "${NAME}" >/dev/null 2>&1; then
	echo "${NAME} seems to already exist. You should remove it before continuing"
	echo "https://login.tailscale.com/admin/machines"
	exit 1
fi

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
TS_AUTHKEY=$(get-authkey -ephemeral -preauth -tags tag:nameserver)
export TS_AUTHKEY

gum spin --title "Starting up" -- docker compose up -d --build

echo "Remember to update the tailnet DNS servers"
echo "https://login.tailscale.com/admin/dns"

echo "Done!"
