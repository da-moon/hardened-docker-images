# hardened-docker-images

## Overview

This repository is presented as a set of Docker images with hardened security
settings. The purpose of this repo is to act as a reference guide to
demonstrate different patterns for creating images with **zero** CVE
vulnerabilities.

## Images

### Python

- [`wolfi-python-3.10`](./docker/wolfi-python-3.10/README.md): Demonstrate how
  to make a docker image while pinning the python version to a specific value
  while maintaining zero CVE vulnerabilities
- [`lmanage`](./docker/lmanage/README.md): Demonstrate how to use `Poetry` to
  package a Python application that depends on a **specific** python version as
  a single `pex` executable while maintaining zero CVE vulnerabilities
