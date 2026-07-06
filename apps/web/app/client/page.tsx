import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Client Presentations',
  description: '客户演示、提案和项目展示 H5 页面会沉淀在这里。',
};

export default function Page() {
  return (
    <section className="mx-auto flex min-h-[70vh] max-w-5xl flex-col justify-center px-4 py-20">
      <p className="text-sm font-medium uppercase tracking-[0.3em] text-muted-foreground">H5 Platform</p>
      <h1 className="mt-4 text-4xl font-semibold tracking-tight md:text-6xl">Client Presentations</h1>
      <p className="mt-6 max-w-2xl text-lg leading-8 text-muted-foreground">客户演示、提案和项目展示 H5 页面会沉淀在这里。</p>
    </section>
  );
}
