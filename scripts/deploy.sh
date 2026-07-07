#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DIST_DIR="${DIST_DIR:-${OUT_DIR:-$ROOT_DIR/apps/web/out}}"

python "$ROOT_DIR/scripts/upload_bos.py"
