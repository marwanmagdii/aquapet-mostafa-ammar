"use client";

import React, { useMemo, useState } from "react";
import Link from "next/link";
import { Check, ChevronRight, Plus, Search, ShoppingBag, Star, X, Zap } from "lucide-react";
import { useCart } from "@/components/CartProvider";
import { Footer } from "@/components/Footer";
import { Header } from "@/components/Header";
import { useLanguage } from "@/components/LanguageProvider";
import { MobileActionBar } from "@/components/MobileActionBar";
import { categories, products, type ProductCategory } from "@/lib/products";

type SortMode = "featured" | "price-asc" | "price-desc";

export default function ShopPage() {
  const { locale, t } = useLanguage();
  const { items, addItem, buyNow, setDrawerOpen, totalCount, totalPrice } = useCart();

  const [query, setQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<ProductCategory | "all">("all");
  const [sortBy, setSortBy] = useState<SortMode>("featured");

  const filteredProducts = useMemo(() => {
    const q = query.trim().toLowerCase();
    const list = products.filter((p) => {
      if (selectedCategory !== "all" && p.category !== selectedCategory) return false;
      if (!q) return true;
      return (
        p.nameAr.toLowerCase().includes(q) ||
        p.nameEn.toLowerCase().includes(q) ||
        p.detailAr.toLowerCase().includes(q) ||
        p.detailEn.toLowerCase().includes(q) ||
        p.specAr.toLowerCase().includes(q) ||
        p.specEn.toLowerCase().includes(q)
      );
    });

    if (sortBy === "price-asc") {
      return [...list].sort((a, b) => a.priceEgp - b.priceEgp);
    }
    if (sortBy === "price-desc") {
      return [...list].sort((a, b) => b.priceEgp - a.priceEgp);
    }
    return list;
  }, [query, selectedCategory, sortBy]);

  return (
    <div className="min-h-screen flex flex-col bg-ocean-ice text-ocean-navy">
      <Header />
      <main className="flex-1 pt-24 pb-16 px-4 sm:px-6 max-w-[1560px] mx-auto w-full">
        {/* Breadcrumb */}
        <nav
          className="flex items-center gap-2 text-sm font-bold text-ocean-slate mb-4"
          aria-label="Breadcrumb"
        >
          <Link href="/" className="hover:text-ocean-primary transition-colors">
            {locale === "ar" ? "الرئيسية" : "Home"}
          </Link>
          <ChevronRight className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
          <span className="text-ocean-navy">{locale === "ar" ? "المتجر" : "Shop"}</span>
        </nav>

        {/* Top Store Bar */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
          <div>
            <h1 className="text-3xl sm:text-4xl font-extrabold text-ocean-navy tracking-tight">
              {locale === "ar" ? "متجر مصطفى عمار" : "Mostafa Ammar Store"}
            </h1>
            <p className="mt-1 text-base text-ocean-slate font-medium">
              {locale === "ar"
                ? `${filteredProducts.length} منتج متاح للشراء الفوري`
                : `${filteredProducts.length} products in stock`}
            </p>
          </div>

          {totalCount > 0 && (
            <button
              type="button"
              onClick={() => setDrawerOpen(true)}
              className="min-h-[48px] inline-flex items-center justify-center gap-2 rounded-full bg-ocean-yellow [@media(hover:hover)]:hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-base px-6 shadow-md cursor-pointer"
            >
              <ShoppingBag className="w-5 h-5" strokeWidth={1.75} aria-hidden="true" />
              <span className="tabular-nums">
                {locale === "ar" ? "إتمام الشراء" : "Checkout"} ({totalCount} •{" "}
                {totalPrice.toLocaleString(locale === "ar" ? "ar-EG" : "en-US")}{" "}
                {t.products.currency})
              </span>
            </button>
          )}
        </div>

        {/* Search + Sort Bar */}
        <div className="rounded-2xl bg-white border border-ocean-border p-3 sm:p-4 mb-6 flex flex-col md:flex-row items-stretch md:items-center gap-3 shadow-sm">
          <div className="relative flex-1">
            <Search
              className="w-5 h-5 text-ocean-slate absolute top-1/2 -translate-y-1/2 start-3.5 pointer-events-none"
              strokeWidth={1.75}
              aria-hidden="true"
            />
            <input
              type="search"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder={
                locale === "ar"
                  ? "ابحث عن سمك، سلحفاة، حوض، أكل، فلتر..."
                  : "Search fish, turtle, tank, food, filter..."
              }
              className="w-full min-h-[48px] rounded-xl bg-ocean-ice border border-ocean-border ps-11 pe-10 text-base text-ocean-navy placeholder:text-ocean-slate/70"
            />
            {query && (
              <button
                type="button"
                onClick={() => setQuery("")}
                aria-label={locale === "ar" ? "مسح البحث" : "Clear search"}
                className="w-9 h-9 rounded-full flex items-center justify-center text-ocean-slate hover:text-ocean-navy absolute top-1/2 -translate-y-1/2 end-1.5 cursor-pointer"
              >
                <X className="w-4 h-4" aria-hidden="true" />
              </button>
            )}
          </div>

          <select
            value={sortBy}
            onChange={(e) => setSortBy(e.target.value as SortMode)}
            aria-label={locale === "ar" ? "ترتيب حسب" : "Sort by"}
            className="min-h-[48px] rounded-xl bg-ocean-ice border border-ocean-border px-4 text-base font-bold text-ocean-navy cursor-pointer"
          >
            <option value="featured">{locale === "ar" ? "الأكثر طلباً" : "Sort: Featured"}</option>
            <option value="price-asc">
              {locale === "ar" ? "السعر: من الأقل للأعلى" : "Price: Low to High"}
            </option>
            <option value="price-desc">
              {locale === "ar" ? "السعر: من الأعلى للأقل" : "Price: High to Low"}
            </option>
          </select>
        </div>

        {/* Category Pills */}
        <div className="flex flex-wrap items-center gap-2 mb-8">
          <button
            type="button"
            onClick={() => setSelectedCategory("all")}
            className={`min-h-[44px] rounded-full px-4 text-sm sm:text-base font-bold transition-colors cursor-pointer ${
              selectedCategory === "all"
                ? "bg-ocean-primary text-white"
                : "bg-white border border-ocean-border text-ocean-navy hover:bg-ocean-muted"
            }`}
          >
            {locale === "ar" ? "الكل (12)" : "All (12)"}
          </button>
          {categories.map((cat) => (
            <button
              key={cat.id}
              type="button"
              onClick={() => setSelectedCategory(cat.id)}
              className={`min-h-[44px] rounded-full px-4 text-sm sm:text-base font-bold transition-colors cursor-pointer ${
                selectedCategory === cat.id
                  ? "bg-ocean-primary text-white"
                  : "bg-white border border-ocean-border text-ocean-navy hover:bg-ocean-muted"
              }`}
            >
              {locale === "ar" ? cat.nameAr : cat.nameEn}
            </button>
          ))}
        </div>

        {/* Product Grid */}
        {filteredProducts.length === 0 ? (
          <div className="rounded-3xl bg-white border border-ocean-border p-12 text-center">
            <p className="text-lg font-extrabold text-ocean-navy">
              {locale === "ar" ? "لا توجد نتائج مطابقة لبحثك" : "No matching products found"}
            </p>
            <button
              type="button"
              onClick={() => {
                setQuery("");
                setSelectedCategory("all");
              }}
              className="mt-4 min-h-[48px] rounded-full bg-ocean-primary text-white font-bold px-6 cursor-pointer"
            >
              {locale === "ar" ? "عرض كل المنتجات" : "Show all products"}
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredProducts.map((product) => {
              const name = locale === "ar" ? product.nameAr : product.nameEn;
              const detail = locale === "ar" ? product.detailAr : product.detailEn;
              const spec = locale === "ar" ? product.specAr : product.specEn;
              const isBest = Boolean(product.bestSeller);
              const inBag = items.find((i) => i.product.id === product.id)?.qty || 0;

              return (
                <article
                  key={product.id}
                  className={`group rounded-3xl p-1.5 transition-transform duration-200 [@media(hover:hover)]:hover:-translate-y-1 ${
                    isBest
                      ? "bg-gradient-to-b from-ocean-yellow to-ocean-yellow-hover shadow-md"
                      : "bg-white border border-ocean-border shadow-sm"
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
                          className="w-full h-full object-cover transition-transform duration-300 [@media(hover:hover)]:group-hover:scale-105"
                        />
                        <div className="absolute top-2.5 inset-x-2.5 flex items-center justify-between">
                          {isBest ? (
                            <span className="inline-flex items-center gap-1 rounded-full bg-ocean-yellow text-ocean-navy px-3 py-1 text-xs font-extrabold">
                              <Star className="w-3.5 h-3.5 fill-ocean-navy" aria-hidden="true" />
                              <span>{t.products.bestSeller}</span>
                            </span>
                          ) : product.oldPriceEgp ? (
                            <span className="inline-flex items-center rounded-full bg-ocean-whatsapp text-white px-3 py-1 text-xs font-extrabold">
                              {locale === "ar"
                                ? `وفر ${product.oldPriceEgp - product.priceEgp} ج.م`
                                : `Save ${product.oldPriceEgp - product.priceEgp} EGP`}
                            </span>
                          ) : (
                            <span />
                          )}
                          <span className="rounded-full bg-ocean-navy/80 text-ocean-sunlit px-2.5 py-1 text-[11px] font-bold">
                            {locale === "ar" ? "متوفر" : "In Stock"}
                          </span>
                        </div>
                      </Link>
                      <div className="p-5">
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
                        <Link href={`/product/${product.id}/`} className="block">
                          <h2 className="text-lg font-extrabold text-ocean-navy hover:text-ocean-primary leading-snug">
                            {name}
                          </h2>
                        </Link>
                        <p className="mt-1 text-base text-ocean-slate">{detail}</p>
                      </div>
                    </div>

                    <div className="px-5 pb-5 pt-3 border-t border-ocean-ice space-y-3">
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

                      <div className="grid grid-cols-5 gap-2">
                        <button
                          type="button"
                          onClick={() => addItem(product, false)}
                          className={`col-span-3 min-h-[48px] inline-flex items-center justify-center gap-1.5 rounded-xl font-extrabold text-sm px-3 transition-colors active:scale-[0.96] cursor-pointer ${
                            inBag > 0
                              ? "bg-ocean-whatsapp text-white"
                              : "bg-ocean-primary hover:bg-ocean-primary-hover text-white"
                          }`}
                        >
                          {inBag > 0 ? (
                            <>
                              <Check className="w-4 h-4" strokeWidth={2.25} aria-hidden="true" />
                              <span>
                                {locale === "ar" ? `في السلة (${inBag})` : `In Cart (${inBag})`}
                              </span>
                            </>
                          ) : (
                            <>
                              <Plus className="w-4 h-4" strokeWidth={2.25} aria-hidden="true" />
                              <span>{locale === "ar" ? "أضف للسلة" : "Add to Cart"}</span>
                            </>
                          )}
                        </button>

                        <button
                          type="button"
                          onClick={() => buyNow(product)}
                          className="col-span-2 min-h-[48px] inline-flex items-center justify-center gap-1 rounded-xl bg-ocean-yellow hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-sm px-3 transition-colors active:scale-[0.96] cursor-pointer"
                        >
                          <Zap className="w-4 h-4" strokeWidth={2} aria-hidden="true" />
                          <span>{locale === "ar" ? "اشترِ الآن" : "Buy Now"}</span>
                        </button>
                      </div>
                    </div>
                  </div>
                </article>
              );
            })}
          </div>
        )}
      </main>
      <Footer />
      <MobileActionBar />
    </div>
  );
}
