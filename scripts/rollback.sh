#!/usr/bin/env bash
set -euo pipefail

cat >&2 <<'MSG'
Rollback is handled by redeploying a known-good commit through GitHub Actions.
Production deploys are static exports uploaded to Baidu BOS from main.
MSG
exit 1
