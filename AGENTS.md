# AGENTS.md

## Repository rules
- Production is always deployed from `main`.
- Do not add compatibility paths for other production branches.
- Never hardcode credentials, access keys, bucket credentials, or deployment tokens.
- Keep deployment changes small, auditable, and documented.

## Development workflow

```text
Codex
↓
Feature Branch
↓
Pull Request
↓
Review
↓
Merge into main
↓
GitHub Actions
↓
Baidu BOS
↓
CDN
```

## Coding conventions
- Use Next.js App Router, React, TypeScript, Tailwind CSS, ESLint, and Prettier.
- Prefer server components unless client-side interactivity is required.
- Do not wrap imports in `try/catch` blocks.
- Run `npm run lint` and `npm run build` before merging when dependencies are available.

## Deployment rules
- GitHub Actions deploys production from `main` only.
- The deployment target is Baidu Cloud BOS, with CDN in front when the domain is ready.
- Required GitHub Secrets are `BCE_ACCESS_KEY`, `BCE_SECRET_KEY`, `BOS_BUCKET`, and `BOS_ENDPOINT`.
- `scripts/deploy.sh` must fail fast when required secrets or static export files are missing.
- HTML must use no-cache headers; hashed `_next` assets must use long-lived immutable cache headers.

## Future H5 platform sections
Keep future top-level H5 content organized around these sections:

- `travel`
- `career`
- `tutorial`
- `client`
- `life`
- `ai`
- `tools`

Do not add new top-level content sections without updating documentation and navigation intentionally.
