import Link from 'next/link';
import { ArrowRight, Sparkles } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { siteConfig } from '@/lib/site';

const highlights = ['AI 协作开发', '摄影与生活记录', '骑行与滑雪日志', '长期主义个人知识库'];

export default function HomePage() {
  return (
    <section className="mx-auto max-w-6xl px-4 py-16 sm:py-24">
      <div className="max-w-3xl">
        <div className="mb-6 inline-flex items-center gap-2 rounded-full border px-3 py-1 text-sm text-muted-foreground"><Sparkles className="h-4 w-4" /> zaneshi.com 正在建设中</div>
        <h1 className="text-4xl font-bold tracking-tight sm:text-6xl">一个面向长期创作与 AI 协作的个人网站。</h1>
        <p className="mt-6 text-lg leading-8 text-muted-foreground">{siteConfig.description} 这里会持续沉淀项目、文章、生活方式与个人实验。</p>
        <div className="mt-8 flex flex-wrap gap-3"><Button asChild><Link href="/blog">阅读 Blog <ArrowRight className="h-4 w-4" /></Link></Button><Button asChild variant="outline"><Link href="/projects">查看 Projects</Link></Button></div>
      </div>
      <div className="mt-14 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">{highlights.map((item) => <div key={item} className="rounded-2xl border bg-card p-5 text-sm font-medium shadow-sm">{item}</div>)}</div>
    </section>
  );
}
