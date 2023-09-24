# Dockerized OpenVPN Client

Ref: https://linux.die.net/man/8/openvpn

DockerHub: https://hub.docker.com/r/joestldr/openvpn-client

GitHub: https://github.com/joes-tldr/dockerized-openvpn-client

## TLDR; Sample usages:

### "VPNize" container only:

```bash
CONF_PATH="/path/to/client.ovpn"
PASS_PATH="/path/to/client.pass"

docker run \
    --name joestldr-openvpn-client \
    --detach \
    --restart unless-stopped \
    --dns 8.8.8.8 \
    --dns 8.8.4.4 \
    --cap-add NET_ADMIN \
    --device /dev/net/tun \
    --mount="type=bind,source=${CONF_PATH},target=/client.ovpn,readonly" \
    --mount="type=bind,source=${PASS_PATH},target=/client.pass,readonly" \
  joestldr/openvpn-client:v1.0.0 \
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
    --dns 8.8.8.8 \
    --dns 8.8.4.4 \
    --privileged \
    --network host \
    --mount="type=bind,source=${CONF_PATH},target=/client.ovpn,readonly" \
    --mount="type=bind,source=${PASS_PATH},target=/client.pass,readonly" \
  joestldr/openvpn-client:v1.0.0 \
    --config /client.ovpn --auth-user-pass /client.pass --auth-nocache
```
Ref: https://linux.die.net/man/8/openvpn

# License

Copyright 2023 [joes-tldr](https://github.com/joes-tldr)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
