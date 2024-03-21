# checkov

## Overview

The image contains Bridgecrew's `checkov` application. It is presented here to
demonstrate how you can package a Python application installed through `pip` on
top of `cgr.dev/chainguard/python:latest` base image, a hardened base layer
without any vulnerabilities.

The challenge with the said base image is that due to hardening, it does not
contain any shell other than python interpreter and it does not come with `pip`
so in this image, I am demonstrating how you can install and package an example
pip application (i.e `checkov`) in this hardened environment.

The pattern presented here should apply to almost any docker image that is
meant to hold a single Python application.

## vulnerability Scan

```console
λ snyk container test --file="Dockerfile" "checkov:latest"

Testing checkov:latest...

Organization:      REDACTED
Package manager:   apk
Target file:       Dockerfile
Project name:      docker-image|checkov
Docker image:      checkov:latest
Platform:          linux/amd64
Base image:        cgr.dev/chainguard/python:latest
Licenses:          enabled

✔ Tested 24 dependencies for known issues, no vulnerable paths found.

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
bash build.sh ;
```

Look into `docker-bake.hcl` file's variables for other configuration options;
use environment variables to set them before running `build.sh` script

You can find the associated SPDX SBOM
[here](https://github.com/da-moon/hardened-docker-images/releases/tag/sboms)

## Usage Guide

- Scan for vulnerabilities with `snyk`

```bash
snyk container test --file="Dockerfile" "checkov:latest"
```
