# syntax = docker/dockerfile:labs
# vim: filetype=dockerfile softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# ────────────────────────────────────────────────────────────────────────────────

# hadolint ignore=DL3007
FROM cgr.dev/chainguard/go:latest-dev AS builder
SHELL ["/bin/ash", "-o", "pipefail", "-c"]
USER "root"
# hadolint ignore=DL3018
RUN \
  # NOTE: installing build dependencies
  apk add --no-cache \
  "build-base" \
  "make" \
  "git" \
  "upx" \
  # NOTE: creating /etc/passwd file to move to next stage (scratch image)
  && echo "nobody:x:65534:65534:Nobody:/:" > "/etc_passwd" ;

USER "nonroot"
WORKDIR "/go/src/github.com/aquasecurity"
RUN \
  # NOTE: ensuring that binary is statically linked without depending on CGO
  go env -w "GO111MODULE=on" \
  && go env -w "CGO_ENABLED=0" \
  && go env -w "CGO_LDFLAGS=-s -w -extldflags '-static'" \
  # NOTE: pulling the codebase
  && git clone \
    "https://github.com/aquasecurity/trivy.git" \
    "/go/src/github.com/aquasecurity/trivy"
WORKDIR "/go/src/github.com/aquasecurity/trivy"
RUN \
  # NOTE: building the binary
  go build -o "/go/bin/trivy" "./cmd/trivy" \
  # NOTE: compressing the binary
  && strip "/go/bin/trivy" \
  && upx "/go/bin/trivy"

FROM scratch
COPY --from=builder "/etc/ssl/certs/ca-certificates.crt" "/etc/ssl/certs/"
COPY --from=builder "/etc_passwd" "/etc/passwd"
COPY --chmod=0755 --chown=65534:0 --from=builder "/go/bin/trivy" "/entrypoint"
USER "nobody"
ENTRYPOINT ["/entrypoint"]
