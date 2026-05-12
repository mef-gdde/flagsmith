#!/usr/bin/env bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg PUBLIC_PATH=${PUBLIC_PATH:-/flags/static/} \
  -t ${IMAGE_NAME:-flagsmith:latest} \
  --load .