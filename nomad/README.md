# Nomad

## Overview

This image builds and packs Hashicorp's `Nomad`. It is presented here to
demonstrate a slightly more complex build and packaging pipeline for a certain
set of Go applications that need more customization of Linker flags during the
build. Needless to say, the final layer is one without any vulnerabilities

- Demonstrates how to speed up builds using Buildkit's `cache` mounts
- Customize linker flags and usage of build tags ( in this case, to disable
  `nvidia` GPU support as it relies on `CGO`, which can prevent a fully
  statically linked binary )
- Demonstrate how to select the latest release tag for building a package
  instead of the default latest commit hash

> Keep in mind that building Nomad Enterprise is a bit more challenging as it
> seems to depend on a Consul Enterprise library that was not resolvable.

## vulnerability Scan

```console
λ snyk container test --file="Dockerfile" "nomad:latest"

Testing nomad:latest...

Organization:      REDACTED
Package manager:   linux
Target file:       Dockerfile
Project name:      docker-image|nomad
Docker image:      nomad:latest
Platform:          linux/amd64
Base image:        "scratch"
Licenses:          enabled

✔ Tested nomad:latest for known issues, no vulnerable paths found.

Invalid base image name
Note that we do not currently have vulnerability data for your image.
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

- Build the image without pushing it to the remote

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
snyk container test --file="Dockerfile" "nomad:latest"
```
