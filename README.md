# zaneshi.com

面向长期维护的个人网站工程，使用 Next.js App Router、TypeScript、Tailwind CSS、shadcn/ui 与 GitHub Actions 自动部署到百度智能云 ECS。

## 技术栈

- Next.js App Router + TypeScript
- Tailwind CSS + shadcn/ui + lucide-react
- ESLint + Prettier + Husky + lint-staged + commitlint
- GitHub Actions + SSH + Nginx + Let's Encrypt

## 目录说明

```text
src/app                页面路由
src/components         通用组件与 UI 基础组件
src/features           业务功能模块
src/hooks              React hooks
src/lib                配置、工具函数和基础库
src/styles             全局样式
content                Markdown/内容源
scripts                部署与运维脚本
deploy/nginx           Nginx 配置模板
docs                  部署与协作文档
```

## 开发命令

```bash
npm install
npm run dev
npm run lint
npm run build
npm run format
```

## 部署方式

- push 到 `dev`：部署到 `beta.zaneshi.com`
- push 到 `main`：部署到 `https://zaneshi.com`

GitHub Secrets：`SERVER_HOST`、`SERVER_USER`、`SERVER_PORT`、`SERVER_PATH`、`SSH_PRIVATE_KEY`。

## 环境变量

复制 `.env.example` 为 `.env.local`，按需配置：

```bash
NEXT_PUBLIC_SITE_URL=https://zaneshi.com
```

## 未来规划

- Blog 内容系统
- Projects 项目陈列
- Life / Photography / Cycling / Snowboard 专题
- AI 实验与工具页
- 自动化监控、备份和回滚增强

## GitHub 权限配置

请参考 `docs/08-GitHub权限配置.md`，使用 GitHub CLI 配置 `dev` 分支、Environments 和 Secrets。不要把 Token、SSH 私钥或服务器密码发送到聊天窗口。
