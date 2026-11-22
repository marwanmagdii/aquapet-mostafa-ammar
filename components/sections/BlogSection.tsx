"use client";

import React from "react";
import Link from "next/link";
import { ArrowRight, BookOpen, Clock } from "lucide-react";
import { blogPosts } from "@/lib/blog";
import { useLanguage } from "../LanguageProvider";
import { SectionReveal } from "../SectionReveal";

export function BlogSection() {
  const { locale } = useLanguage();
  const featuredPosts = blogPosts.slice(0, 3);

  return (
    <section id="blog" className="py-10 sm:py-12 px-4 sm:px-6 max-w-[1560px] mx-auto">
      <SectionReveal>
        <div className="flex flex-wrap items-end justify-between gap-4 mb-6">
          <div className="space-y-1.5">
            <span className="inline-flex items-center gap-1.5 rounded-full bg-ocean-primary/10 text-ocean-primary px-3 py-1 text-xs font-extrabold">
              <BookOpen className="w-3.5 h-3.5" strokeWidth={2} aria-hidden="true" />
              <span>{locale === "ar" ? "دليل المربي" : "Aquarist Guides"}</span>
            </span>
            <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-ocean-navy">
              {locale === "ar" ? "المدونة ونصائح الأحواض" : "Blog & Care Guides"}
            </h2>
          </div>

          <Link
            href="/blog/"
            className="min-h-[44px] inline-flex items-center gap-1.5 rounded-full bg-white border border-ocean-border [@media(hover:hover)]:hover:border-ocean-primary px-4 text-sm font-extrabold text-ocean-navy transition-colors shrink-0"
          >
            <span>{locale === "ar" ? "كل المقالات" : "All Articles"}</span>
            <ArrowRight className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
          </Link>
        </div>
      </SectionReveal>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
        {featuredPosts.map((post, idx) => (
          <SectionReveal key={post.slug} delayMs={idx * 50} className="h-full">
            <Link
              href={`/blog/${post.slug}/`}
              className="group h-full rounded-2xl bg-white border border-ocean-border overflow-hidden flex flex-col justify-between shadow-[0_6px_20px_rgba(7,26,47,0.05)] transition-transform duration-300 ease-[cubic-bezier(0.22,1,0.36,1)] [@media(hover:hover)]:hover:-translate-y-1"
            >
              <div>
                <div className="relative h-40 w-full bg-ocean-navy overflow-hidden">
                  <img
                    src={post.image}
                    alt={locale === "ar" ? post.titleAr : post.titleEn}
                    loading="lazy"
                    className="w-full h-full object-cover transition-transform duration-500 [@media(hover:hover)]:group-hover:scale-105"
                  />
                  <span className="absolute top-2.5 start-2.5 rounded-full bg-ocean-navy/85 backdrop-blur-md border border-white/20 text-ocean-yellow px-2.5 py-0.5 text-xs font-extrabold">
                    {locale === "ar" ? post.categoryAr : post.categoryEn}
                  </span>
                </div>

                <div className="p-4 space-y-1.5">
                  <div className="flex items-center gap-1.5 text-xs font-bold text-ocean-slate">
                    <Clock className="w-3.5 h-3.5 text-ocean-primary shrink-0" aria-hidden="true" />
                    <span>{locale === "ar" ? post.readTimeAr : post.readTimeEn}</span>
                  </div>
                  <h3 className="text-base sm:text-lg font-extrabold text-ocean-navy [@media(hover:hover)]:group-hover:text-ocean-primary leading-snug line-clamp-2">
                    {locale === "ar" ? post.titleAr : post.titleEn}
                  </h3>
                  <p className="text-sm text-ocean-slate line-clamp-2 leading-relaxed">
                    {locale === "ar" ? post.excerptAr : post.excerptEn}
                  </p>
                </div>
              </div>

              <div className="px-4 pb-4 pt-1 flex items-center gap-1.5 text-sm font-extrabold text-ocean-primary">
                <span>{locale === "ar" ? "اقرأ الدليل" : "Read guide"}</span>
                <ArrowRight
                  className="w-4 h-4 rtl:rotate-180 transition-transform [@media(hover:hover)]:group-hover:translate-x-1 [@media(hover:hover)]:rtl:group-hover:-translate-x-1"
                  aria-hidden="true"
                />
              </div>
            </Link>
          </SectionReveal>
        ))}
      </div>
    </section>
  );
}
