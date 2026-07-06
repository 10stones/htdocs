import type { H5Section } from '@/lib/content/sections';

type SectionLandingProps = {
  section: H5Section;
};

export function SectionLanding({ section }: SectionLandingProps) {
  return (
    <section className="mx-auto flex min-h-[70vh] max-w-5xl flex-col justify-center px-4 py-20">
      <p className="text-sm font-medium uppercase tracking-[0.3em] text-muted-foreground">{section.eyebrow}</p>
      <h1 className="mt-4 text-4xl font-semibold tracking-tight md:text-6xl">{section.title}</h1>
      <p className="mt-6 max-w-2xl text-lg leading-8 text-muted-foreground">{section.description}</p>
      <div className="mt-10 grid gap-3 sm:grid-cols-2">
        {section.plannedContent.map((item) => (
          <div key={item} className="rounded-2xl border bg-background p-4 text-sm text-muted-foreground shadow-sm">
            {item}
          </div>
        ))}
      </div>
    </section>
  );
}
