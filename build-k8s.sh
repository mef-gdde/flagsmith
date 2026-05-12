#!/usr/bin/env bash
set -euo pipefail

REGISTRY=${REGISTRY:-}
TAG=${TAG:-latest}
PUBLIC_PATH=${PUBLIC_PATH:-/flags/static/}
PLATFORM=${PLATFORM:-linux/amd64,linux/arm64}
LOAD_OR_PUSH=${1:-}

# Prefix image name with registry if provided
api_image="${REGISTRY:+${REGISTRY}/}flagsmith-api:${TAG}"
frontend_image="${REGISTRY:+${REGISTRY}/}flagsmith-frontend:${TAG}"

# Default to --load for local builds; use --push when a registry is set
if [ -z "${LOAD_OR_PUSH}" ]; then
  if [ -n "${REGISTRY}" ]; then
    LOAD_OR_PUSH="--push"
  else
    LOAD_OR_PUSH="--load"
  fi
fi

echo "Building API image: ${api_image}"
docker buildx build \
  --platform "${PLATFORM}" \
  --target oss-api \
  -t "${api_image}" \
  ${LOAD_OR_PUSH} .

echo "Building frontend image: ${frontend_image}"
docker buildx build \
  --platform "${PLATFORM}" \
  --target oss-frontend \
  --build-arg PUBLIC_PATH="${PUBLIC_PATH}" \
  -t "${frontend_image}" \
  ${LOAD_OR_PUSH} .

echo "Done."
echo "  API:      ${api_image}"
echo "  Frontend: ${frontend_image}"
