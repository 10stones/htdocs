# Deployment

Production deploys from `main` only.

## Architecture

```text
main
  -> GitHub Actions
  -> npm ci
  -> npm run lint
  -> npm run build
  -> verify out/
  -> scripts/deploy.sh
  -> Baidu BOS
  -> CDN
```

## GitHub Actions

Workflow: `.github/workflows/deploy.yml`

Triggers:

- push to `main`
- manual `workflow_dispatch`

## Required GitHub Secrets

| Secret | Description |
| --- | --- |
| `BCE_ACCESS_KEY` | Baidu Cloud access key ID. |
| `BCE_SECRET_KEY` | Baidu Cloud secret access key. |
| `BOS_BUCKET` | Production BOS bucket, for example `zaneshi-h5-prod`. |
| `BOS_ENDPOINT` | BOS endpoint for the `bj` region. |

Never commit credentials.

## Static export requirements

`next.config.ts` must keep:

```ts
output: 'export',
images: {
  unoptimized: true,
},
trailingSlash: true,
```

Expected build output:

```text
out/index.html
out/_next/
```

## Deployment script

`scripts/deploy.sh`:

- fails immediately when required secrets are missing
- verifies the static export before uploading
- configures `bcecmd` from environment variables
- removes existing BOS objects under the configured target
- uploads `_next` assets with immutable cache headers
- uploads HTML with no-cache headers
- uploads other static files with a conservative cache header

## Manual deployment

1. Open GitHub Actions.
2. Select **Deploy H5 to Baidu BOS**.
3. Run the workflow from `main`.

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

## Troubleshooting

- If `npm ci` fails, generate and commit `package-lock.json` from a trusted environment.
- If secrets are missing, configure the four required GitHub Secrets.
- If HTML appears stale, verify no-cache headers and refresh the CDN.
- If assets are missing, verify `out/_next/` exists after `npm run build`.
