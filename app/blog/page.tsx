"use client";

import React, { useState } from "react";
import Link from "next/link";
import { ArrowRight, BookOpen, ChevronRight, Clock } from "lucide-react";
import { Footer } from "@/components/Footer";
import { Header } from "@/components/Header";
import { useLanguage } from "@/components/LanguageProvider";
import { MobileActionBar } from "@/components/MobileActionBar";
import { blogPosts, type BlogCategory } from "@/lib/blog";

export default function BlogPage() {
  const { locale } = useLanguage();
  const [category, setCategory] = useState<BlogCategory>("all");

  const filters: Array<{ id: BlogCategory; ar: string; en: string }> = [
    { id: "all", ar: "كل المقالات", en: "All Guides" },
    { id: "tanks", ar: "تأسيس الأحواض", en: "Tank Setup" },
    { id: "fish", ar: "رعاية الأسماك", en: "Fish Care" },
    { id: "turtles", ar: "السلاحف المائية", en: "Turtles" },
    { id: "water", ar: "جودة المياه", en: "Water Care" },
  ];

  const visiblePosts =
    category === "all"
      ? blogPosts
      : blogPosts.filter((post) => post.category === category);

  return (
    <div className="min-h-screen flex flex-col bg-ocean-ice text-ocean-navy">
      <Header />
      <main className="flex-1 pt-24 pb-20 px-4 sm:px-6 max-w-[1560px] mx-auto w-full">
        {/* Breadcrumb */}
        <nav
          className="flex items-center gap-2 text-sm font-bold text-ocean-slate mb-4"
          aria-label="Breadcrumb"
        >
          <Link href="/" className="hover:text-ocean-primary transition-colors">
            {locale === "ar" ? "الرئيسية" : "Home"}
          </Link>
          <ChevronRight className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
          <span className="text-ocean-navy">
            {locale === "ar" ? "المدونة والأدلة" : "Blog & Guides"}
          </span>
        </nav>

        {/* Page Hero */}
        <div className="rounded-3xl bg-gradient-to-br from-ocean-navy via-ocean-deep to-ocean-primary text-white p-6 sm:p-10 mb-8 shadow-md">
          <span className="inline-flex items-center gap-1.5 rounded-full bg-white/15 border border-white/25 px-3 py-1 text-xs font-extrabold text-ocean-yellow">
            <BookOpen className="w-3.5 h-3.5" strokeWidth={2} aria-hidden="true" />
            <span>{locale === "ar" ? "مكتبة مصطفى عمار" : "Mostafa Ammar Library"}</span>
          </span>
          <h1 className="mt-3 text-3xl sm:text-4xl font-extrabold tracking-tight">
            {locale === "ar"
              ? "أدلة عملية لتربية الأسماك والسلاحف"
              : "Practical Aquarium & Turtle Guides"}
          </h1>
          <p className="mt-2 max-w-2xl text-sm sm:text-base text-ocean-muted">
            {locale === "ar"
              ? "خطوات مجربة من تأسيس الدورة البيولوجية وحتى اختيار الفلتر والعناية اليومية."
              : "Field-tested guides covering tank cycling, Betta habitats, turtle UVB setups, and water changes."}
          </p>
        </div>

        {/* Category Filter Pills (Hick's Law) */}
        <div className="flex flex-wrap items-center gap-2 mb-7">
          {filters.map((f) => {
            const active = category === f.id;
            return (
              <button
                key={f.id}
                type="button"
                onClick={() => setCategory(f.id)}
                className={`min-h-[44px] rounded-full px-4 text-sm font-extrabold border transition-colors cursor-pointer ${
                  active
                    ? "bg-ocean-yellow text-ocean-navy border-ocean-yellow-hover shadow-sm"
                    : "bg-white text-ocean-navy border-ocean-border [@media(hover:hover)]:hover:border-ocean-primary"
                }`}
              >
                {locale === "ar" ? f.ar : f.en}
              </button>
            );
          })}
        </div>

        {/* Articles Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-6">
          {visiblePosts.map((post) => (
            <Link
              key={post.slug}
              href={`/blog/${post.slug}/`}
              className="group rounded-3xl bg-white border border-ocean-border overflow-hidden flex flex-col justify-between shadow-[0_8px_26px_rgba(7,26,47,0.06)] transition-transform duration-300 [@media(hover:hover)]:hover:-translate-y-1"
            >
              <div>
                <div className="relative h-52 w-full bg-ocean-navy overflow-hidden">
                  <img
                    src={post.image}
                    alt={locale === "ar" ? post.titleAr : post.titleEn}
                    loading="lazy"
                    className="w-full h-full object-cover transition-transform duration-500 [@media(hover:hover)]:group-hover:scale-105"
                  />
                  <span className="absolute top-3 start-3 rounded-full bg-ocean-navy/85 backdrop-blur-md border border-white/20 text-ocean-yellow px-3 py-1 text-xs font-extrabold">
                    {locale === "ar" ? post.categoryAr : post.categoryEn}
                  </span>
                </div>

                <div className="p-5 sm:p-6 space-y-2">
                  <div className="flex items-center gap-3 text-xs font-bold text-ocean-slate">
                    <span className="inline-flex items-center gap-1">
                      <Clock className="w-3.5 h-3.5 text-ocean-primary" aria-hidden="true" />
                      <span>{locale === "ar" ? post.readTimeAr : post.readTimeEn}</span>
                    </span>
                    <span>•</span>
                    <span>{locale === "ar" ? post.authorAr : post.authorEn}</span>
                  </div>

                  <h2 className="text-xl font-extrabold text-ocean-navy [@media(hover:hover)]:group-hover:text-ocean-primary leading-snug">
                    {locale === "ar" ? post.titleAr : post.titleEn}
                  </h2>

                  <p className="text-sm text-ocean-slate leading-relaxed">
                    {locale === "ar" ? post.excerptAr : post.excerptEn}
                  </p>
                </div>
              </div>

              <div className="px-5 sm:px-6 pb-5 pt-2 flex items-center justify-between border-t border-ocean-ice">
                <span className="text-xs font-bold text-ocean-slate">
                  {locale === "ar" ? post.dateAr : post.dateEn}
                </span>
                <span className="inline-flex items-center gap-1.5 text-sm font-extrabold text-ocean-primary">
                  <span>{locale === "ar" ? "اقرأ الدليل" : "Read guide"}</span>
                  <ArrowRight className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
                </span>
              </div>
            </Link>
          ))}
        </div>
      </main>
      <Footer />
      <MobileActionBar />
    </div>
  );
}
