# powercli

## Overview

This image builds and packs VMWare's `PowerCLI` on top of `Chainguard`'s Zero
CVE vulnerability `cgr.dev/chainguard/powershell:latest` base image.

The challenge with using `cgr.dev/chainguard/powershell:latest` base layer is
that it does not include specific core PowerShell cmdlets; e.g `PowerShellGet`
module which comes with `Install-Module` cmdlet. An approach to addressing this
problem is provided in
[`powershell-base-hardened`](../powershell-base-hardened/README.md) image.

The image here provides an alternative approach in case you are not able to use
the pattern demonstrated in
[`powershell-base-hardened`](../powershell-base-hardened/README.md).

In this pattern, I am using `Powershell Gallery's` API to grab the `nupkg` file
and install it directly.

Keep in mind that the base image only comes with `Powershell` as shell and does
**NOT** have `root` user so all instructions are written in native Powershell.

## vulnerability Scan

```console
λ snyk container test --file="Dockerfile" "powercli:latest"

Testing powercli:latest...

Organization:      REDACTED
Package manager:   apk
Target file:       Dockerfile
Project name:      docker-image|powercli
Docker image:      powercli:latest
Platform:          linux/amd64
Base image:        cgr.dev/chainguard/powershell:latest
Licenses:          enabled

✔ Tested 22 dependencies for known issues, no vulnerable paths found.

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
snyk container test --file="Dockerfile" "powercli:latest"
```
