# 05-SSL配置

## 安装 Certbot

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d zaneshi.com -d www.zaneshi.com -d beta.zaneshi.com
sudo certbot renew --dry-run
```

证书生成后，复制 `deploy/nginx/zaneshi.conf` 到 `/etc/nginx/sites-available/zaneshi.conf`，并软链到 `sites-enabled`。
