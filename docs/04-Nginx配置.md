# 04-CDN / 静态托管配置

生产站点由 Baidu BOS 静态网站托管，并可在前面接入 CDN。

## 建议配置

- BOS 静态网站 Index document：`index.html`
- HTML：使用 no-cache 策略
- `_next` 静态资源：使用长期 immutable 缓存
- CDN：域名准备完成后绑定 `h5.zaneshi.com`

Nginx 配置仅作为历史参考，不再是生产部署链路的一部分。
