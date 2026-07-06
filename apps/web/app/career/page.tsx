import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Career Tutorials',
  description: '职业成长、求职教程和职场方法论会沉淀在这里。',
};

export default function Page() {
  return (
    <section className="mx-auto flex min-h-[70vh] max-w-5xl flex-col justify-center px-4 py-20">
      <p className="text-sm font-medium uppercase tracking-[0.3em] text-muted-foreground">H5 Platform</p>
      <h1 className="mt-4 text-4xl font-semibold tracking-tight md:text-6xl">Career Tutorials</h1>
      <p className="mt-6 max-w-2xl text-lg leading-8 text-muted-foreground">职业成长、求职教程和职场方法论会沉淀在这里。</p>
    </section>
  );
}
