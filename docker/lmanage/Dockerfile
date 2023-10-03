# syntax = docker/dockerfile:labs
# vim: filetype=dockerfile softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# ────────────────────────────────────────────────────────────────────────────────

# ────────────────────────────────────────────────────────────────────────────────
FROM cgr.dev/chainguard/python:latest-dev as builder
WORKDIR "/home/nonroot"
ENV PATH="${PATH}:/home/nonroot/.local/bin"
RUN \
  python3 -m pip install --no-cache-dir "lmanage >= 0.3" \
  && lmanage --version
# hadolint ignore=DL3007
FROM cgr.dev/chainguard/python:latest
USER nonroot
VOLUME "/workspace"
WORKDIR "/workspace"
ARG UID="${UID:-1000}"
ARG GID="${GID:-1000}"
COPY --from=builder "/home/nonroot/.local/lib/python3.11/site-packages" "/usr/lib/python3.11/site-packages"

COPY --chown="${UID}:${GID}" --from=builder "/home/nonroot/" "/home/nonroot/"
COPY --chmod=0755 --from=builder "/home/nonroot/.local/bin/lmanage" "/usr/local/bin/lmanage"


ARG LOOKERSDK_BASE_URL="${LOOKERSDK_BASE_URL}"
ENV LOOKERSDK_BASE_URL="${LOOKERSDK_BASE_URL}"

ARG LOOKERSDK_VERIFY_SSL="${LOOKERSDK_VERIFY_SSL:-true}"
ENV LOOKERSDK_VERIFY_SSL "${LOOKERSDK_VERIFY_SSL}"

ARG LOOKERSDK_TIMEOUT="${LOOKERSDK_TIMEOUT:-120}"
ENV LOOKERSDK_TIMEOUT "${LOOKERSDK_TIMEOUT}"

ENTRYPOINT [ "python", "/usr/local/bin/lmanage" ]
