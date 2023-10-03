# LManage

## Overview

Hardened minimal `lmanage` image with no vulnerabilities, based off of
`cgr.dev/chainguard/python`:

```console
λ snyk container test --file="Dockerfile" "lmanage:latest"

Testing lmanage:latest...

Organization:      REDACTED
Package manager:   apk
Target file:       Dockerfile
Project name:      docker-image|lmanage
Docker image:      lmanage:latest
Platform:          linux/amd64
Base image:        cgr.dev/chainguard/python:latest
Licenses:          enabled

✔ Tested 23 dependencies for known issues, no vulnerable paths found.
```

## Usage Guide

- We are using `pass` to store build time arguments and other image environment
  variables safely. If you are planning on using snippets in this guide,
  populate your `pass` store with required values using the following command

```bash
echo -n "<upstream_url>" | pass insert -mf 'looker/url'
echo -n "<client_id>" | pass insert -mf 'looker/client_id'
echo -n "<client_secret>" | pass insert -mf 'looker/client_secret'
```

- Build the image

```bash
docker build \
  --build-arg "UID=$(id -u)" \
  --build-arg "GID=$(id -g)" \
  --build-arg "LOOKERSDK_BASE_URL=$(pass looker/url)" \
  --tag "lmanage" \
  .
```

- Scan for vulnerabilities with `snyk`

```bash
snyk container test --file="Dockerfile" "lmanage:latest"
```

- Capture Upstream Looker Setting

```bash
rm -rf "capturator" \
&& mkdir -p "capturator" \
&& docker run --rm -it \
  --user "$(id -u)" \
  --volume "$PWD/capturator:/workspace:rw" \
  --env "LOOKERSDK_CLIENT_ID=$(pass looker/client_id)" \
  --env "LOOKERSDK_CLIENT_SECRET=$(pass looker/client_secret)" \
  lmanage capturator --force --config-dir "/workspace"
```
