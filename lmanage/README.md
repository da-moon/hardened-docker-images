# LManage

## Overview

This image builds and packages `LManage` cli. It is presented here to
demonstrate how to create a hardened python application build and packaging
pipeline

- `Poetry` for build system and dependency management
- `pex` format for packaging as single executable
- Pinning python version since as the time of writing this guide, LManage can
  only run on python `3.10`

## vulnerability Scan

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

## Build Guide

- Ensure Docker `buildx` is installed

```console
λ docker buildx version
github.com/docker/buildx 0.13.1 788433953af10f2a698f5c07611dddce2e08c7a0
```

- Ensure Docker
  [`sbom`](https://www.docker.com/blog/generate-sboms-with-buildkit/) plugin is
  installed

```console
λ docker sbom version
Application:        docker-sbom ([not provided])
Provider:           syft (v0.46.3)
GitCommit:          [not provided]
GitDescription:     [not provided]
Platform:           linux/amd64
```

- We are using the `pass` CLI to store build time arguments and other image
  environment variables safely. If you are planning on using snippets in this
  guide, populate your `pass` store with required values using the following
  command

```bash
echo -n "<upstream_url>" | pass insert -mf 'looker/url'
echo -n "<client_id>" | pass insert -mf 'looker/client_id'
echo -n "<client_secret>" | pass insert -mf 'looker/client_secret'
```

- Build the image without pushing it to the remote

```bash
bash build.sh ;
```

Look into `docker-bake.hcl` file's variables for other configuration options;
use environment variables to set them before running `build.sh` script

You can find the associated SPDX SBOM
[here](https://github.com/da-moon/hardened-docker-images/releases/tag/sboms)

## Usage Guide

- We are using the `pass` CLI to store build time arguments and other image
  environment variables safely. If you are planning on using snippets in this
  guide, populate your `pass` store with required values using the following
  command

```bash
echo -n "<upstream_url>" | pass insert -mf 'looker/url'
echo -n "<client_id>" | pass insert -mf 'looker/client_id'
echo -n "<client_secret>" | pass insert -mf 'looker/client_secret'
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
