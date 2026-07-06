# 02-GitHub 部署

## 分支策略

`main` 是唯一生产分支。

```text
Feature Branch -> Pull Request -> Review -> Merge into main -> GitHub Actions -> Baidu BOS -> CDN
```

## GitHub Actions

`.github/workflows/deploy.yml` 在以下情况下运行：

- push 到 `main`
- 手动触发 `workflow_dispatch`

## GitHub Secrets

在仓库 Settings → Secrets and variables → Actions 中配置：

- `BCE_ACCESS_KEY`
- `BCE_SECRET_KEY`
- `BOS_BUCKET`
- `BOS_ENDPOINT`

## 部署流程

1. 功能分支开发。
2. 创建 Pull Request。
3. Review 通过后合并到 `main`。
4. GitHub Actions 执行 `npm ci`、`npm run lint`、`npm run build`。
5. `scripts/deploy.sh` 上传静态导出到 Baidu BOS。
6. CDN 提供生产访问。
