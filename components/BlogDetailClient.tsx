"use client";

import React, { useState } from "react";
import Link from "next/link";
import {
  ArrowLeft,
  ArrowRight,
  Check,
  ChevronRight,
  Clock,
  MessageCircle,
  Plus,
  Stethoscope,
  User,
} from "lucide-react";
import { Footer } from "@/components/Footer";
import { Header } from "@/components/Header";
import { useCart } from "@/components/CartProvider";
import { useLanguage } from "@/components/LanguageProvider";
import { MobileActionBar } from "@/components/MobileActionBar";
import { blogPosts, type BlogPost } from "@/lib/blog";
import { buildWhatsappUrl } from "@/lib/contact";
import { products } from "@/lib/products";

export function BlogDetailClient({ post }: { post: BlogPost }) {
  const { locale } = useLanguage();
  const { addItem } = useCart();
  const [addedId, setAddedId] = useState<string | null>(null);

  const title = locale === "ar" ? post.titleAr : post.titleEn;
  const excerpt = locale === "ar" ? post.excerptAr : post.excerptEn;
  const category = locale === "ar" ? post.categoryAr : post.categoryEn;
  const keyPoints = locale === "ar" ? post.keyPointsAr : post.keyPointsEn;
  const relatedProducts = products.filter((p) => post.relatedProductIds.includes(p.id));
  const otherPosts = blogPosts.filter((p) => p.slug !== post.slug).slice(0, 2);

  const expertWhatsappUrl = buildWhatsappUrl(
    locale === "ar"
      ? `مرحباً مصطفى عمار، قرأت مقال "${post.titleAr}" ولدي استفسار عن حوضي.`
      : `Hello Mostafa Ammar Aquatics, I read "${post.titleEn}" and have a quick question about my tank.`
  );

  const handleAdd = (item: (typeof products)[number]) => {
    addItem(item);
    setAddedId(item.id);
    window.setTimeout(() => {
      setAddedId((curr) => (curr === item.id ? null : curr));
    }, 1200);
  };

  return (
    <div className="min-h-screen flex flex-col bg-ocean-ice text-ocean-navy">
      <Header />
      <main className="flex-1 pt-24 pb-20 px-4 sm:px-6 max-w-[1560px] mx-auto w-full">
        {/* Breadcrumb */}
        <nav
          className="flex flex-wrap items-center gap-2 text-sm font-bold text-ocean-slate mb-6"
          aria-label="Breadcrumb"
        >
          <Link href="/" className="hover:text-ocean-primary transition-colors">
            {locale === "ar" ? "الرئيسية" : "Home"}
          </Link>
          <ChevronRight className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
          <Link href="/blog/" className="hover:text-ocean-primary transition-colors">
            {locale === "ar" ? "المدونة" : "Blog"}
          </Link>
          <ChevronRight className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
          <span className="text-ocean-navy">{category}</span>
        </nav>

        {/* Asymmetric Split Editorial Hero (Type Lead + Unobstructed Visual Canvas) */}
        <section className="rounded-[2.25rem] bg-white border border-ocean-border p-5 sm:p-8 lg:p-10 shadow-[0_14px_40px_rgba(7,26,47,0.06)]">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-7 lg:gap-10 items-center">
            <div className="lg:col-span-5 space-y-5 order-2 lg:order-1">
              <div className="flex flex-wrap items-center gap-2.5">
                <span className="inline-flex items-center rounded-full bg-ocean-yellow text-ocean-navy px-3.5 py-1 text-xs font-extrabold">
                  {category}
                </span>
                <span className="inline-flex items-center gap-1.5 rounded-full bg-ocean-ice border border-ocean-border px-3 py-1 text-xs font-bold text-ocean-slate">
                  <Clock className="w-3.5 h-3.5 text-ocean-primary" aria-hidden="true" />
                  <span>{locale === "ar" ? post.readTimeAr : post.readTimeEn}</span>
                </span>
              </div>

              <h1 className="text-2xl sm:text-3xl lg:text-[2.35rem] font-extrabold text-ocean-navy leading-[1.22] tracking-tight">
                {title}
              </h1>

              <p className="text-base sm:text-lg text-ocean-slate leading-relaxed font-medium">
                {excerpt}
              </p>

              <div className="pt-2 border-t border-ocean-ice flex flex-wrap items-center justify-between gap-4">
                <div className="flex items-center gap-2.5 text-xs sm:text-sm font-bold text-ocean-slate">
                  <span className="w-9 h-9 rounded-full bg-ocean-navy text-ocean-yellow flex items-center justify-center shrink-0">
                    <User className="w-4 h-4" aria-hidden="true" />
                  </span>
                  <div>
                    <p className="font-extrabold text-ocean-navy">
                      {locale === "ar" ? post.authorAr : post.authorEn}
                    </p>
                    <p className="text-xs text-ocean-slate">
                      {locale === "ar" ? post.dateAr : post.dateEn}
                    </p>
                  </div>
                </div>

                <Link
                  href="/blog/"
                  className="min-h-[44px] inline-flex items-center gap-1.5 rounded-full bg-ocean-ice border border-ocean-border [@media(hover:hover)]:hover:border-ocean-primary px-4 text-xs sm:text-sm font-extrabold text-ocean-navy transition-colors"
                >
                  <ArrowLeft className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
                  <span>{locale === "ar" ? "كل المقالات" : "All Articles"}</span>
                </Link>
              </div>
            </div>

            <div className="lg:col-span-7 order-1 lg:order-2">
              <div className="relative h-64 sm:h-[360px] lg:h-[420px] w-full rounded-[1.75rem] overflow-hidden bg-ocean-navy border border-ocean-border shadow-inner">
                <img
                  src={post.image}
                  alt={title}
                  className="w-full h-full object-cover"
                />
                <div
                  className="absolute inset-0 bg-gradient-to-tr from-ocean-navy/30 via-transparent to-transparent pointer-events-none"
                  aria-hidden="true"
                />
              </div>
            </div>
          </div>
        </section>

        {/* Modular 2-Column Editorial Flow + Sticky Action Sidebar */}
        <div className="mt-8 grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          {/* Main Reading Column (8 cols) */}
          <div className="lg:col-span-8 space-y-8">
            {/* Numbered Step Bento Strip */}
            <section className="space-y-4">
              <h2 className="text-xl font-extrabold text-ocean-navy">
                {locale === "ar" ? "أهم النقاط العملية" : "Key Care Steps"}
              </h2>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
                {keyPoints.map((point, index) => (
                  <div
                    key={point}
                    className="rounded-2xl bg-white border border-ocean-border p-4 flex items-start gap-3.5 shadow-[0_4px_16px_rgba(7,26,47,0.04)]"
                  >
                    <span className="w-8 h-8 rounded-xl bg-ocean-navy text-ocean-yellow text-xs font-extrabold flex items-center justify-center shrink-0 tabular-nums">
                      0{index + 1}
                    </span>
                    <p className="text-sm font-bold text-ocean-navy leading-relaxed">{point}</p>
                  </div>
                ))}
              </div>
            </section>

            {/* Editorial Prose Sections */}
            <article className="rounded-[2rem] bg-white border border-ocean-border p-6 sm:p-9 space-y-8 shadow-[0_8px_28px_rgba(7,26,47,0.05)]">
              {post.sections.map((section) => (
                <section key={section.headingEn} className="space-y-3">
                  <h2 className="text-xl sm:text-2xl font-extrabold text-ocean-navy border-s-4 border-ocean-yellow ps-4 leading-snug">
                    {locale === "ar" ? section.headingAr : section.headingEn}
                  </h2>
                  <p className="text-base sm:text-[17px] text-ocean-slate leading-[1.85] font-medium">
                    {locale === "ar" ? section.bodyAr : section.bodyEn}
                  </p>
                </section>
              ))}
            </article>

            {/* Next Guides Row */}
            {otherPosts.length > 0 && (
              <section className="space-y-4">
                <div className="flex items-center justify-between gap-2">
                  <h2 className="text-lg font-extrabold text-ocean-navy">
                    {locale === "ar" ? "اقرأ أيضاً من المدونة" : "Continue Reading"}
                  </h2>
                  <Link
                    href="/blog/"
                    className="inline-flex items-center gap-1 text-sm font-extrabold text-ocean-primary hover:underline"
                  >
                    <span>{locale === "ar" ? "كل الأدلة" : "All Guides"}</span>
                    <ArrowRight className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
                  </Link>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  {otherPosts.map((op) => (
                    <Link
                      key={op.slug}
                      href={`/blog/${op.slug}/`}
                      className="group rounded-2xl bg-white border border-ocean-border p-3.5 flex items-center gap-3.5 shadow-sm [@media(hover:hover)]:hover:border-ocean-primary transition-colors"
                    >
                      <img
                        src={op.image}
                        alt={locale === "ar" ? op.titleAr : op.titleEn}
                        width={84}
                        height={68}
                        className="w-20 h-16 rounded-xl object-cover shrink-0"
                      />
                      <div className="min-w-0">
                        <span className="text-[11px] font-extrabold text-ocean-primary">
                          {locale === "ar" ? op.categoryAr : op.categoryEn}
                        </span>
                        <p className="text-sm font-extrabold text-ocean-navy line-clamp-2 group-hover:text-ocean-primary leading-snug mt-0.5">
                          {locale === "ar" ? op.titleAr : op.titleEn}
                        </p>
                      </div>
                    </Link>
                  ))}
                </div>
              </section>
            )}
          </div>

          {/* Sticky Action Sidebar (4 cols) */}
          <aside className="lg:col-span-4 lg:sticky lg:top-24 space-y-5">
            {relatedProducts.length > 0 && (
              <div className="rounded-[1.75rem] bg-white border border-ocean-border p-5 space-y-4 shadow-[0_8px_28px_rgba(7,26,47,0.05)]">
                <div className="flex items-center justify-between gap-2">
                  <h2 className="text-base sm:text-lg font-extrabold text-ocean-navy">
                    {locale === "ar" ? "مستلزمات مقترحة" : "Recommended Gear"}
                  </h2>
                  <Link
                    href="/shop/"
                    className="inline-flex items-center gap-1 text-xs font-extrabold text-ocean-primary hover:underline"
                  >
                    <span>{locale === "ar" ? "المتجر" : "Store"}</span>
                    <ArrowRight className="w-3.5 h-3.5 rtl:rotate-180" aria-hidden="true" />
                  </Link>
                </div>

                <div className="space-y-3">
                  {relatedProducts.map((item) => {
                    const isAdded = addedId === item.id;
                    return (
                      <div
                        key={item.id}
                        className="rounded-2xl border border-ocean-border p-2.5 flex items-center justify-between gap-3 bg-ocean-ice/45"
                      >
                        <Link
                          href={`/product/${item.id}/`}
                          className="flex items-center gap-3 min-w-0 flex-1"
                        >
                          <img
                            src={item.image}
                            alt={locale === "ar" ? item.nameAr : item.nameEn}
                            width={56}
                            height={56}
                            className="w-14 h-14 rounded-xl object-cover shrink-0 bg-white"
                          />
                          <div className="min-w-0">
                            <p className="text-sm font-extrabold text-ocean-navy truncate hover:text-ocean-primary">
                              {locale === "ar" ? item.nameAr : item.nameEn}
                            </p>
                            <p className="text-xs font-extrabold text-ocean-primary tabular-nums mt-0.5">
                              {item.priceEgp} {locale === "ar" ? "ج.م" : "EGP"}
                            </p>
                          </div>
                        </Link>

                        <button
                          type="button"
                          onClick={() => handleAdd(item)}
                          aria-label={locale === "ar" ? "أضف للسلة" : "Add to bag"}
                          className={`min-w-[44px] h-11 rounded-xl px-3 inline-flex items-center justify-center gap-1 text-xs font-extrabold shrink-0 transition-colors cursor-pointer ${
                            isAdded
                              ? "bg-ocean-whatsapp text-white"
                              : "bg-ocean-yellow [@media(hover:hover)]:hover:bg-ocean-yellow-hover text-ocean-navy"
                          }`}
                        >
                          {isAdded ? (
                            <Check className="w-4 h-4" aria-hidden="true" />
                          ) : (
                            <Plus className="w-4 h-4" aria-hidden="true" />
                          )}
                        </button>
                      </div>
                    );
                  })}
                </div>
              </div>
            )}

            {/* Expert & Vet Consultation Card */}
            <div className="rounded-[1.75rem] bg-gradient-to-br from-ocean-navy to-[#102E4F] text-white p-6 space-y-4 shadow-md border border-ocean-sunlit/25">
              <div className="space-y-1.5">
                <span className="inline-flex items-center gap-1.5 rounded-full bg-white/10 px-3 py-1 text-[11px] font-extrabold text-ocean-yellow">
                  <Stethoscope className="w-3.5 h-3.5" aria-hidden="true" />
                  <span>{locale === "ar" ? "دعم سريع" : "Fast Support"}</span>
                </span>
                <h2 className="text-lg font-extrabold">
                  {locale === "ar" ? "تحتاج مساعدة في حوضك؟" : "Need help with your tank?"}
                </h2>
                <p className="text-xs sm:text-sm text-ocean-muted leading-relaxed">
                  {locale === "ar"
                    ? "ابعتلنا صورة الحوض على واتساب فريق مصطفى عمار أو احجز استشارة بيطرية فورية."
                    : "Send a photo of your tank on WhatsApp or book a quick visit with an aquatic vet."}
                </p>
              </div>

              <div className="flex flex-col gap-2.5">
                <a
                  href={expertWhatsappUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-full min-h-[48px] inline-flex items-center justify-center gap-2 rounded-xl bg-ocean-whatsapp [@media(hover:hover)]:hover:opacity-95 text-white font-extrabold text-sm px-4 cursor-pointer"
                >
                  <MessageCircle className="w-4 h-4" aria-hidden="true" />
                  <span>{locale === "ar" ? "استشرنا واتساب" : "Ask on WhatsApp"}</span>
                </a>
                <Link
                  href="/vets/"
                  className="w-full min-h-[44px] inline-flex items-center justify-center gap-2 rounded-xl bg-white/10 [@media(hover:hover)]:hover:bg-white/20 text-white font-bold text-xs px-4 transition-colors"
                >
                  <span>{locale === "ar" ? "تصفح الأطباء البيطريين" : "Browse Aquatic Vets"}</span>
                </Link>
              </div>
            </div>
          </aside>
        </div>
      </main>
      <Footer />
      <MobileActionBar />
    </div>
  );
}
