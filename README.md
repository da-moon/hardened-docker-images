# hardened-docker-images

- [hardened-docker-images](#hardened-docker-images)
  - [Overview](#overview)
  - [Images](#images)
    - [Python](#python)
    - [Powershell](#powershell)

## Overview

This repository is a set of Docker images with hardened security settings. The
purpose of this repo is to act as a reference guide to demonstrate different
patterns for creating images with **zero** CVE vulnerabilities.

## Images

### Python

- [`python-base-hardened`](./python-base-hardened/README.md): Demonstrate how
  to make a docker image while pinning the python version to a specific value
  while maintaining zero CVE vulnerabilities
- [`lmanage`](./lmanage/README.md): Demonstrate how to use `Poetry` to package
  a Python application that depends on a **specific** python version as a
  single `pex` executable while maintaining zero CVE vulnerabilities

### Powershell

- [`powershell-base-hardened`](./powershell-base-hardened/README.md): example
  hardened Powershell image with zero CVE vulnerabilities. This image can be
  used base layer for other images that rely on PowerShell modules (e.g
  VMWare's `PowerCLI`)
