export const siteConfig = {
  name: 'Zane Shi',
  domain: 'zaneshi.com',
  url: process.env.NEXT_PUBLIC_SITE_URL ?? 'https://zaneshi.com',
  description: 'Zane Shi 的个人网站，记录技术、AI、生活、摄影、骑行与滑雪。',
  nav: [
    { title: 'Home', href: '/' },
    { title: 'About', href: '/about' },
    { title: 'Blog', href: '/blog' },
    { title: 'Projects', href: '/projects' },
    { title: 'Life', href: '/life' },
    { title: 'AI', href: '/ai' },
    { title: 'Photography', href: '/photography' },
    { title: 'Cycling', href: '/cycling' },
    { title: 'Snowboard', href: '/snowboard' },
    { title: 'Contact', href: '/contact' },
  ],
} as const;
