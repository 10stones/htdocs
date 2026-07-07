import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import { SectionLanding } from '@/components/content/section-landing';
import { getH5Section, h5SectionKeys, isH5SectionKey } from '@/lib/content/sections';

type SectionPageProps = {
  params: Promise<{ section: string }>;
};

export function generateStaticParams() {
  return h5SectionKeys.map((section) => ({ section }));
}

export async function generateMetadata({ params }: SectionPageProps): Promise<Metadata> {
  const { section: sectionKey } = await params;

  if (!isH5SectionKey(sectionKey)) {
    return {};
  }

  const section = getH5Section(sectionKey);

  return {
    title: section.title,
    description: section.description,
  };
}

export default async function SectionPage({ params }: SectionPageProps) {
  const { section: sectionKey } = await params;

  if (!isH5SectionKey(sectionKey)) {
    notFound();
  }

  return <SectionLanding section={getH5Section(sectionKey)} />;
}
