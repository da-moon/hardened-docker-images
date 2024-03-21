# Python

## Overview

Hardened `python` image that contains no vulnerabilities, based off of
`cgr.dev/chainguard/python`:

The purpose of this image is for demonstrating how we can install and use a
specific version of python (e.g `3.10`) with `pyenv` in a hardened Docker image

## vulnerability Scan

```console
λ snyk container test --file="Dockerfile" "python-base-hardened:latest"

Testing python-base-hardened:latest...

Organization:      REDACTED
Package manager:   apk
Target file:       Dockerfile
Project name:      docker-image|python-base-hardened
Docker image:      python-base-hardened:latest
Platform:          linux/amd64
Base image:        cgr.dev/chainguard/python:latest-dev
Licenses:          enabled

✔ Tested 70 dependencies for known issues, no vulnerable paths found.

Currently, we only offer base image recommendations for Official Docker images

-------------------------------------------------------

Testing python-base-hardened:latest...

Organization:      REDACTED
Package manager:   pip
Target file:       /opt/pyenv/plugins/python-build/scripts/requirements.txt
Project name:      /opt/pyenv/plugins/python-build/scripts/requirements.txt
Docker image:      python-base-hardened:latest
Licenses:          enabled

✔ Tested python-base-hardened:latest for known issues, no vulnerable paths found.


Tested 2 projects, no vulnerable paths were found.
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
