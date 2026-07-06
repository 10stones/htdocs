#!/usr/bin/env bash
set -euo pipefail
APP_DIR="${SERVER_PATH:-/var/www/zaneshi}"
RELEASES_DIR="$APP_DIR/releases"
TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  TARGET=$(ls -1dt "$RELEASES_DIR"/* | sed -n '2p')
fi
[[ -d "$TARGET" ]] || { echo "Release not found: $TARGET"; exit 1; }
ln -sfn "$TARGET" "$APP_DIR/current"
pm2 reload zaneshi
sudo nginx -t && sudo systemctl reload nginx
echo "Rolled back to $TARGET"
