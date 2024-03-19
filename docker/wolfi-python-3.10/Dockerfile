# syntax=docker/dockerfile-upstream:master-labs
# vim: filetype=dockerfile softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# ────────────────────────────────────────────────────────────────────────────────
# https://github.com/chaimleib/intervaltree/blob/master/Dockerfile
FROM cgr.dev/chainguard/python:latest-dev AS base
USER root
ENV PYENV_ROOT="/opt/pyenv"
ENV PYENV_SHELL="bash"
ENV PATH="${PYENV_ROOT}/bin:${PATH}"
ENV PATH="${PYENV_ROOT}/shims:${PATH}"
SHELL ["/bin/ash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3018
RUN \
apk add --no-cache \
  build-base \
  bzip2 \
  ca-certificates \
  curl \
  expat \
  git \
  libffi \
  mpdecimal \
  openssl \
  readline \
  sqlite-libs \
  tk \
  xz \
  zlib \
&& chown -R "nonroot:nonroot" "$(dirname "${PYENV_ROOT}")" ;
USER nonroot
RUN \
curl -fSsL "https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer" | bash \
&& pyenv update ;
FROM base AS builder
USER root
# hadolint ignore=DL3018
RUN  \
apk add --no-cache \
  findutils \
  bzip2-dev \
  libffi-dev \
  ncurses-dev \
  openssl-dev \
  readline-dev \
  sqlite-dev \
  tk-dev \
  xz-dev \
  zlib-dev ;
USER nonroot
ARG PYENV_VERSION="3.10"
RUN pyenv install --verbose "${PYENV_VERSION}" ;
# hadolint ignore=DL3059
RUN \
  find "${PYENV_ROOT}/versions" -depth \
  \( \
    \( \
      -type d \
      -a \( -name test -o -name tests -o -name idle_test \) \
    \) \
  -o \
    \( -type f -a -name 'wininst-*.exe' \) \
  \) -exec rm -rf '{}' + ;
FROM base
COPY --from=builder --chown=nonroot:nonroot "${PYENV_ROOT}/versions" "${PYENV_ROOT}/versions"
USER nonroot
ENV HOME="/home/nonroot"
ENV PATH="${PATH}:${HOME}/.local/bin"
RUN \
pyenv global "${PYENV_VERSION}" \
&& pyenv rehash \
&& python3 --version > /dev/null 2>&1
