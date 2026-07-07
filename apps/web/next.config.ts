import path from 'node:path';
import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  output: 'export',
  poweredByHeader: false,
  compress: true,
  images: {
    unoptimized: true,
    formats: ['image/avif', 'image/webp'],
  },
  trailingSlash: true,
  turbopack: {
    root: path.join(process.cwd(), '../..'),
  },
};

export default nextConfig;
