# AGENTS.md

## Primary branch

Production uses `main` only. Do not add compatibility with other production branches.

## Workflow

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

## Rules

- Never hardcode credentials.
- Keep deployment changes small and documented.
- Run lint/build before merge when dependencies are available.
- Use server components by default.
- Do not wrap imports in `try/catch` blocks.

## Deployment

- GitHub Actions deploys from `main` only.
- Required secrets: `BCE_ACCESS_KEY`, `BCE_SECRET_KEY`, `BOS_BUCKET`, `BOS_ENDPOINT`.
- HTML uses no-cache headers.
- Hashed `_next` assets use immutable cache headers.

## Future H5 sections

- `travel`
- `career`
- `tutorial`
- `client`
- `life`
- `ai`
- `tools`
