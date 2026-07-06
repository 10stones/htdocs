#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  GITHUB_REPOSITORY=owner/repo scripts/configure-github.sh

Required tools:
  - gh CLI authenticated with repo/admin permissions
  - git

Optional environment variables:
  PRODUCTION_URL=https://zaneshi.com
  BETA_URL=https://beta.zaneshi.com

This script creates the dev branch if missing and configures GitHub Environments
for beta and production. Add deployment secrets with the gh commands printed at
the end; never paste private keys into chat or commit them to the repository.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

command -v gh >/dev/null 2>&1 || { echo "gh CLI is required. Install: https://cli.github.com/" >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "git is required." >&2; exit 1; }

REPO="${GITHUB_REPOSITORY:-}"
if [[ -z "$REPO" ]]; then
  REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || true)
fi
[[ -n "$REPO" ]] || { echo "Unable to determine repository. Set GITHUB_REPOSITORY=owner/repo." >&2; exit 1; }

PRODUCTION_URL="${PRODUCTION_URL:-https://zaneshi.com}"
BETA_URL="${BETA_URL:-https://beta.zaneshi.com}"

echo "Configuring repository: $REPO"

# Ensure dev branch exists on origin. main is expected to already exist.
if ! git ls-remote --exit-code --heads origin dev >/dev/null 2>&1; then
  echo "Creating origin/dev from current HEAD"
  git push origin HEAD:dev
else
  echo "origin/dev already exists"
fi

# Configure environments used by .github/workflows/deploy.yml.
gh api --method PUT "repos/$REPO/environments/beta" \
  -f deployment_branch_policy[protected_branches]=false \
  -f deployment_branch_policy[custom_branch_policies]=true >/dev/null
gh api --method POST "repos/$REPO/environments/beta/deployment-branch-policies" \
  -f name=dev >/dev/null 2>&1 || true
gh api --method PATCH "repos/$REPO/environments/beta" -f environment_url="$BETA_URL" >/dev/null || true

gh api --method PUT "repos/$REPO/environments/production" \
  -f deployment_branch_policy[protected_branches]=false \
  -f deployment_branch_policy[custom_branch_policies]=true >/dev/null
gh api --method POST "repos/$REPO/environments/production/deployment-branch-policies" \
  -f name=main >/dev/null 2>&1 || true
gh api --method PATCH "repos/$REPO/environments/production" -f environment_url="$PRODUCTION_URL" >/dev/null || true

cat <<EOF

Done. Now add repository or environment secrets locally with:

  gh secret set SERVER_HOST --repo "$REPO"
  gh secret set SERVER_USER --repo "$REPO"
  gh secret set SERVER_PORT --repo "$REPO"
  gh secret set SERVER_PATH --repo "$REPO"
  gh secret set SSH_PRIVATE_KEY --repo "$REPO" < ~/.ssh/zaneshi_deploy

Recommended branch protection can be enabled in GitHub UI after the first CI run.
EOF
