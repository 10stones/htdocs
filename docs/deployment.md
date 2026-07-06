# Deployment to Baidu Cloud BOS

Production is deployed from `main` only.

## Deployment architecture

```text
Feature Branch
  -> Pull Request
  -> Review
  -> Merge into main
  -> GitHub Actions
  -> npm ci
  -> npm run lint
  -> npm run build
  -> verify out/
  -> scripts/deploy.sh
  -> Baidu BOS
  -> CDN
```

## Branch strategy

- `main` is the only primary and production branch.
- Feature work happens on feature branches.
- Production deployment starts only after a pull request is reviewed and merged into `main`.
- Manual production deployment is available through GitHub Actions `workflow_dispatch`.

## Required GitHub Secrets

Configure these repository secrets in GitHub Actions:

| Secret | Purpose |
| --- | --- |
| `BCE_ACCESS_KEY` | Baidu Cloud access key ID. |
| `BCE_SECRET_KEY` | Baidu Cloud secret access key. |
| `BOS_BUCKET` | Production BOS bucket name, normally `zaneshi-h5-prod`. |
| `BOS_ENDPOINT` | BOS endpoint for the `bj` region. |

Never commit real credential values.

## GitHub Actions flow

The workflow in `.github/workflows/deploy.yml` runs on:

- push to `main`
- manual `workflow_dispatch`

Steps:

1. Check out the repository.
2. Set up Node.js 22 with npm cache.
3. Install dependencies with `npm ci`.
4. Run `npm run lint`.
5. Run `npm run build`.
6. Verify the static export in `out/`.
7. Install `bcecmd`.
8. Run `scripts/deploy.sh`.

## Static export requirements

`next.config.ts` must keep these settings:

```ts
output: 'export',
images: {
  unoptimized: true,
},
trailingSlash: true,
```

The expected build output is:

```text
out/index.html
out/_next/
```

## BOS deployment behavior

`scripts/deploy.sh`:

- fails fast when required secrets are missing
- verifies `out/index.html` and `out/_next/` before upload
- configures `bcecmd` from environment variables
- removes existing objects under the configured BOS target
- uploads `_next` assets with `public, max-age=31536000, immutable`
- uploads HTML files with `no-cache, no-store, must-revalidate`
- uploads other static files with `public, max-age=3600`

## Manual deployment

1. Open GitHub Actions.
2. Select **Deploy H5 to Baidu BOS**.
3. Click **Run workflow**.
4. Select `main`.
5. Start the workflow.

## Local deployment

```bash
npm install
npm run build
python -m pip install --upgrade bcecmd
export BCE_ACCESS_KEY="..."
export BCE_SECRET_KEY="..."
export BOS_BUCKET="zaneshi-h5-prod"
export BOS_ENDPOINT="..."
bash scripts/deploy.sh
```

Optional variables:

| Variable | Purpose |
| --- | --- |
| `OUT_DIR` | Override export directory. Defaults to `out`. |
| `BOS_PREFIX` | Deploy under a bucket prefix. |
| `BOS_REGION` | Override the default `bj` region. |
| `BCECMD_CONF_PATH` | Override local `bcecmd` config path. |

## BOS configuration

- Enable static website hosting.
- Set index document to `index.html`.
- Configure `h5.zaneshi.com` through BOS or CDN when DNS is ready.
- Use CDN cache refresh/invalidation if HTML appears stale after deployment.

## Troubleshooting

### Workflow does not run

Confirm the change was pushed to `main`, or manually start the workflow from GitHub Actions.

### `npm ci` fails

Generate and commit `package-lock.json` from a trusted development environment.

### Missing secrets

Check GitHub repository secrets for `BCE_ACCESS_KEY`, `BCE_SECRET_KEY`, `BOS_BUCKET`, and `BOS_ENDPOINT`.

### Export verification fails

Run `npm run build` locally and confirm `out/index.html` and `out/_next/` exist.

### HTML appears stale

Confirm HTML was uploaded with no-cache headers and refresh the CDN if one is configured.
