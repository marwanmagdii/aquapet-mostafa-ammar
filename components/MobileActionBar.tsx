"use client";

import React from "react";
import Link from "next/link";
import { ShoppingBag, Store } from "lucide-react";
import { useCart } from "./CartProvider";
import { useLanguage } from "./LanguageProvider";

export function MobileActionBar() {
  const { locale, t } = useLanguage();
  const { totalCount, totalPrice, setDrawerOpen } = useCart();

  return (
    <>
      <div
        className="md:hidden fixed bottom-0 inset-x-0 z-40 bg-ocean-ice/95 backdrop-blur-lg border-t border-ocean-border px-4 py-2.5 flex items-center gap-3 shadow-[0_-8px_24px_rgba(42,108,165,0.12)]"
        role="region"
        aria-label={locale === "ar" ? "شريط التسوق السريع" : "Quick shopping bar"}
      >
        <button
          type="button"
          onClick={() => setDrawerOpen(true)}
          className="flex-1 min-h-[48px] inline-flex items-center justify-center gap-2 rounded-full bg-ocean-primary text-white font-extrabold text-base active:scale-[0.97] transition-transform cursor-pointer shadow-sm"
        >
          <ShoppingBag className="w-5 h-5 shrink-0" strokeWidth={1.75} aria-hidden="true" />
          <span className="tabular-nums">
            {locale === "ar" ? "السلة" : "Cart"} ({totalCount})
            {totalCount > 0 ? ` • ${totalPrice} ${t.products.currency}` : ""}
          </span>
        </button>

        <Link
          href="/shop"
          className="flex-1 min-h-[48px] inline-flex items-center justify-center gap-2 rounded-full bg-ocean-yellow text-ocean-navy font-extrabold text-base active:scale-[0.97] transition-transform cursor-pointer shadow-sm"
        >
          <Store className="w-5 h-5 shrink-0" strokeWidth={1.75} aria-hidden="true" />
          <span>{locale === "ar" ? "المتجر" : "Store"}</span>
        </Link>
      </div>

      {/* Desktop Floating Cart Pill */}
      {totalCount > 0 && (
        <button
          type="button"
          onClick={() => setDrawerOpen(true)}
          className="hidden md:inline-flex fixed bottom-6 end-6 z-40 min-h-[56px] items-center gap-2.5 rounded-full bg-ocean-yellow hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-base px-6 shadow-[0_12px_32px_rgba(7,26,47,0.22)] transition-[transform,background-color] duration-200 active:scale-[0.97] cursor-pointer"
        >
          <ShoppingBag className="w-5 h-5 shrink-0" strokeWidth={2} aria-hidden="true" />
          <span className="tabular-nums">
            {locale === "ar" ? "إتمام الشراء" : "Checkout"} ({totalCount} •{" "}
            {totalPrice.toLocaleString(locale === "ar" ? "ar-EG" : "en-US")}{" "}
            {t.products.currency})
          </span>
        </button>
      )}
    </>
  );
}
