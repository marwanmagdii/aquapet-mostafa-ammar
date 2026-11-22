"use client";

import React from "react";
import { ArrowUpRight, Box, Droplets, Fish, Leaf, ShieldCheck, Truck, Utensils, Waves } from "lucide-react";
import { categories, type ProductCategory } from "@/lib/products";
import { useCategoryFilter } from "../CategoryFilterProvider";
import { useLanguage } from "../LanguageProvider";
import { SectionReveal } from "../SectionReveal";

const categoryIconMap: Record<
  ProductCategory,
  React.ComponentType<{ className?: string; strokeWidth?: number }>
> = {
  fish: Fish,
  food: Utensils,
  tanks: Box,
  filters: Waves,
  care: Droplets,
  decor: Leaf,
};

export function CategoriesSection() {
  const { locale, t } = useLanguage();
  const { selectAndScrollToProducts } = useCategoryFilter();

  const trustPills =
    locale === "ar"
      ? [
          { icon: ShieldCheck, text: "ضمان وصول الأسماك حية وبصحة ممتازة" },
          { icon: Truck, text: "شحن مجهز بالأكسجين لجميع المحافظات (مجاني فوق 500 ج.م)" },
        ]
      : [
          { icon: ShieldCheck, text: "100% Live & Healthy Arrival Guarantee" },
          { icon: Truck, text: "Oxygenated Shipping Nationwide (Free over 500 EGP)" },
        ];

  return (
    <section
      id="categories"
      className="pt-8 pb-12 sm:pt-10 sm:pb-16 px-4 sm:px-6 max-w-[1560px] mx-auto"
    >
      {/* Top Store Trust Strip */}
      <div className="mb-8 rounded-2xl bg-ocean-navy text-white px-5 py-3.5 flex flex-wrap items-center justify-between gap-4 border border-ocean-primary">
        {trustPills.map((pill, i) => {
          const Icon = pill.icon;
          return (
            <div key={i} className="inline-flex items-center gap-2.5 text-sm font-bold">
              <Icon className="w-4 h-4 text-ocean-yellow shrink-0" strokeWidth={2} aria-hidden="true" />
              <span>{pill.text}</span>
            </div>
          );
        })}
      </div>

      <SectionReveal>
        <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 mb-8">
          <div>
            <span className="inline-block rounded-full bg-ocean-muted border border-ocean-border px-3.5 py-1 text-xs font-extrabold text-ocean-primary mb-2">
              {locale === "ar" ? "تسوق حسب القسم" : "Shop by Department"}
            </span>
            <h2 className="text-3xl sm:text-4xl font-extrabold text-ocean-navy tracking-tight">
              {t.categories.title}
            </h2>
          </div>
          <p className="text-base text-ocean-slate font-semibold">{t.categories.subtitle}</p>
        </div>
      </SectionReveal>

      {/* Asymmetric Editorial Bento Grid (Buce Plant Style) */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-12 gap-4">
        {categories.map((cat, idx) => {
          const Icon = categoryIconMap[cat.id];
          const name = locale === "ar" ? cat.nameAr : cat.nameEn;
          const count = locale === "ar" ? cat.countAr : cat.countEn;

          // Bento layout spans
          const spanClass =
            idx === 0
              ? "sm:col-span-2 lg:col-span-5 lg:row-span-2 min-h-[280px] lg:min-h-[380px]"
              : idx === 1
              ? "lg:col-span-4 min-h-[185px]"
              : idx === 2
              ? "lg:col-span-3 min-h-[185px]"
              : idx === 3
              ? "lg:col-span-2 min-h-[185px]"
              : idx === 4
              ? "lg:col-span-3 min-h-[185px]"
              : "lg:col-span-2 min-h-[185px]";

          return (
            <button
              key={cat.id}
              type="button"
              onClick={() => selectAndScrollToProducts(cat.id)}
              className={`group relative overflow-hidden rounded-3xl bg-ocean-navy text-white text-start p-5 flex flex-col justify-between border border-ocean-border/60 shadow-sm transition-transform duration-300 ease-[cubic-bezier(0.22,1,0.36,1)] [@media(hover:hover)]:hover:-translate-y-1 active:scale-[0.98] cursor-pointer ${spanClass}`}
            >
              <img
                src={cat.image}
                alt={name}
                loading="lazy"
                className="absolute inset-0 w-full h-full object-cover opacity-80 transition-transform duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] [@media(hover:hover)]:group-hover:scale-105"
              />
              <div
                className="absolute inset-0 bg-gradient-to-t from-ocean-navy/95 via-ocean-navy/45 to-ocean-navy/20"
                aria-hidden="true"
              />

              <div className="relative z-10 flex items-center justify-between gap-2 w-full">
                <div className="w-10 h-10 rounded-2xl bg-white/15 backdrop-blur-md border border-white/25 flex items-center justify-center text-ocean-yellow">
                  <Icon className="w-5 h-5" strokeWidth={1.75} aria-hidden="true" />
                </div>
                <span className="rounded-full bg-ocean-navy/75 backdrop-blur-md border border-white/20 px-3 py-1 text-xs font-extrabold text-ocean-sunlit">
                  {count}
                </span>
              </div>

              <div className="relative z-10 flex items-end justify-between gap-2 w-full mt-8">
                <div>
                  <h3 className={`font-extrabold leading-snug ${idx === 0 ? "text-2xl sm:text-3xl" : "text-lg"}`}>
                    {name}
                  </h3>
                </div>
                <span className="w-9 h-9 rounded-full bg-ocean-yellow text-ocean-navy flex items-center justify-center shrink-0 transition-transform duration-200 [@media(hover:hover)]:group-hover:scale-110">
                  <ArrowUpRight className="w-4 h-4 rtl:-scale-x-100" strokeWidth={2.25} aria-hidden="true" />
                </span>
              </div>
            </button>
          );
        })}
      </div>
    </section>
  );
}
