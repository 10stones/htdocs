import Link from 'next/link';
import { siteConfig } from '@/lib/site';

export function SiteHeader() {
  return (
    <header className="sticky top-0 z-50 border-b bg-background/90 backdrop-blur">
      <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-3">
        <Link href="/" className="text-base font-semibold tracking-tight">
          {siteConfig.name}
        </Link>
        <nav className="hidden gap-4 text-sm text-muted-foreground md:flex">
          {siteConfig.nav.slice(1).map((item) => (
            <Link key={item.href} href={item.href} className="transition-colors hover:text-foreground">
              {item.title}
            </Link>
          ))}
        </nav>
      </div>
    </header>
  );
}
