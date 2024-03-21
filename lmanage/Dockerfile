# syntax=docker/dockerfile-upstream:master-labs
# vim: filetype=dockerfile softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# ────────────────────────────────────────────────────────────────────────────────
FROM cgr.dev/chainguard/python:latest-dev AS builder
USER "root"
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
&& apk add --no-cache \
  findutils \
  bzip2-dev \
  libffi-dev \
  ncurses-dev \
  openssl-dev \
  readline-dev \
  sqlite-dev \
  tk-dev \
  xz-dev \
  zlib-dev \
&& chown -R "nonroot:nonroot" "$(dirname "${PYENV_ROOT}")" ;
USER "nonroot"
ENV HOME="/home/nonroot"
ENV PATH="${PATH}:${HOME}/.local/bin"
WORKDIR "${HOME}/lmanage"
ARG PYENV_VERSION="3.10"
RUN \
curl -fSsL "https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer" | bash \
&& pyenv update \
&& pyenv install --verbose "${PYENV_VERSION}" \
&& find "${PYENV_ROOT}/versions" -depth \
  \( \
    \( \
      -type d \
      -a \( -name test -o -name tests -o -name idle_test \) \
    \) \
  -o \
    \( -type f -a -name 'wininst-*.exe' \) \
  \) -exec rm -rf '{}' + \
&& pyenv global "${PYENV_VERSION}" \
&& pyenv rehash \
&& python3 --version > /dev/null 2>&1 \
&& curl -sSL "https://install.python-poetry.org" | python3 - \
&& python3 -m pip install --no-cache-dir "pex==2.2.2" \
&& pyenv rehash \
&& git clone --bare "https://github.com/looker-open-source/lmanage.git" ".git" \
&& git config --local --bool "core.bare" "false" \
&& git reset --hard \
&& poetry install \
&& pex \
  --disable-cache \
  --compile \
  --venv \
  --jobs "$(nproc)" \
  --entry-point "lmanage.cli:lmanage" \
  --output-file "lmanage" \
  "." \
# NOTE: setting permissions with chmod here instead of Docker's `COPY --chmod`
# later
&& chmod "0755" ./lmanage \
&& ./lmanage --version \
&& cp -r "${PYENV_ROOT}/versions/${PYENV_VERSION}"* "${HOME}/pyenv"
# ──────────────────────────────────────────────────────────────────────────────
# hadolint ignore=DL3007
FROM "cgr.dev/chainguard/python:latest"
USER "nonroot"
VOLUME "/workspace"
WORKDIR "/workspace"

COPY --from=builder "/home/nonroot/pyenv/bin" "/usr/bin"
COPY --from=builder "/home/nonroot/pyenv/share" "/usr/share"
COPY --from=builder "/home/nonroot/pyenv/lib" "/usr/lib"
COPY --from=builder "/home/nonroot/pyenv/include" "/usr/include"
COPY --from=builder "/home/nonroot/lmanage/lmanage" "/usr/local/bin/lmanage"

ARG LOOKERSDK_BASE_URL="${LOOKERSDK_BASE_URL}"
ENV LOOKERSDK_BASE_URL="${LOOKERSDK_BASE_URL}"

ARG LOOKERSDK_VERIFY_SSL="${LOOKERSDK_VERIFY_SSL:-true}"
ENV LOOKERSDK_VERIFY_SSL "${LOOKERSDK_VERIFY_SSL}"

ARG LOOKERSDK_TIMEOUT="${LOOKERSDK_TIMEOUT:-120}"
ENV LOOKERSDK_TIMEOUT "${LOOKERSDK_TIMEOUT}"

ENTRYPOINT [ "python", "/usr/local/bin/lmanage" ]
