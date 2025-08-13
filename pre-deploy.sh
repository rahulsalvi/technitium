#!/bin/sh

TS_TAGS=tag:webserver,tag:nameserver,tag:recursive

# return code
RC=0

git submodule update --init --recursive

if [ ! -e .env ]; then
    touch .env
fi
chmod -f 600 .env

if ! grep -q "TS_AUTHKEY" .env; then
    if [ -z "$TS_API_CLIENT_ID" ]; then
        echo "ERROR: no tailscale oauth credentials provided"
        RC=1
    else
        echo "Adding TS_AUTHKEY to .env"
        {
            # add a newline to ensure there's one before this section
            echo ""
            echo "TS_AUTHKEY=$(get-authkey -tags "$TS_TAGS" -ephemeral -preauth)"
        } >>.env
    fi
fi

exit $RC
