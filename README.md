# hardened-docker-images

- [hardened-docker-images](#hardened-docker-images)
  - [Overview](#overview)
  - [Images](#images)
    - [Python](#python)
    - [Powershell](#powershell)
    - [Go](#go)

## Overview

This repository is a set of Docker images with hardened security settings. The
purpose of this repo is to act as a reference guide to demonstrate different
patterns for creating images with **zero** CVE vulnerabilities.

These images were developed and tested on a Linux host. The build scripts may
not work on non-linux systems

```console
λ neofetch --stdout

damoon@archlinux
----------------
OS: Arch Linux x86_64
Host: XPS 13 9300
Kernel: 6.7.9-arch1-1
Uptime: 1 hour, 6 mins
Packages: 1858 (pacman)
Shell: bash 5.2.26
Resolution: 1920x1200
DE: Regolith
WM: i3
Terminal: vscode
CPU: Intel i7-1065G7 (8) @ 3.900GHz
GPU: Intel Iris Plus Graphics G7
Memory: 5581MiB / 15578MiB

λ docker info --format 'json' | jq -r '{ServerVersion: .ServerVersion,ClientInfo: .ClientInfo}'

{
  "ServerVersion": "25.0.4",
  "ClientInfo": {
    "Debug": false,
    "Version": "25.0.4",
    "GitCommit": "1a576c50a9",
    "GoVersion": "go1.22.1",
    "Os": "linux",
    "Arch": "amd64",
    "BuildTime": "Wed Mar 13 15:44:41 2024",
    "Context": "default",
    "Plugins": [
      {
        "SchemaVersion": "0.1.0",
        "Vendor": "Docker Inc.",
        "Version": "0.13.1",
        "ShortDescription": "Docker Buildx",
        "Name": "buildx",
        "Path": "/usr/lib/docker/cli-plugins/docker-buildx"
      },
      {
        "SchemaVersion": "0.1.0",
        "Vendor": "Docker Inc.",
        "Version": "2.24.7",
        "ShortDescription": "Docker Compose",
        "Name": "compose",
        "Path": "/usr/lib/docker/cli-plugins/docker-compose"
      },
      {
        "SchemaVersion": "0.1.0",
        "Vendor": "Anchore Inc.",
        "Version": "[not provided]",
        "ShortDescription": "View the packaged-based Software Bill Of Materials (SBOM) for an image",
        "URL": "https://github.com/docker/sbom-cli-plugin",
        "Name": "sbom",
        "Path": "/home/damoon/.docker/cli-plugins/docker-sbom"
      }
    ],
    "Warnings": null
  }
}
```

## Images

### Python

- [`python-base-hardened`](./python-base-hardened/README.md): Demonstrate how
  to make a docker image while pinning the python version to a specific value
  while maintaining zero CVE vulnerabilities
- [`lmanage`](./lmanage/README.md): Demonstrate how to use `Poetry` to package
  a Python application that depends on a **specific** python version as a
  single `pex` executable while maintaining zero CVE vulnerabilities
- [`checkov`](./checkov/README.md): Demonstrate how to package general pip
  applications in a hardened base layer that does not contain any shells (e.g
  `bash`) other than `python` interpreter.

### Powershell

- [`powershell-base-hardened`](./powershell-base-hardened/README.md): example
  hardened Powershell image with zero CVE vulnerabilities. This image can be
  used base layer for other images that rely on PowerShell modules
- [`powercli`](./powercli/README.md): example hardened Powershell image that
  includes VMWare's `PowerCLI`. Here, I am presenting an alternative pattern
  for directly installing Powershell modules from `nupkg` files

### Go

- [`trivy`](./trivy/README.md): demonstrates a secure typical Go application
  build, compress and package pipeline that creates a minimal compressed binary
  , packaged in `scratch` final layer to ensure safety and security of runtime.
- [`nomad`](./nomad/README.md): demonstrates a more complicated build pipeline
  that is required for a minority of Go applications; in most cases following
  the pattern in [`trivy`](./trivy/README.md) should be enough
