import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Interactive Tools',
  description: 'AI Demo、交互表单和实用工具会沉淀在这里。',
};

export default function Page() {
  return (
    <section className="mx-auto flex min-h-[70vh] max-w-5xl flex-col justify-center px-4 py-20">
      <p className="text-sm font-medium uppercase tracking-[0.3em] text-muted-foreground">H5 Platform</p>
      <h1 className="mt-4 text-4xl font-semibold tracking-tight md:text-6xl">Interactive Tools</h1>
      <p className="mt-6 max-w-2xl text-lg leading-8 text-muted-foreground">AI Demo、交互表单和实用工具会沉淀在这里。</p>
    </section>
  );
}
