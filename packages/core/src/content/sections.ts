export const h5SectionKeys = ['travel', 'career', 'tutorial', 'client', 'tools'] as const;

export type H5SectionKey = (typeof h5SectionKeys)[number];

export type H5Section = {
  key: H5SectionKey;
  title: string;
  description: string;
  eyebrow: string;
  path: `/${H5SectionKey}`;
  plannedContent: readonly string[];
};

export const h5Sections = {
  travel: {
    key: 'travel',
    title: 'Travel Plans',
    description: '旅行计划、城市攻略和行程 H5 页面会沉淀在这里。',
    eyebrow: 'Travel',
    path: '/travel',
    plannedContent: ['城市攻略', '每日行程', '预算清单', '地图与交通提示'],
  },
  career: {
    key: 'career',
    title: 'Career Tutorials',
    description: '职业成长、求职教程和职场方法论会沉淀在这里。',
    eyebrow: 'Career',
    path: '/career',
    plannedContent: ['求职教程', '作品集模板', '面试准备', '职业复盘'],
  },
  tutorial: {
    key: 'tutorial',
    title: 'Tutorials',
    description: '面向开发者和创作者的教程会沉淀在这里。',
    eyebrow: 'Tutorial',
    path: '/tutorial',
    plannedContent: ['技术教程', 'AI 工作流', '工具指南', '代码示例'],
  },
  client: {
    key: 'client',
    title: 'Client Presentations',
    description: '客户演示、提案和项目展示 H5 页面会沉淀在这里。',
    eyebrow: 'Client',
    path: '/client',
    plannedContent: ['客户提案', '项目展示', '营销落地页', '互动演示'],
  },
  tools: {
    key: 'tools',
    title: 'Interactive Tools',
    description: 'AI Demo、交互表单和实用工具会沉淀在这里。',
    eyebrow: 'Tools',
    path: '/tools',
    plannedContent: ['AI Demo', '互动表单', '计算器', '效率工具'],
  },
} satisfies Record<H5SectionKey, H5Section>;

export function getH5Section(key: H5SectionKey): H5Section {
  return h5Sections[key];
}

export function isH5SectionKey(key: string): key is H5SectionKey {
  return h5SectionKeys.includes(key as H5SectionKey);
}
