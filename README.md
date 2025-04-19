# technitium
technitium dns-server available via tailscale

## Running
```
# create .env file with ID (replace X with a number)
echo ID=X >.env
# get a tailscale authkey (https://login.tailscale.com/admin/settings/keys)
# ephemeral, pre-approved, tags:nameserver,recursive,webserver
echo $AUTHKEY >ts_authkey.txt
# start
docker compose up -d
```

### Additional Config
Connect to the node at https://technitiumX.ipn.rahulsalvi.com

Change the following settings:

 - Settings->Recursion->Randomize Name->Turn OFF
 - Settings->Recursion->NS Revalidation->Turn ON
 - Settings->Blocking->Quick Add->Whichever lists you want
 - Settings->DHCP->Disable anything that might be there

Install the following apps:
 - Query Logs (Sqlite)

### Configure clients to use this server
Use https://login.tailscale.com/admin/dns

## Updating
```
docker compose pull && docker compose up -d
```

## Stopping
```sh
# bring down containers
docker compose down --remove-orphans
# (optional) clean up all resources
# WARNING: this will prune docker volumes that aren't being used!
docker system prune --all --volumes
```
