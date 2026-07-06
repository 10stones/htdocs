import nextVitals from 'eslint-config-next/core-web-vitals';
import nextTs from 'eslint-config-next/typescript';

const eslintConfig = [
  ...nextVitals,
  ...nextTs,
  {
    ignores: [
      'node_modules/**',
      'apps/**/.next/**',
      'apps/**/out/**',
      'out/**',
      'coverage/**',
    ],
  },
  {
    settings: {
      next: {
        rootDir: ['apps/web/'],
      },
    },
  },
];

export default eslintConfig;
