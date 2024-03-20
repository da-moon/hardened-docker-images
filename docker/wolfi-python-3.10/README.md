# Python

## Overview

Hardened `python` image that contains no vulnerabilities, based off of
`cgr.dev/chainguard/python`:

The purpose of this image is for demonstrating how we can install and use a
specific version of python (e.g `3.10`) with `pyenv` in a hardened Docker image

## vulnerability Scan

```console
λ snyk container test --file="Dockerfile" "fjolsvin/wolfi-python-3.10:latest"

Testing fjolsvin/wolfi-python-3.10:latest...

Organization:      fjolsvin
Package manager:   apk
Target file:       Dockerfile
Project name:      docker-image|fjolsvin/wolfi-python-3.10
Docker image:      fjolsvin/wolfi-python-3.10:latest
Platform:          linux/amd64
Base image:        cgr.dev/chainguard/python:latest-dev
Licenses:          enabled

✔ Tested 75 dependencies for known issues, no vulnerable paths found.

Currently, we only offer base image recommendations for Official Docker images

-------------------------------------------------------

Testing fjolsvin/wolfi-python-3.10:latest...

Organization:      fjolsvin
Package manager:   pip
Target file:       /home/nonroot/.pyenv/plugins/python-build/scripts/requirements.txt
Project name:      /home/nonroot/.pyenv/plugins/python-build/scripts/requirements.txt
Docker image:      fjolsvin/wolfi-python-3.10:latest
Licenses:          enabled

✔ Tested fjolsvin/wolfi-python-3.10:latest for known issues, no vulnerable paths found.


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
