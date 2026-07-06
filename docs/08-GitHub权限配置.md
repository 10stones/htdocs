# 08-GitHub 权限配置

## 安全原则

不要把 GitHub Token、Baidu Cloud 密钥或任何 Secret 发送到聊天窗口，也不要提交到仓库。

## GitHub CLI 登录

```bash
gh auth login
```

## 配置 production Environment

```bash
GITHUB_REPOSITORY=<owner>/<repo> scripts/configure-github.sh
```

脚本会配置 production environment，并限制部署分支为 `main`。

## 写入 GitHub Secrets

```bash
gh secret set BCE_ACCESS_KEY --repo <owner>/<repo>
gh secret set BCE_SECRET_KEY --repo <owner>/<repo>
gh secret set BOS_BUCKET --repo <owner>/<repo>
gh secret set BOS_ENDPOINT --repo <owner>/<repo>
```
