# Technitium stack

technitium dns-server available via tailscale

## Running

```sh
# set these variables first
#   TS_API_CLIENT_ID
#   TS_API_CLIENT_SECRET
./pre-deploy.sh
docker compose up -d
```

### Additional Config

Connect to the node at <https://technitiumX.ipn.rahulsalvi.com>

Change the following settings:

- Settings->Recursion->Randomize Name->Turn OFF
- Settings->Recursion->NS Revalidation->Turn ON
- Settings->Blocking->Quick Add->Whichever lists you want
- Settings->DHCP->Disable anything that might be there

Install the following apps:

- Query Logs (Sqlite)

### Configure clients to use this server

Use <https://login.tailscale.com/admin/dns>

## Development

```sh
# install pre-commit hooks
pre-commit install
# view complete compose file
docker compose config | bat --language yaml
# deploy application (see Usage section)
./pre-deploy.sh
docker compose up -d
```

## Licenses

- [LICENSE](LICENSE)
- [Technitium](https://github.com/TechnitiumSoftware/DnsServer/blob/master/LICENSE)
