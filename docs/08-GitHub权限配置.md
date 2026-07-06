# 08-GitHub权限配置

## 重要安全原则

不要把 GitHub Token、SSH 私钥、服务器密码或任何 Secret 发送到聊天窗口，也不要提交到仓库。推荐使用 GitHub CLI 在你的本机完成授权和 Secrets 写入。

## 一次性准备

安装 GitHub CLI 后登录：

```bash
gh auth login
```

确认当前仓库已经设置远程地址：

```bash
git remote -v
```

如果还没有远程地址：

```bash
git remote add origin git@github.com:<owner>/<repo>.git
```

## 自动配置 dev 分支和 Environments

```bash
GITHUB_REPOSITORY=<owner>/<repo> scripts/configure-github.sh
```

脚本会：

1. 创建远程 `dev` 分支（如果不存在）。
2. 创建 `beta` GitHub Environment，对应 `dev` 分支。
3. 创建 `production` GitHub Environment，对应 `main` 分支。
4. 输出 Secrets 写入命令。

## 写入 GitHub Secrets

```bash
gh secret set SERVER_HOST --repo <owner>/<repo>
gh secret set SERVER_USER --repo <owner>/<repo>
gh secret set SERVER_PORT --repo <owner>/<repo>
gh secret set SERVER_PATH --repo <owner>/<repo>
gh secret set SSH_PRIVATE_KEY --repo <owner>/<repo> < ~/.ssh/zaneshi_deploy
```

`SERVER_PATH` 推荐填写：

```text
/var/www/zaneshi
```

## 我可以如何协助

如果你希望我继续配置 GitHub，请在运行环境里提供已经认证的 `gh` CLI，或设置有效的 `GH_TOKEN` / `GITHUB_TOKEN` 环境变量，并确保仓库有 `origin` 远程地址。不要把 Token 直接发到对话里。
