# Dockerized OpenVPN Client

Ref: https://linux.die.net/man/8/openvpn

DockerHub: https://hub.docker.com/r/joestldr/openvpn-client

GitHub: https://github.com/joestldr/dockerized-openvpn-client

## TLDR; Sample usages:

### "VPNize" container only:

```bash
CONF_PATH="/path/to/client.ovpn"
PASS_PATH="/path/to/client.pass"

docker run \
    --name joestldr-openvpn-client \
    --detach \
    --restart unless-stopped \
    --dns 9.9.9.9 \
    --dns 149.112.112.112 \
    --cap-add NET_ADMIN \
    --device /dev/net/tun \
    --mount="type=bind,source=${CONF_PATH},target=/client.ovpn,readonly" \
    --mount="type=bind,source=${PASS_PATH},target=/client.pass,readonly" \
  joestldr/openvpn-client:latest \
    --config /client.ovpn --auth-user-pass /client.pass --auth-nocache
```
Ref: https://linux.die.net/man/8/openvpn

### "VPNize" host:

```bash
CONF_PATH="/path/to/client.ovpn"
PASS_PATH="/path/to/client.pass"

docker run \
    --name joestldr-openvpn-client \
    --detach \
    --restart unless-stopped \
    --dns 9.9.9.9 \
    --dns 149.112.112.112 \
    --privileged \
    --network host \
    --mount="type=bind,source=${CONF_PATH},target=/client.ovpn,readonly" \
    --mount="type=bind,source=${PASS_PATH},target=/client.pass,readonly" \
  joestldr/openvpn-client:latest \
    --config /client.ovpn --auth-user-pass /client.pass --auth-nocache
```
Ref: https://linux.die.net/man/8/openvpn

## Pre-connect check - Command that should `exit 0` before connecting to VPN

Something like... Wait for internet/intranet/vpn-server to be available?

```bash
PRE_CONNECT_CHECK_CMD='ping -W 3 -c 4 9.9.9.9 && ping -W 3 -c 4 149.112.112.112'
#PRE_CONNECT_CHECK_CMD='curl -sf https://google.com'

CONF_PATH="/path/to/client.ovpn"
PASS_PATH="/path/to/client.pass"

docker run \
    --name joestldr-openvpn-client \
    --detach \
    --restart unless-stopped \
    --dns 9.9.9.9 \
    --dns 149.112.112.112 \
    --cap-add NET_ADMIN \
    --device /dev/net/tun \
    --mount="type=bind,source=${CONF_PATH},target=/client.ovpn,readonly" \
    --mount="type=bind,source=${PASS_PATH},target=/client.pass,readonly" \
    --env PRE_CONNECT_CHECK_CMD="${PRE_CONNECT_CHECK_CMD}" \
    --env PRE_CONNECT_CHECK_MAX_RETRIES="3" \
  joestldr/openvpn-client:latest \
    --config /client.ovpn --auth-user-pass /client.pass --auth-nocache
```

## Sample `docker compose` usage:

See "Dockerized VPN Proxy" - Magical HTTP and SOCKS4/SOCKS5 proxy behind VPN (without host being on VPN)

Link: https://github.com/joestldr/dockerized-vpn-proxy

# License

Copyright 2023 [joestldr](https://joestldr.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
