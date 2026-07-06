# Deployment to Baidu Cloud BOS

This repository deploys the Next.js H5 platform as a static website to Baidu Cloud BOS. The pipeline is intentionally small: GitHub Actions builds the static export, verifies the exported files, installs the Baidu BOS CLI, and runs the same deployment script that can be used locally.

## Deployment architecture

```text
GitHub push to main/master or manual workflow_dispatch
  -> GitHub Actions on ubuntu-latest
  -> npm dependency install
  -> ESLint
  -> Next.js static export
  -> export verification under apps/web/out
  -> bcecmd upload to Baidu BOS
  -> BOS static website hosting / future h5.zaneshi.com domain
```

Production target:

- Bucket: `zaneshi-h5-prod`
- Region: `bj`
- Future domain: `https://h5.zaneshi.com`
- Build output: `apps/web/out`
- Static website index document: `index.html`

## Required GitHub Secrets

Configure these repository secrets in GitHub Actions before deploying:

| Secret | Purpose |
| --- | --- |
| `BCE_ACCESS_KEY` | Baidu Cloud access key ID. |
| `BCE_SECRET_KEY` | Baidu Cloud secret access key. |
| `BOS_BUCKET` | Production BOS bucket name, normally `zaneshi-h5-prod`. |
| `BOS_ENDPOINT` | BOS endpoint for the `bj` region. |

The deployment script fails immediately if any required value is missing. Never commit real credential values to the repository.

## Deployment flow

The workflow in `.github/workflows/deploy.yml` runs on pushes to `main` and `master`, and can also be started manually.

1. Check out the repository.
2. Set up Node.js 22 with npm cache enabled.
3. Install dependencies with `npm ci` when a lockfile is present. If this repository has no lockfile yet, the workflow falls back to `npm install` and emits a warning; commit a `package-lock.json` as soon as dependency installation is available.
4. Run `npm run lint`.
5. Run `npm run build`, which uses Next.js static export from `apps/web`.
6. Verify `apps/web/out/index.html`, `apps/web/out/_next/`, and the absence of server-only `BUILD_ID` output.
7. Install `bcecmd`.
8. Run `scripts/deploy.sh`.

## Static export requirements

`apps/web/next.config.ts` must keep these settings for BOS static hosting:

```ts
output: 'export',
images: {
  unoptimized: true,
},
trailingSlash: true,
```

These settings ensure the build produces static HTML files and asset folders suitable for object storage hosting rather than a Node.js server.

## Cache behavior

`scripts/deploy.sh` uploads files with these cache policies:

- HTML files: `no-cache, no-store, must-revalidate` so page updates are visible quickly.
- `_next` assets: `public, max-age=31536000, immutable` because Next.js asset filenames are content-hashed.
- Other static files: `public, max-age=3600` as a conservative default.

The script removes existing objects under the deployment target before uploading the new export. The bucket is expected to be dedicated to this H5 site or scoped with `BOS_PREFIX`.

## Manual deployment

Manual deployment from GitHub:

1. Open the repository in GitHub.
2. Go to **Actions**.
3. Select **Deploy H5 to Baidu BOS**.
4. Click **Run workflow**.
5. Choose the branch (`main` or `master`) and confirm.

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

Optional local/advanced settings:

| Variable | Purpose |
| --- | --- |
| `OUT_DIR` | Override the export directory. Defaults to `apps/web/out`. |
| `BOS_PREFIX` | Deploy under a bucket prefix instead of the bucket root. |
| `BOS_REGION` | Override the `bj` default region used for `bcecmd` config. |
| `BCECMD_CONF_PATH` | Override the temporary local `bcecmd` config path. |

## BOS configuration

In the Baidu Cloud console, configure the bucket for static website hosting:

- Static website hosting: enabled.
- Index document: `index.html`.
- Error document: use `404.html` after a custom 404 page is added, otherwise keep the BOS default.
- Public access/CDN: configure according to the production domain plan.
- Domain: point `h5.zaneshi.com` to BOS or the CDN distribution when ready.

## Troubleshooting

### Workflow does not run

Confirm the push target is `main` or `master`, or start the workflow manually with `workflow_dispatch` from the Actions tab.

### Dependency installation fails

Prefer committing a `package-lock.json` and using `npm ci`. If CI falls back to `npm install`, treat that as temporary until a lockfile can be generated and committed.

### Missing credentials

If `scripts/deploy.sh` reports a missing environment variable, verify the corresponding GitHub Secret exists and is spelled exactly as documented.

### Authentication failures

Confirm the access key is active and has permission to list, delete, and upload objects in `zaneshi-h5-prod`.

### Wrong endpoint or region

Use the BOS endpoint for the `bj` region. An endpoint mismatch can cause authentication or bucket-not-found errors.

### Export verification fails

Check that `apps/web/next.config.ts` still uses static export settings and that `npm run build` produces `apps/web/out/index.html` and `apps/web/out/_next/`.

### `index.html` does not update

Check that HTML objects were uploaded with no-cache headers and that any CDN in front of BOS has been refreshed or invalidated.

### Assets are missing

Verify the deploy logs show `_next` assets being uploaded and that `apps/web/out/_next/` exists after `npm run build`.

### Static website returns directory listing or XML

Recheck the BOS static website settings and ensure the index document is exactly `index.html`.
