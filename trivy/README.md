# Trivy

## Overview

This image builds and packages Aquasecurity `Trivy` . It is presented here to
demonstrate how to securely build and package a typical Go application in a
zero CVE vulnerability Docker image pipeline.

- Ensuring a completely static build without depending on `CGO` runtime
- Compressing the binary
- Using `scratch` as the final layer of the image for minimal size and maximal
  security

## vulnerability Scan

```console
λ snyk container test --file="Dockerfile" "trivy:latest"

Testing trivy:latest...

Organization:      REDACTED
Package manager:   linux
Target file:       Dockerfile
Project name:      docker-image|trivy
Docker image:      trivy:latest
Platform:          linux/amd64
Base image:        scratch
Licenses:          enabled

✔ Tested trivy:latest for known issues, no vulnerable paths found.

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
snyk container test --file="Dockerfile" "trivy:latest"
```
