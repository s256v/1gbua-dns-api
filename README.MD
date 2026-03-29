# 1gb.ua DNS API for acme.sh

## Prerequisites
- [acme.sh](https://github.com/acmesh-official/acme.sh) is installed in the home folder
- [jq](https://jqlang.org/download/) is available in the system

## How to install

Copy or link `dns_1gbua.sh` from this repo into `~/.acme.sh/dnsapi/` folder

## How to get token
Use `get-token.sh` to generate initial token
then it should be stored in the `GB1UA_TOKEN` on the first run of acme.sh
More information about the token could be found [here](https://www.1gb.ua/services_api.php).

## How to issue certificate

```sh
acme.sh --issue --dns dns_1gbua -d 'example.com' -d '*.example.com'
```
For more use cases check acme.sh documentation.

## Links
https://github.com/acmesh-official/acme.sh/wiki/DNS-API-Dev-Guide  
https://www.1gb.ua/services_api.php