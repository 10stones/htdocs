#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEB_DIR="$ROOT_DIR/apps/web"
OUT_DIR="${OUT_DIR:-$WEB_DIR/out}"
BOS_BUCKET="${BOS_BUCKET:-zaneshi-h5-prod}"
BOS_ENDPOINT="${BOS_ENDPOINT:-}"
BOS_PREFIX="${BOS_PREFIX:-}"

require() {
  if [[ -z "${!1:-}" ]]; then
    echo "Missing required environment variable: $1" >&2
    exit 1
  fi
}

require BCE_ACCESS_KEY
require BCE_SECRET_KEY
require BOS_BUCKET
require BOS_ENDPOINT

if [[ ! -d "$OUT_DIR" ]]; then
  echo "Build output not found at $OUT_DIR. Run npm run build first." >&2
  exit 1
fi

if ! command -v bcecmd >/dev/null 2>&1; then
  echo "bcecmd is not installed. Install the BOSCMD binary from Baidu Cloud docs before deploying." >&2
  exit 1
fi

CONF_PATH="${BCECMD_CONF_PATH:-$ROOT_DIR/.bcecmd.conf}"
BOS_REGION="${BOS_REGION:-bj}"
BOS_HOST="${BOS_ENDPOINT#https://}"
BOS_HOST="${BOS_HOST#http://}"

printf "%s\n\n%s\n%s\n%s\n\n\n\n" "$BCE_ACCESS_KEY" "$BCE_SECRET_KEY" "$BOS_REGION" "$BOS_HOST" | bcecmd -c "$CONF_PATH" >/dev/null

REMOTE="bos://$BOS_BUCKET"
if [[ -n "$BOS_PREFIX" ]]; then
  REMOTE="$REMOTE/${BOS_PREFIX#/}"
fi

CACHE_HTML="no-cache, no-store, must-revalidate"
CACHE_ASSETS="public, max-age=31536000, immutable"
CACHE_STATIC="public, max-age=3600"

echo "Deploying $OUT_DIR to $REMOTE via $BOS_ENDPOINT"

echo "Removing existing BOS objects..."
bcecmd bos rm "$REMOTE" -r -y --conf-path "$CONF_PATH" || true

echo "Uploading static assets with long-lived cache headers..."
if [[ -d "$OUT_DIR/_next" ]]; then
  bcecmd bos cp "$OUT_DIR/_next" "$REMOTE/_next" -r -y --cache-control "$CACHE_ASSETS" --conf-path "$CONF_PATH"
fi

echo "Uploading public assets with standard cache headers..."
find "$OUT_DIR" -mindepth 1 -maxdepth 1 ! -name '_next' ! -name '*.html' -print0 | while IFS= read -r -d '' path; do
  name="$(basename "$path")"
  if [[ -d "$path" ]]; then
    bcecmd bos cp "$path" "$REMOTE/$name" -r -y --cache-control "$CACHE_STATIC" --conf-path "$CONF_PATH"
  elif [[ "$name" != "index.txt" ]]; then
    bcecmd bos cp "$path" "$REMOTE/$name" -y --cache-control "$CACHE_STATIC" --conf-path "$CONF_PATH"
  fi
done

echo "Uploading HTML with no-cache headers..."
find "$OUT_DIR" -name '*.html' -type f -print0 | while IFS= read -r -d '' file; do
  rel="${file#$OUT_DIR/}"
  bcecmd bos cp "$file" "$REMOTE/$rel" -y --cache-control "$CACHE_HTML" --conf-path "$CONF_PATH"
done

echo "Deployment complete. Ensure BOS static website index is set to index.html."
