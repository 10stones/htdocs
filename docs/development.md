# Development Workflow

Production uses `main` only.

```text
Codex -> feature branch -> pull request -> review -> merge into main -> GitHub Actions -> Baidu BOS -> CDN
```

## Local commands

```bash
npm install
npm run dev
npm run lint
npm run build
npm run format
```

CI uses `npm ci`, so commit `package-lock.json` after dependencies can be installed from a trusted development environment.

## Future H5 sections

Keep future top-level content organized around:

- `travel`
- `career`
- `tutorial`
- `client`
- `life`
- `ai`
- `tools`
