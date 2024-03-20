#!/usr/bin/env bash
set -xefuo pipefail
if [[ $(docker buildx version >/dev/null 2>&1) ]]; then
  echo >&2 "docker buildx is not installed"
  exit 1
fi
if [[ $(docker sbom version >/dev/null 2>&1) ]]; then
  echo >&2 "docker sbom is not installed"
  exit 1
fi
WD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "${WD}" >/dev/null 2>&1
# ────────────────────────────────────────────────────────────
BUILDKIT_PROGRESS="${BUILDKIT_PROGRESS:-"plain"}"
export BUILDKIT_PROGRESS

LOCAL="${LOCAL:-"true"}"
export LOCAL

IMAGE_NAME="${IMAGE_NAME:-$(basename "$(git rev-parse --show-prefix)")}"
export IMAGE_NAME
# ────────────────────────────────────────────────────────────
# docker buildx rm --force  --all-inactive
BUILDER="$(basename -s.git "$(git remote get-url origin)")"
! docker buildx inspect "${BUILDER}" 2>/dev/null && docker buildx create --bootstrap --name "${BUILDER}" --driver "docker-container"
docker buildx use "${BUILDER}"
docker buildx bake
docker sbom --format "spdx-json" --output "${IMAGE_NAME}.spdx.json" "${IMAGE_NAME}"
popd >/dev/null 2>&1
