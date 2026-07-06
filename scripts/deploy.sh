#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[deploy] %s\n' "$*"
}

fail() {
  printf '[deploy] ERROR: %s\n' "$*" >&2
  exit 1
}

require() {
  if [[ -z "${!1:-}" ]]; then
    fail "Missing required environment variable: $1"
  fi
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/out}"
BOS_BUCKET="${BOS_BUCKET:-}"
BOS_ENDPOINT="${BOS_ENDPOINT:-}"
BOS_PREFIX="${BOS_PREFIX:-}"
BOS_REGION="${BOS_REGION:-bj}"
CONF_PATH="${BCECMD_CONF_PATH:-$ROOT_DIR/.bcecmd.conf}"

require BCE_ACCESS_KEY
require BCE_SECRET_KEY
require BOS_BUCKET
require BOS_ENDPOINT

[[ -d "$OUT_DIR" ]] || fail "Build output not found at $OUT_DIR. Run npm run build first."
[[ -f "$OUT_DIR/index.html" ]] || fail "Static export is missing index.html in $OUT_DIR."
[[ -d "$OUT_DIR/_next" ]] || fail "Static export is missing _next assets in $OUT_DIR."
command -v bcecmd >/dev/null 2>&1 || fail "bcecmd is not installed. Install with: python -m pip install bcecmd"

BOS_HOST="${BOS_ENDPOINT#https://}"
BOS_HOST="${BOS_HOST#http://}"
BOS_HOST="${BOS_HOST%/}"
[[ -n "$BOS_HOST" ]] || fail "BOS_ENDPOINT must include a host."

printf "%s\n\n%s\n%s\n%s\n\n\n\n" "$BCE_ACCESS_KEY" "$BCE_SECRET_KEY" "$BOS_REGION" "$BOS_HOST" | bcecmd -c "$CONF_PATH" >/dev/null

REMOTE="bos://$BOS_BUCKET"
if [[ -n "$BOS_PREFIX" ]]; then
  BOS_PREFIX="${BOS_PREFIX#/}"
  BOS_PREFIX="${BOS_PREFIX%/}"
  [[ -n "$BOS_PREFIX" ]] || fail "BOS_PREFIX resolved to an empty path."
  REMOTE="$REMOTE/$BOS_PREFIX"
fi

CACHE_HTML="no-cache, no-store, must-revalidate"
CACHE_ASSETS="public, max-age=31536000, immutable"
CACHE_STATIC="public, max-age=3600"

html_count="$(find "$OUT_DIR" -type f -name '*.html' | wc -l | tr -d ' ')"
asset_count="$(find "$OUT_DIR/_next" -type f | wc -l | tr -d ' ')"
file_count="$(find "$OUT_DIR" -type f | wc -l | tr -d ' ')"

log "Deploying production static export from $OUT_DIR"
log "Target: $REMOTE ($BOS_ENDPOINT)"
log "Files: $file_count total, $html_count HTML, $asset_count Next.js assets"

log "Cleaning existing BOS objects under $REMOTE"
bcecmd bos rm "$REMOTE" -r -y --conf-path "$CONF_PATH"

log "Uploading immutable Next.js assets"
bcecmd bos cp "$OUT_DIR/_next" "$REMOTE/_next" -r -y --cache-control "$CACHE_ASSETS" --conf-path "$CONF_PATH"

log "Uploading non-HTML public/static files"
find "$OUT_DIR" -mindepth 1 -maxdepth 1 ! -name '_next' ! -name '*.html' -print0 | while IFS= read -r -d '' path; do
  name="$(basename "$path")"
  if [[ -d "$path" ]]; then
    bcecmd bos cp "$path" "$REMOTE/$name" -r -y --cache-control "$CACHE_STATIC" --conf-path "$CONF_PATH"
  else
    bcecmd bos cp "$path" "$REMOTE/$name" -y --cache-control "$CACHE_STATIC" --conf-path "$CONF_PATH"
  fi
done

log "Uploading HTML files with no-cache headers"
find "$OUT_DIR" -name '*.html' -type f -print0 | while IFS= read -r -d '' file; do
  rel="${file#$OUT_DIR/}"
  bcecmd bos cp "$file" "$REMOTE/$rel" -y --cache-control "$CACHE_HTML" --conf-path "$CONF_PATH"
done

log "Deployment complete. Production is deployed from main. BOS index document must be index.html."
