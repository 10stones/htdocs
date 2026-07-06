# zaneshi.com H5 Platform

Production branch: `main`.

This repository contains the personal H5 platform for future pages such as travel plans, career tutorials, client presentations, life content, AI demos, and tools. The production site is built as a static Next.js export and deployed to Baidu Cloud BOS by GitHub Actions.

## Tech stack

- Next.js App Router + TypeScript
- React + Tailwind CSS + shadcn/ui + lucide-react
- ESLint + Prettier + Husky + lint-staged + commitlint
- GitHub Actions + Baidu Cloud BOS + future CDN

## Branch strategy

```text
Feature Branch -> Pull Request -> Review -> Merge into main -> GitHub Actions -> Baidu BOS -> CDN
```

Production is always deployed from `main`.

## Directory overview

```text
src/app                App Router pages
src/components         Shared components and UI primitives
src/lib                Site configuration, utilities, and shared helpers
src/styles             Global styles
content                Future structured content source
scripts                Deployment and repository automation
docs                   Deployment and collaboration documentation
.github/workflows      GitHub Actions workflows
```

## Future top-level H5 sections

- `travel`
- `career`
- `tutorial`
- `client`
- `life`
- `ai`
- `tools`

## Development commands

```bash
npm install
npm run dev
npm run lint
npm run build
npm run format
```

CI uses `npm ci`; commit `package-lock.json` once dependency installation is available in the development environment.

## Deployment

Pushes to `main` and manual workflow runs deploy production to Baidu BOS.

Required GitHub Secrets:

- `BCE_ACCESS_KEY`
- `BCE_SECRET_KEY`
- `BOS_BUCKET`
- `BOS_ENDPOINT`

See `docs/deployment.md` for the complete deployment guide.
