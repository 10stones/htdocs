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
};

export default nextConfig;
