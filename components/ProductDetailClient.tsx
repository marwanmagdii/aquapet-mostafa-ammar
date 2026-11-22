"use client";

import React, { useState } from "react";
import Link from "next/link";
import {
  ArrowLeft,
  Check,
  ChevronRight,
  Minus,
  Plus,
  ShieldCheck,
  Sparkles,
  Star,
  Truck,
  Zap,
} from "lucide-react";
import { useCart } from "@/components/CartProvider";
import { Footer } from "@/components/Footer";
import { Header } from "@/components/Header";
import { useLanguage } from "@/components/LanguageProvider";
import { MobileActionBar } from "@/components/MobileActionBar";
import { categories, products, type Product } from "@/lib/products";

export function ProductDetailClient({ product }: { product: Product }) {
  const { locale, t } = useLanguage();
  const { items, addItem, updateQty, buyNow } = useCart();
  const [selectedQty, setSelectedQty] = useState(1);
  const [addedToast, setAddedToast] = useState(false);

  const name = locale === "ar" ? product.nameAr : product.nameEn;
  const detail = locale === "ar" ? product.detailAr : product.detailEn;
  const spec = locale === "ar" ? product.specAr : product.specEn;
  const catMeta = categories.find((c) => c.id === product.category);
  const catName = catMeta ? (locale === "ar" ? catMeta.nameAr : catMeta.nameEn) : "";
  const inBag = items.find((i) => i.product.id === product.id)?.qty || 0;

  const related = products
    .filter((p) => p.id !== product.id)
    .sort((a, b) => (a.category === product.category ? -1 : 1) - (b.category === product.category ? -1 : 1))
    .slice(0, 4);

  const handleAdd = () => {
    if (inBag === 0) {
      addItem(product, false);
      if (selectedQty > 1) {
        updateQty(product.id, selectedQty - 1);
      }
    } else {
      updateQty(product.id, selectedQty);
    }
    setAddedToast(true);
    setTimeout(() => setAddedToast(false), 1800);
  };

  const specsTable =
    locale === "ar"
      ? [
          { label: "القسم", value: catName },
          { label: "المواصفات الفنية", value: spec },
          { label: "حالة التوفر", value: "متوفر في المخزن — جاهز للشحن" },
          { label: "التغليف والتوصيل", value: "تغليف حراري ومزود بالأكسجين النقي" },
        ]
      : [
          { label: "Department", value: catName },
          { label: "Technical Specs", value: spec },
          { label: "Availability", value: "In Stock — Ready to ship" },
          { label: "Packaging", value: "Thermal & pure-oxygen sealed packaging" },
        ];

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
          <Link href="/shop/" className="hover:text-ocean-primary transition-colors">
            {locale === "ar" ? "المتجر" : "Store"}
          </Link>
          <ChevronRight className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
          <span className="text-ocean-navy">{name}</span>
        </nav>

        {/* Main Product Section */}
        <div className="rounded-[2.25rem] bg-white border border-ocean-border p-5 sm:p-8 lg:p-10 shadow-sm grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-start">
          {/* Left: Studio Image Stage */}
          <div className="lg:col-span-6 space-y-4">
            <div className="relative aspect-[4/3] w-full rounded-3xl bg-ocean-navy overflow-hidden border border-ocean-border">
              <img
                src={product.image}
                alt={name}
                className="w-full h-full object-cover"
              />
              <div
                className="pointer-events-none absolute inset-0 shadow-[inset_0_0_36px_rgba(7,26,47,0.4)]"
                aria-hidden="true"
              />
              <div className="absolute top-4 inset-x-4 flex items-center justify-between">
                {product.bestSeller ? (
                  <span className="inline-flex items-center gap-1.5 rounded-full bg-ocean-yellow text-ocean-navy px-4 py-1.5 text-xs font-extrabold shadow-md">
                    <Star className="w-4 h-4 fill-ocean-navy" aria-hidden="true" />
                    <span>{t.products.bestSeller}</span>
                  </span>
                ) : (
                  <span className="inline-flex items-center gap-1.5 rounded-full bg-ocean-primary text-white px-3.5 py-1 text-xs font-extrabold">
                    <Sparkles className="w-3.5 h-3.5" aria-hidden="true" />
                    <span>{catName}</span>
                  </span>
                )}
                <span className="rounded-full bg-ocean-whatsapp text-white px-3.5 py-1 text-xs font-extrabold shadow-sm">
                  {locale === "ar" ? "متوفر الآن" : "In Stock"}
                </span>
              </div>
            </div>

            {/* Trust Guarantees under image */}
            <div className="grid grid-cols-2 gap-3">
              <div className="rounded-2xl bg-ocean-ice border border-ocean-border p-3.5 flex items-center gap-3">
                <ShieldCheck className="w-6 h-6 text-ocean-primary shrink-0" strokeWidth={1.75} />
                <span className="text-xs sm:text-sm font-bold text-ocean-navy">
                  {locale === "ar" ? "ضمان وصول حي وبصحة 100%" : "100% Live Arrival Guarantee"}
                </span>
              </div>
              <div className="rounded-2xl bg-ocean-ice border border-ocean-border p-3.5 flex items-center gap-3">
                <Truck className="w-6 h-6 text-ocean-primary shrink-0" strokeWidth={1.75} />
                <span className="text-xs sm:text-sm font-bold text-ocean-navy">
                  {locale === "ar" ? "شحن مجاني للطلبات فوق 500 ج.م" : "Free shipping over 500 EGP"}
                </span>
              </div>
            </div>
          </div>

          {/* Right: Product Info & Buy Controls */}
          <div className="lg:col-span-6 space-y-6">
            <div>
              <div className="flex flex-wrap items-center gap-3 mb-2">
                <span className="rounded-full bg-ocean-muted text-ocean-primary px-3 py-1 text-xs font-extrabold">
                  {catName}
                </span>
                <span className="inline-flex items-center gap-1 text-sm font-extrabold text-ocean-navy">
                  <Star className="w-4 h-4 fill-ocean-yellow text-ocean-yellow" aria-hidden="true" />
                  <span>{product.rating.toFixed(1)}</span>
                  <span className="text-ocean-slate font-semibold">
                    ({product.reviews} {locale === "ar" ? "تقييم" : "reviews"})
                  </span>
                </span>
              </div>

              <h1 className="text-2xl sm:text-4xl font-extrabold text-ocean-navy leading-tight">
                {name}
              </h1>
              <p className="mt-2 text-base sm:text-lg text-ocean-slate font-medium">
                {detail}
              </p>
            </div>

            {/* Price Block */}
            <div className="rounded-2xl bg-ocean-ice border border-ocean-border p-4 flex items-baseline justify-between gap-4">
              <div className="tabular-nums flex items-baseline gap-2.5">
                <span className="text-3xl sm:text-4xl font-extrabold text-ocean-primary">
                  {product.priceEgp.toLocaleString(locale === "ar" ? "ar-EG" : "en-US")}
                </span>
                <span className="text-base font-extrabold text-ocean-navy">
                  {t.products.currency}
                </span>
                {product.oldPriceEgp && (
                  <span className="text-base text-ocean-slate/70 line-through">
                    {product.oldPriceEgp} {t.products.currency}
                  </span>
                )}
              </div>
              {product.oldPriceEgp && (
                <span className="rounded-full bg-ocean-yellow text-ocean-navy px-3 py-1 text-xs font-extrabold">
                  {locale === "ar"
                    ? `وفر ${product.oldPriceEgp - product.priceEgp} ج.م`
                    : `Save ${product.oldPriceEgp - product.priceEgp} EGP`}
                </span>
              )}
            </div>

            {/* Technical Specs Table */}
            <div className="rounded-2xl border border-ocean-border divide-y divide-ocean-muted overflow-hidden">
              {specsTable.map((row) => (
                <div
                  key={row.label}
                  className="px-4 py-3 flex items-center justify-between gap-4 text-sm bg-white"
                >
                  <span className="font-bold text-ocean-slate">{row.label}</span>
                  <span className="font-extrabold text-ocean-navy text-end">{row.value}</span>
                </div>
              ))}
            </div>

            {/* Quantity + Add to Cart / Buy Now */}
            <div className="space-y-3 pt-2">
              <div className="flex items-center gap-4">
                <span className="text-sm font-extrabold text-ocean-navy">
                  {locale === "ar" ? "الكمية:" : "Quantity:"}
                </span>
                <div className="inline-flex items-center gap-2 rounded-full bg-ocean-ice border border-ocean-border p-1">
                  <button
                    type="button"
                    onClick={() => setSelectedQty((q) => Math.max(1, q - 1))}
                    className="w-10 h-10 rounded-full bg-white text-ocean-navy flex items-center justify-center cursor-pointer"
                    aria-label={locale === "ar" ? "تقليل" : "Decrease"}
                  >
                    <Minus className="w-4 h-4" />
                  </button>
                  <span className="w-8 text-center text-base font-extrabold tabular-nums">
                    {selectedQty}
                  </span>
                  <button
                    type="button"
                    onClick={() => setSelectedQty((q) => q + 1)}
                    className="w-10 h-10 rounded-full bg-white text-ocean-navy flex items-center justify-center cursor-pointer"
                    aria-label={locale === "ar" ? "زيادة" : "Increase"}
                  >
                    <Plus className="w-4 h-4" />
                  </button>
                </div>
                {inBag > 0 && (
                  <span className="text-sm font-extrabold text-ocean-whatsapp">
                    {locale === "ar" ? `(${inBag} في السلة حالياً)` : `(${inBag} in cart)`}
                  </span>
                )}
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <button
                  type="button"
                  onClick={handleAdd}
                  className="min-h-[54px] inline-flex items-center justify-center gap-2 rounded-2xl bg-ocean-primary hover:bg-ocean-primary-hover text-white font-extrabold text-base px-6 shadow-sm transition-transform active:scale-[0.98] cursor-pointer"
                >
                  {addedToast ? (
                    <>
                      <Check className="w-5 h-5" strokeWidth={2.25} />
                      <span>{locale === "ar" ? "تمت الإضافة للسلة" : "Added to Cart"}</span>
                    </>
                  ) : (
                    <>
                      <Plus className="w-5 h-5" strokeWidth={2.25} />
                      <span>{locale === "ar" ? "أضف إلى السلة" : "Add to Cart"}</span>
                    </>
                  )}
                </button>

                <button
                  type="button"
                  onClick={() => buyNow(product, selectedQty)}
                  className="min-h-[54px] inline-flex items-center justify-center gap-2 rounded-2xl bg-ocean-yellow hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-base px-6 shadow-md transition-transform active:scale-[0.98] cursor-pointer"
                >
                  <Zap className="w-5 h-5" strokeWidth={2} />
                  <span>{locale === "ar" ? "اشترِ الآن فوراً" : "Buy Now"}</span>
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* Related Products */}
        <section className="mt-14">
          <div className="flex items-center justify-between gap-4 mb-6">
            <h2 className="text-2xl sm:text-3xl font-extrabold text-ocean-navy">
              {locale === "ar" ? "منتجات مشابهة قد تعجبك" : "Related Products"}
            </h2>
            <Link
              href="/shop/"
              className="inline-flex items-center gap-1.5 text-sm font-extrabold text-ocean-primary hover:underline"
            >
              <span>{locale === "ar" ? "العودة للمتجر" : "Back to Store"}</span>
              <ArrowLeft className="w-4 h-4 ltr:rotate-180" />
            </Link>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            {related.map((rel) => {
              const rName = locale === "ar" ? rel.nameAr : rel.nameEn;
              const rDetail = locale === "ar" ? rel.detailAr : rel.detailEn;
              return (
                <Link
                  key={rel.id}
                  href={`/product/${rel.id}/`}
                  className="group rounded-3xl bg-white border border-ocean-border p-3 flex flex-col justify-between shadow-sm hover:-translate-y-1 transition-transform"
                >
                  <div>
                    <div className="aspect-[4/3] rounded-2xl bg-ocean-navy overflow-hidden mb-3">
                      <img
                        src={rel.image}
                        alt={rName}
                        loading="lazy"
                        className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                      />
                    </div>
                    <h3 className="text-base font-extrabold text-ocean-navy">{rName}</h3>
                    <p className="text-sm text-ocean-slate mt-0.5">{rDetail}</p>
                  </div>
                  <div className="mt-3 pt-2.5 border-t border-ocean-ice flex items-center justify-between">
                    <span className="text-lg font-extrabold text-ocean-primary tabular-nums">
                      {rel.priceEgp} {t.products.currency}
                    </span>
                    <span className="text-xs font-extrabold text-ocean-navy bg-ocean-yellow px-3 py-1 rounded-full">
                      {locale === "ar" ? "عرض" : "View"}
                    </span>
                  </div>
                </Link>
              );
            })}
          </div>
        </section>
      </main>
      <Footer />
      <MobileActionBar />
    </div>
  );
}
