# Deployment to Baidu Cloud BOS

This repository exports the Next.js H5 platform as a static website and deploys it to Baidu Cloud BOS.

## Target

- Bucket: `zaneshi-h5-prod`
- Region: `bj`
- Future domain: `https://h5.zaneshi.com`
- Build output: `apps/web/out`

## Required GitHub Secrets

Configure these repository secrets in GitHub Actions:

| Secret | Purpose |
| --- | --- |
| `BCE_ACCESS_KEY` | Baidu Cloud access key ID. |
| `BCE_SECRET_KEY` | Baidu Cloud secret access key. |
| `BOS_BUCKET` | Production BOS bucket name, normally `zaneshi-h5-prod`. |
| `BOS_ENDPOINT` | BOS endpoint for the `bj` region. |

Never commit real credential values to the repository.

## Deployment process

The workflow in `.github/workflows/deploy.yml` runs on every push to `main` and can also be started manually with `workflow_dispatch`.

1. Check out the repository.
2. Install Node.js 22 and npm dependencies with `npm install`.
3. Run ESLint.
4. Build and statically export the Next.js app with `npm run build`.
5. Install the Baidu BOS CLI (`bcecmd`).
6. Run `scripts/deploy.sh` to replace the current bucket contents with the exported site.

The deployment script uploads hashed Next.js assets under `_next/` with long-lived immutable cache headers and uploads HTML files with no-cache headers so `index.html` updates are visible quickly.

## BOS configuration

In the Baidu Cloud console, configure the bucket for static website hosting:

- Static website hosting: enabled.
- Index document: `index.html`.
- Error document: use `404.html` if a custom 404 page is added later, otherwise keep the BOS default.
- Public access/CDN: configure according to the production domain plan.
- Domain: point `h5.zaneshi.com` to BOS or the CDN distribution when ready.

## Local deployment

Local deployment uses the same script as CI:

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

### Missing credentials

If `scripts/deploy.sh` reports a missing environment variable, verify the corresponding GitHub Secret exists and is spelled exactly as documented.

### Authentication failures

Confirm the access key is active and has permission to list, delete, and upload objects in `zaneshi-h5-prod`.

### Wrong endpoint or region

Use the BOS endpoint for the `bj` region. An endpoint mismatch can cause authentication or bucket-not-found errors.

### `index.html` does not update

Check that HTML objects were uploaded with no-cache headers and that any CDN in front of BOS has been refreshed or invalidated.

### Assets are missing

Verify `apps/web/out/_next/` exists after `npm run build` and that the deploy logs show `_next` being uploaded.

### Static website returns directory listing or XML

Recheck the BOS static website setting and ensure the index document is exactly `index.html`.
