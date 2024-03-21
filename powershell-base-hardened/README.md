# powershell-base-hardened

## Overview

Hardened Powershell base Docker image with zero CVE vulnerabilities

- The default `cgr.dev/chainguard/powershell:latest` image is missing some core
  Modules (e.g `PowershellGet`). This module adds default missing packages and
  enables users to install third-party modules from the Powershell Gallery
- showcases how to use `cgr.dev/chainguard/curl:latest` which is an image
  without a shell to download blobs
- showcases how to use "cgr.dev/chainguard/busybox:latest" to extract archives

## vulnerability Scan

```console
λ snyk container test --file="Dockerfile" "powershell-base-hardened:latest"


Testing powershell-base-hardened:latest...

Organization:      REDACTED
Package manager:   apk
Target file:       Dockerfile
Project name:      docker-image|powershell-base-hardened
Docker image:      powershell-base-hardened:latest
Platform:          linux/amd64
Base image:        cgr.dev/chainguard/powershell:latest
Licenses:          enabled

✔ Tested 21 dependencies for known issues, no vulnerable paths found.

Currently, we only offer base image recommendations for Official Docker images
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

- Build the image without pushing it to remote

```bash
export LOCAL=true ;
bash build.sh ;
```

Look into `docker-bake.hcl` file's variables for other configuration options;
use environment variables to set them before running `build.sh` script

You can find the associated SPDX SBOM
[here](https://github.com/da-moon/hardened-docker-images/releases/tag/sboms)

## Usage Guide

- Scan for vulnerabilities with `snyk`

```bash
snyk container test --file="Dockerfile" "powershell-base-hardened:latest"
```
