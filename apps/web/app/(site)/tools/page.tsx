import type { Metadata } from 'next';
import { SectionLanding } from '@/components/content/section-landing';
import { getH5Section } from '@/lib/content/sections';

const section = getH5Section('tools');

export const metadata: Metadata = {
  title: section.title,
  description: section.description,
};

export default function Page() {
  return <SectionLanding section={section} />;
}
