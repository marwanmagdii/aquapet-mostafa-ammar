"use client";

import React, { useState } from "react";
import Link from "next/link";
import { ArrowRight, Check, Plus, ShoppingBag, Star, Store, Zap } from "lucide-react";
import { categories, products, type ProductCategory } from "@/lib/products";
import { useCart } from "../CartProvider";
import { useCategoryFilter } from "../CategoryFilterProvider";
import { useLanguage } from "../LanguageProvider";
import { SectionReveal } from "../SectionReveal";

export function ProductsSection() {
  const { locale, t } = useLanguage();
  const { selectedCategory, setSelectedCategory } = useCategoryFilter();
  const { items, addItem, buyNow, setDrawerOpen, totalCount, totalPrice } = useCart();
  const [showAll, setShowAll] = useState(false);

  const visibleProducts = selectedCategory
    ? products.filter((p) => p.category === selectedCategory)
    : showAll
    ? products
    : products.filter((p) => p.featured);

  return (
    <section
      id="products"
      className="py-12 sm:py-16 px-4 sm:px-6 max-w-[1560px] mx-auto"
    >
      <SectionReveal>
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-6">
          <div>
            <span className="inline-block rounded-full bg-ocean-muted border border-ocean-border px-3.5 py-1 text-xs font-extrabold text-ocean-primary mb-2">
              {locale === "ar" ? "متجر مصطفى عمار الإلكتروني" : "Online Aquatic Store"}
            </span>
            <h2 className="text-3xl sm:text-5xl font-extrabold text-ocean-navy tracking-tight">
              {t.products.title}
            </h2>
          </div>

          <div className="flex flex-wrap items-center gap-2.5">
            {totalCount > 0 && (
              <button
                type="button"
                onClick={() => setDrawerOpen(true)}
                className="min-h-[48px] inline-flex items-center gap-2 rounded-full bg-ocean-whatsapp [@media(hover:hover)]:hover:bg-ocean-whatsapp-hover text-white font-extrabold text-base px-5 shadow-md transition-transform active:scale-[0.97] cursor-pointer"
              >
                <ShoppingBag className="w-5 h-5 shrink-0" strokeWidth={1.75} aria-hidden="true" />
                <span className="tabular-nums">
                  {locale === "ar" ? "السلة:" : "Cart:"} {totalCount} ({totalPrice}{" "}
                  {t.products.currency})
                </span>
              </button>
            )}

            <Link
              href="/shop"
              className="min-h-[48px] inline-flex items-center gap-2 rounded-full bg-ocean-navy [@media(hover:hover)]:hover:bg-ocean-primary text-white font-extrabold text-base px-5 transition-colors cursor-pointer"
            >
              <Store className="w-4 h-4" strokeWidth={2} aria-hidden="true" />
              <span>{locale === "ar" ? "افتح المتجر الكامل (12)" : "Full Store (12)"}</span>
              <ArrowRight className="w-4 h-4 rtl:rotate-180" strokeWidth={2} aria-hidden="true" />
            </Link>
          </div>
        </div>

        {/* Inline Store Category Filter Tabs (Horizontal rail on mobile) */}
        <div className="flex flex-nowrap sm:flex-wrap items-center gap-2 mb-6 sm:mb-8 overflow-x-auto pb-1.5 sm:pb-0">
          <button
            type="button"
            onClick={() => {
              setSelectedCategory(null);
              setShowAll(false);
            }}
            className={`min-h-[42px] shrink-0 whitespace-nowrap rounded-full px-4 text-sm font-extrabold transition-colors cursor-pointer ${
              selectedCategory === null && !showAll
                ? "bg-ocean-primary text-white shadow-sm"
                : "bg-white border border-ocean-border text-ocean-navy hover:bg-ocean-muted"
            }`}
          >
            {locale === "ar" ? "الأكثر مبيعاً (6)" : "Featured (6)"}
          </button>
          <button
            type="button"
            onClick={() => {
              setSelectedCategory(null);
              setShowAll(true);
            }}
            className={`min-h-[42px] shrink-0 whitespace-nowrap rounded-full px-4 text-sm font-extrabold transition-colors cursor-pointer ${
              selectedCategory === null && showAll
                ? "bg-ocean-primary text-white shadow-sm"
                : "bg-white border border-ocean-border text-ocean-navy hover:bg-ocean-muted"
            }`}
          >
            {locale === "ar" ? "كل المنتجات (12)" : "All Products (12)"}
          </button>
          {categories.map((cat) => {
            const active = selectedCategory === cat.id;
            return (
              <button
                key={cat.id}
                type="button"
                onClick={() => setSelectedCategory(active ? null : (cat.id as ProductCategory))}
                className={`min-h-[42px] shrink-0 whitespace-nowrap rounded-full px-4 text-sm font-bold transition-colors cursor-pointer ${
                  active
                    ? "bg-ocean-yellow text-ocean-navy font-extrabold shadow-sm"
                    : "bg-white border border-ocean-border text-ocean-navy hover:bg-ocean-muted"
                }`}
              >
                {locale === "ar" ? cat.nameAr : cat.nameEn}
              </button>
            );
          })}
        </div>
      </SectionReveal>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        {visibleProducts.map((product) => {
          const name = locale === "ar" ? product.nameAr : product.nameEn;
          const detail = locale === "ar" ? product.detailAr : product.detailEn;
          const spec = locale === "ar" ? product.specAr : product.specEn;
          const isBest = Boolean(product.bestSeller);
          const inBag = items.find((i) => i.product.id === product.id)?.qty || 0;

          return (
            <article
              key={product.id}
              className={`group rounded-3xl p-1.5 transition-transform duration-300 ease-[cubic-bezier(0.22,1,0.36,1)] [@media(hover:hover)]:hover:-translate-y-1.5 ${
                isBest
                  ? "bg-gradient-to-b from-ocean-yellow to-ocean-yellow-hover shadow-[0_16px_40px_rgba(250,204,21,0.25)]"
                  : "bg-white border border-ocean-border shadow-[0_8px_24px_rgba(7,26,47,0.06)]"
              }`}
            >
              <div className="h-full rounded-[calc(1.5rem-0.25rem)] bg-white overflow-hidden flex flex-col justify-between">
                <div>
                  <Link
                    href={`/product/${product.id}/`}
                    className="block relative aspect-[4/3] w-full bg-ocean-navy overflow-hidden"
                  >
                    <img
                      src={product.image}
                      alt={name}
                      loading="lazy"
                      className="w-full h-full object-cover transition-transform duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] [@media(hover:hover)]:group-hover:scale-105"
                    />
                    <div
                      className="pointer-events-none absolute inset-0 shadow-[inset_0_0_24px_rgba(7,26,47,0.35)]"
                      aria-hidden="true"
                    />

                    {/* Top Badges */}
                    <div className="absolute top-3 inset-x-3 flex items-center justify-between gap-2">
                      {isBest ? (
                        <span className="inline-flex items-center gap-1 rounded-full bg-ocean-yellow text-ocean-navy px-3 py-1 text-xs font-extrabold shadow-md">
                          <Star
                            className="w-3.5 h-3.5 fill-ocean-navy"
                            strokeWidth={1.75}
                            aria-hidden="true"
                          />
                          <span>{t.products.bestSeller}</span>
                        </span>
                      ) : product.oldPriceEgp ? (
                        <span className="inline-flex items-center rounded-full bg-ocean-whatsapp text-white px-3 py-1 text-xs font-extrabold shadow-sm">
                          {locale === "ar"
                            ? `وفر ${product.oldPriceEgp - product.priceEgp} ج.م`
                            : `Save ${product.oldPriceEgp - product.priceEgp} EGP`}
                        </span>
                      ) : (
                        <span />
                      )}

                      <span className="rounded-full bg-ocean-navy/90 md:backdrop-blur-md text-ocean-sunlit px-2.5 py-1 text-[11px] font-bold">
                        {locale === "ar" ? "متوفر" : "In Stock"}
                      </span>
                    </div>
                  </Link>

                  <div className="p-5">
                    {/* Rating & Spec Row */}
                    <div className="flex items-center justify-between gap-2 text-xs font-bold text-ocean-slate mb-2">
                      <span className="inline-flex items-center gap-1 text-ocean-navy">
                        <Star className="w-3.5 h-3.5 fill-ocean-yellow text-ocean-yellow" aria-hidden="true" />
                        <span>{product.rating.toFixed(1)}</span>
                        <span className="text-ocean-slate">({product.reviews})</span>
                      </span>
                      <span className="rounded-md bg-ocean-ice px-2 py-0.5 text-ocean-primary">
                        {spec}
                      </span>
                    </div>

                    <Link href={`/product/${product.id}/`} className="block hover:text-ocean-primary transition-colors">
                      <h3 className="text-lg sm:text-xl font-extrabold text-ocean-navy hover:text-ocean-primary leading-snug">
                        {name}
                      </h3>
                    </Link>
                    <p className="mt-1 text-base text-ocean-slate">{detail}</p>
                  </div>
                </div>

                {/* Price + Store Cart Buttons */}
                <div className="px-5 pb-5 pt-3 border-t border-ocean-ice space-y-3">
                  <div className="flex items-baseline justify-between gap-2">
                    <div className="tabular-nums flex items-baseline gap-2">
                      <span className="text-2xl font-extrabold text-ocean-navy">
                        {product.priceEgp.toLocaleString(locale === "ar" ? "ar-EG" : "en-US")}
                      </span>
                      <span className="text-xs font-bold text-ocean-slate">
                        {t.products.currency}
                      </span>
                      {product.oldPriceEgp && (
                        <span className="text-sm text-ocean-slate/70 line-through">
                          {product.oldPriceEgp}
                        </span>
                      )}
                    </div>
                  </div>

                  <div className="grid grid-cols-5 gap-2">
                    <button
                      type="button"
                      onClick={() => addItem(product, false)}
                      className={`col-span-3 min-h-[48px] inline-flex items-center justify-center gap-1.5 rounded-xl font-extrabold text-sm sm:text-base px-3 transition-[background-color,transform] duration-200 active:scale-[0.96] cursor-pointer ${
                        inBag > 0
                          ? "bg-ocean-whatsapp text-white"
                          : "bg-ocean-primary [@media(hover:hover)]:hover:bg-ocean-primary-hover text-white"
                      }`}
                    >
                      {inBag > 0 ? (
                        <>
                          <Check className="w-4 h-4 shrink-0" strokeWidth={2.25} aria-hidden="true" />
                          <span>
                            {locale === "ar" ? `في السلة (${inBag})` : `In Cart (${inBag})`}
                          </span>
                        </>
                      ) : (
                        <>
                          <Plus className="w-4 h-4 shrink-0" strokeWidth={2.25} aria-hidden="true" />
                          <span>{locale === "ar" ? "أضف للسلة" : "Add to Cart"}</span>
                        </>
                      )}
                    </button>

                    <button
                      type="button"
                      onClick={() => buyNow(product)}
                      className="col-span-2 min-h-[48px] inline-flex items-center justify-center gap-1 rounded-xl bg-ocean-yellow [@media(hover:hover)]:hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-sm sm:text-base px-3 transition-[background-color,transform] duration-200 active:scale-[0.96] cursor-pointer"
                    >
                      <Zap className="w-4 h-4 shrink-0" strokeWidth={2} aria-hidden="true" />
                      <span>{locale === "ar" ? "اشترِ الآن" : "Buy Now"}</span>
                    </button>
                  </div>
                </div>
              </div>
            </article>
          );
        })}
      </div>
    </section>
  );
}
