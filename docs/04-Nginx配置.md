# 04-Nginx配置

## 安装并启用配置

```bash
sudo cp deploy/nginx/zaneshi.conf /etc/nginx/sites-available/zaneshi.conf
sudo ln -sfn /etc/nginx/sites-available/zaneshi.conf /etc/nginx/sites-enabled/zaneshi.conf
sudo nginx -t
sudo systemctl reload nginx
```

## 特性

- HTTP 自动跳转 HTTPS
- gzip 压缩
- Brotli 配置（如果 Nginx 已安装 Brotli 模块）
- Next.js 静态资源长期缓存
- 反向代理到本机 `127.0.0.1:3000`
