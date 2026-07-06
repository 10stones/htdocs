# htdocs H5 Platform

This repository is the production H5 platform for `h5.zaneshi.com`.

Production branch: `main` only.

## Deployment model

```text
Feature branch
  -> Pull Request
  -> Review
  -> Merge into main
  -> GitHub Actions
  -> Static Next.js export
  -> Baidu BOS
  -> CDN
```

## Stack

- Next.js App Router
- React
- TypeScript
- Tailwind CSS
- ESLint
- Prettier
- GitHub Actions
- Baidu Cloud BOS

## Commands

```bash
npm install
npm run dev
npm run lint
npm run build
npm run format
```

## Production deployment

The workflow `.github/workflows/deploy.yml` deploys on:

- push to `main`
- manual `workflow_dispatch`

Required GitHub Secrets:

- `BCE_ACCESS_KEY`
- `BCE_SECRET_KEY`
- `BOS_BUCKET`
- `BOS_ENDPOINT`

See `docs/deployment.md` for details.

## Future H5 sections

- `travel`
- `career`
- `tutorial`
- `client`
- `life`
- `ai`
- `tools`
