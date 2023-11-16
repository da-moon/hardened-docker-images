#!/usr/bin/env bash
set -xefuo pipefail
# ────────────────────────────────────────────────────────────
IMAGE_NAME="$(basename "$(git rev-parse --show-prefix)")"
export IMAGE_NAME
# ────────────────────────────────────────────────────────────
# docker buildx rm --force  --all-inactive
BUILDER="$(basename -s.git "$(git remote get-url origin)")"
! docker buildx inspect "${BUILDER}" 2>/dev/null && docker buildx create --bootstrap --name "${BUILDER}" --driver "docker-container"
docker buildx use "${BUILDER}"
docker buildx bake
