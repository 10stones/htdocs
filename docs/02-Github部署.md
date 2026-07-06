# 02-Github部署

## 分支策略

- `dev`：开发环境，自动部署到 `beta.zaneshi.com`
- `main`：生产环境，自动部署到 `https://zaneshi.com`

## GitHub Secrets

在仓库 Settings → Secrets and variables → Actions 中配置：

- `SERVER_HOST`
- `SERVER_USER`
- `SERVER_PORT`
- `SERVER_PATH`，默认 `/var/www/zaneshi`
- `SSH_PRIVATE_KEY`

## 流程

1. 功能分支开发。
2. 合并到 `dev` 触发 beta 部署。
3. 验收通过后合并到 `main` 触发生产部署。
