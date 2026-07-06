# 05-HTTPS / CDN 证书配置

生产 HTTPS 建议通过 CDN 或 Baidu Cloud 域名证书管理完成。

## 建议流程

1. 准备 `h5.zaneshi.com` DNS。
2. 在 CDN 或 Baidu Cloud 控制台申请/上传证书。
3. 将 CDN 回源配置到 BOS 静态网站。
4. 部署后验证 HTTPS、缓存和回源行为。
