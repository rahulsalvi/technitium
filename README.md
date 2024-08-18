# dns
My DNS setup. It's basically just technitium accessible over tailscale with a setup script.

## Running
```
./start.sh
# follow the prompts
# you will need a token from tailscale
```

### Additional Config
Get the address of the new node with
```
source .env && tailscale ip $NAME
```
Connect to the node at http://<TAILSCALE_IP>:5380
Change the following settings:

Settings->Recursion->Randomize Name->Turn OFF
Settings->Recursion->NS Revalidation->Turn ON
Settings->Blocking->Quick Add->Whichever lists you want
Settings->DHCP->Disable anything that might be there

### Configure clients to use this server
Navigate to https://login.tailscale.com/admin/dns
Set nameservers for nodes

## Stopping
```sh
docker compose down
```
