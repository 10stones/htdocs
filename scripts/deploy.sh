#!/usr/bin/env bash
set -euo pipefail

APP_DIR="${SERVER_PATH:-/var/www/zaneshi}"
RELEASES_DIR="$APP_DIR/releases"
SHARED_DIR="$APP_DIR/shared"
CURRENT_LINK="$APP_DIR/current"
RELEASE_ID="${GITHUB_SHA:-$(date +%Y%m%d%H%M%S)}"
RELEASE_DIR="$RELEASES_DIR/$RELEASE_ID"

echo "Creating release $RELEASE_ID in $RELEASE_DIR"
mkdir -p "$RELEASE_DIR" "$SHARED_DIR" "$RELEASES_DIR"
tar -xzf /tmp/zaneshi-release.tar.gz -C "$RELEASE_DIR"
ln -sfn "$RELEASE_DIR" "$CURRENT_LINK"
cd "$CURRENT_LINK"
npm install --omit=dev
pm2 describe zaneshi >/dev/null 2>&1 && pm2 reload zaneshi || pm2 start server.js --name zaneshi --cwd "$CURRENT_LINK"
pm2 save
sudo nginx -t
sudo systemctl reload nginx
ls -1dt "$RELEASES_DIR"/* | tail -n +6 | xargs -r rm -rf
