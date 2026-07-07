#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  GITHUB_REPOSITORY=owner/repo scripts/configure-github.sh

Required tools:
  - gh CLI authenticated with repo/admin permissions

Optional environment variables:
  PRODUCTION_URL=https://h5.zaneshi.com

This script configures the production GitHub Environment for deployments from
main. Add BOS deployment secrets with the gh commands printed at the end.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

command -v gh >/dev/null 2>&1 || { echo "gh CLI is required. Install: https://cli.github.com/" >&2; exit 1; }

REPO="${GITHUB_REPOSITORY:-}"
if [[ -z "$REPO" ]]; then
  REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || true)
fi
[[ -n "$REPO" ]] || { echo "Unable to determine repository. Set GITHUB_REPOSITORY=owner/repo." >&2; exit 1; }

PRODUCTION_URL="${PRODUCTION_URL:-https://h5.zaneshi.com}"

echo "Configuring production deployment environment for $REPO"

gh api --method PUT "repos/$REPO/environments/production" \
  -f deployment_branch_policy[protected_branches]=false \
  -f deployment_branch_policy[custom_branch_policies]=true >/dev/null

gh api --method POST "repos/$REPO/environments/production/deployment-branch-policies" \
  -f name=main >/dev/null 2>&1 || true

gh api --method PATCH "repos/$REPO/environments/production" -f environment_url="$PRODUCTION_URL" >/dev/null || true

cat <<EOF

Done. Now add repository or environment secrets locally with:

  gh secret set BCE_ACCESS_KEY --repo "$REPO"
  gh secret set BCE_SECRET_KEY --repo "$REPO"
  gh secret set BOS_BUCKET --repo "$REPO"
  gh secret set BOS_ENDPOINT --repo "$REPO"

Production deployments run from main through GitHub Actions.

EOF
