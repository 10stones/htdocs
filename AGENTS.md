# AGENTS.md

## Repository rules
- This repository is the long-term personal H5 platform for `https://h5.zaneshi.com`.
- Use Next.js App Router, React, TypeScript, Tailwind CSS, ESLint, and Prettier.
- Never hardcode credentials, bucket names that are meant to be secrets, access keys, or deployment tokens in application code.
- Keep changes small, reviewed, and production-oriented. Prefer reusable components and typed data models over page-specific duplication.
- Run `npm run lint` and `npm run build` before committing whenever dependencies are available.

## Coding conventions
- TypeScript is strict. Avoid `any`; model shared page data with explicit interfaces.
- Use server components by default. Add `"use client"` only when a page or component truly needs browser state, effects, or event handlers.
- Keep imports direct and simple. Do not wrap imports in `try/catch` blocks.
- Use the `@/components/*`, `@/lib/*`, and `@/styles/*` aliases.
- Format with Prettier and keep Tailwind classes readable and intentional.

## UI style
- H5 pages should be mobile-first, fast, accessible, and polished.
- Prefer clean editorial layouts, clear calls to action, strong spacing, and subtle motion.
- Maintain accessible color contrast and semantic HTML.
- Optimize public assets for static hosting and long-lived cache behavior.

## Directory rules
- `apps/web/app/`: Next.js App Router shell; keep public routes inside `apps/web/app/(site)/` route groups rather than a flat app directory.
- `components/`: shared UI and layout components used by one or more pages.
- `packages/core/src/`: reusable platform configuration, utilities, structured content models, data helpers, and typed constants.
- `public/`: static assets copied directly into the exported site.
- `styles/`: global styles and Tailwind CSS entry points.
- `docs/`: operator and developer documentation.
- `scripts/`: local and CI automation.
- `.github/workflows/`: GitHub Actions CI/CD workflows.

## Future page creation rules
- New H5 pages must live under one of these route groups unless there is a strong reason to introduce a new top-level section:
  - `apps/web/app/(site)/travel/`
  - `apps/web/app/(site)/career/`
  - `apps/web/app/(site)/tutorial/`
  - `apps/web/app/(site)/client/`
  - `apps/web/app/(site)/tools/`
- Each new production page should be backed by structured content in `packages/core/src/content/` where practical, then rendered by reusable page components. Route files should stay thin and mostly wire content to layouts.
- Interactive forms and demos should isolate client-side logic in focused client components.

## Deployment rules
- Production deploys target Baidu Cloud BOS bucket `zaneshi-h5-prod` in region `bj` through GitHub Actions.
- Required secrets are `BCE_ACCESS_KEY`, `BCE_SECRET_KEY`, `BOS_BUCKET`, and `BOS_ENDPOINT`.
- Deployment must build and export the static site, replace old HTML/static files in BOS, set no-cache headers for HTML, and set long-lived immutable cache headers for hashed Next assets.
- Do not require manual uploads for production deployment.
