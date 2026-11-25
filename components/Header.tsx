"use client";

import React, { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { Globe, Menu, Plus, Search, ShoppingBag, Store, X } from "lucide-react";
import { products } from "@/lib/products";
import { useCart } from "./CartProvider";
import { useLanguage } from "./LanguageProvider";

const SECTION_IDS = ["categories", "products", "why-us", "app", "vets"] as const;

export function Header() {
  const { locale, t, toggleLocale } = useLanguage();
  const { totalCount, setDrawerOpen, addItem } = useCart();
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const [activeSection, setActiveSection] = useState<string>("");
  const [searchQuery, setSearchQuery] = useState("");
  const [searchFocused, setSearchFocused] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 48);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  useEffect(() => {
    const elements = SECTION_IDS.map((id) => document.getElementById(id)).filter(
      (el): el is HTMLElement => Boolean(el)
    );
    if (elements.length === 0) return;

    const observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            setActiveSection(entry.target.id);
          }
        }
      },
      { rootMargin: "-35% 0px -55% 0px", threshold: 0 }
    );

    elements.forEach((el) => observer.observe(el));
    return () => observer.disconnect();
  }, []);

  const searchResults = useMemo(() => {
    const q = searchQuery.trim().toLowerCase();
    if (!q) return [];
    return products
      .filter(
        (p) =>
          p.nameAr.toLowerCase().includes(q) ||
          p.nameEn.toLowerCase().includes(q) ||
          p.detailAr.toLowerCase().includes(q) ||
          p.detailEn.toLowerCase().includes(q)
      )
      .slice(0, 4);
  }, [searchQuery]);

  const navLinks = [
    { id: "categories", href: "/#categories", label: t.nav.categories },
    { id: "why-us", href: "/#why-us", label: t.nav.whyUs },
    { id: "app", href: "/#app", label: t.nav.app },
    { id: "vets-page", href: "/vets/", label: t.nav.vets },
    { id: "blog-page", href: "/blog/", label: t.nav.blog },
  ];

  const brandName = locale === "ar" ? "مصطفى عمار" : "Mostafa Ammar";

  return (
    <header
      className={`fixed top-0 inset-x-0 z-40 transition-[padding] duration-300 ease-[cubic-bezier(0.32,0.72,0,1)] ${
        scrolled ? "py-2 px-3 sm:px-6" : "py-3 px-3 sm:px-6"
      }`}
    >
      <div
        className={`mx-auto max-w-[1560px] rounded-full px-3 sm:px-4 py-1 sm:py-1.5 flex items-center justify-between gap-2 sm:gap-3 transition-[background-color,border-color,color,box-shadow] duration-300 ease-[cubic-bezier(0.32,0.72,0,1)] ${
          scrolled
            ? "bg-ocean-ice md:bg-ocean-ice/95 md:backdrop-blur-xl border border-ocean-deep/25 text-ocean-navy shadow-[0_6px_18px_rgba(42,108,165,0.12)]"
            : "bg-ocean-primary-hover/95 md:bg-ocean-primary-hover/82 md:backdrop-blur-md border border-ocean-sunlit/35 text-white"
        }`}
      >
        {/* Brand */}
        <Link
          href="/"
          className="flex items-center gap-2 shrink-0 min-h-[48px] px-1 cursor-pointer group"
          aria-label={brandName}
        >
          <img
            src="/logo.webp"
            alt={brandName}
            width={38}
            height={38}
            className="w-9 h-9 object-contain transition-transform duration-200 group-hover:scale-105"
          />
          <span className="font-extrabold text-base tracking-tight whitespace-nowrap">
            {brandName}
          </span>
        </Link>

        {/* Instant Predictive Search Bar (Desktop — Competitor Pattern) */}
        <div className="hidden md:block relative flex-1 max-w-xs lg:max-w-sm">
          <Search
            className={`w-4 h-4 absolute top-1/2 -translate-y-1/2 start-3.5 pointer-events-none ${
              scrolled ? "text-ocean-slate" : "text-white/80"
            }`}
            strokeWidth={2}
            aria-hidden="true"
          />
          <input
            type="search"
            value={searchQuery}
            onFocus={() => setSearchFocused(true)}
            onBlur={() => setTimeout(() => setSearchFocused(false), 180)}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder={locale === "ar" ? "ابحث في المتجر..." : "Search store..."}
            aria-label={locale === "ar" ? "ابحث في المتجر" : "Search store"}
            className={`w-full min-h-[42px] rounded-full ps-10 pe-4 text-sm font-medium outline-none transition-colors ${
              scrolled
                ? "bg-white border border-ocean-border text-ocean-navy placeholder:text-ocean-slate/70"
                : "bg-white/18 border border-white/30 text-white placeholder:text-white/80"
            }`}
          />

          {/* Predictive Dropdown */}
          {searchFocused && searchQuery.trim().length > 0 && (
            <div className="absolute top-full mt-2 inset-x-0 rounded-2xl bg-white text-ocean-navy border border-ocean-border shadow-xl overflow-hidden z-50">
              {searchResults.length === 0 ? (
                <p className="p-4 text-sm font-bold text-ocean-slate text-center">
                  {locale === "ar" ? "لا توجد نتائج" : "No results"}
                </p>
              ) : (
                <div className="divide-y divide-ocean-muted">
                  {searchResults.map((p) => (
                    <div
                      key={p.id}
                      className="p-2.5 flex items-center justify-between gap-2 hover:bg-ocean-ice"
                    >
                      <Link
                        href={`/product/${p.id}/`}
                        className="flex items-center gap-2.5 min-w-0 flex-1"
                      >
                        <img
                          src={p.image}
                          alt={locale === "ar" ? p.nameAr : p.nameEn}
                          width={40}
                          height={30}
                          className="w-10 h-8 rounded-lg object-cover shrink-0"
                        />
                        <div className="min-w-0">
                          <p className="text-sm font-extrabold truncate hover:text-ocean-primary">
                            {locale === "ar" ? p.nameAr : p.nameEn}
                          </p>
                          <p className="text-xs font-bold text-ocean-primary tabular-nums">
                            {p.priceEgp} {t.products.currency}
                          </p>
                        </div>
                      </Link>
                      <button
                        type="button"
                        onMouseDown={(e) => {
                          e.preventDefault();
                          addItem(p);
                        }}
                        className="w-9 h-9 rounded-full bg-ocean-primary text-white flex items-center justify-center shrink-0 cursor-pointer"
                        aria-label={locale === "ar" ? "أضف للطلب" : "Add to order"}
                      >
                        <Plus className="w-4 h-4" strokeWidth={2} aria-hidden="true" />
                      </button>
                    </div>
                  ))}
                  <Link
                    href="/shop/"
                    className="block p-3 text-center text-sm font-extrabold text-ocean-primary bg-ocean-ice hover:bg-ocean-muted"
                  >
                    {locale === "ar" ? "عرض كل المنتجات في المتجر" : "View all in Store"}
                  </Link>
                </div>
              )}
            </div>
          )}
        </div>

        {/* Desktop Nav (<= 5 links) */}
        <nav className="hidden xl:flex items-center gap-1" aria-label="Main navigation">
          {navLinks.map((link) => {
            const isActive = activeSection === link.id;
            return (
              <Link
                key={link.href}
                href={link.href}
                className={`min-h-[48px] inline-flex items-center px-3 rounded-full text-sm font-bold transition-[background-color,color] duration-200 cursor-pointer whitespace-nowrap ${
                  isActive
                    ? scrolled
                      ? "bg-ocean-primary text-white"
                      : "bg-white/25 text-ocean-yellow"
                    : scrolled
                    ? "text-ocean-navy [@media(hover:hover)]:hover:bg-ocean-muted"
                    : "text-white [@media(hover:hover)]:hover:bg-white/15"
                }`}
              >
                {link.label}
              </Link>
            );
          })}
        </nav>

        {/* Actions */}
        <div className="flex items-center gap-1.5 sm:gap-2 shrink-0">
          <Link
            href="/shop/"
            className="hidden sm:inline-flex min-h-[48px] items-center gap-1.5 rounded-full bg-ocean-yellow [@media(hover:hover)]:hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-sm sm:text-base px-4 transition-[background-color,transform] duration-200 active:scale-[0.97] cursor-pointer shadow-sm"
          >
            <Store className="w-4 h-4 shrink-0" strokeWidth={2} aria-hidden="true" />
            <span>{locale === "ar" ? "المتجر" : "Shop"}</span>
          </Link>

          <button
            type="button"
            onClick={() => setDrawerOpen(true)}
            aria-label={locale === "ar" ? "سلة الطلب" : "Order bag"}
            className={`min-h-[48px] min-w-[48px] inline-flex items-center justify-center gap-1.5 rounded-full px-3 text-sm font-extrabold transition-transform active:scale-[0.97] cursor-pointer ${
              totalCount > 0
                ? "bg-ocean-whatsapp text-white shadow-sm"
                : scrolled
                ? "bg-ocean-muted text-ocean-navy"
                : "bg-white/18 text-white border border-white/30"
            }`}
          >
            <ShoppingBag className="w-4 h-4 shrink-0" strokeWidth={2} aria-hidden="true" />
            {totalCount > 0 && <span className="tabular-nums">{totalCount}</span>}
          </button>

          <button
            type="button"
            onClick={toggleLocale}
            className={`min-h-[48px] min-w-[48px] inline-flex items-center justify-center gap-1.5 rounded-full px-3 text-sm font-bold transition-[background-color,transform] duration-200 active:scale-[0.97] cursor-pointer ${
              scrolled
                ? "bg-ocean-muted text-ocean-navy [@media(hover:hover)]:hover:bg-ocean-border"
                : "bg-white/18 text-white border border-white/30 [@media(hover:hover)]:hover:bg-white/28"
            }`}
            aria-label={
              locale === "ar" ? "EN - Switch to English" : "عربي - التبديل إلى العربية"
            }
          >
            <Globe className="w-4 h-4 shrink-0" strokeWidth={1.75} aria-hidden="true" />
            <span>{t.nav.langSwitch}</span>
          </button>

          <button
            type="button"
            onClick={() => setMenuOpen((prev) => !prev)}
            className={`xl:hidden inline-flex items-center justify-center w-12 h-12 rounded-full transition-colors cursor-pointer ${
              scrolled
                ? "bg-ocean-muted text-ocean-navy [@media(hover:hover)]:hover:bg-ocean-border"
                : "bg-white/18 text-white [@media(hover:hover)]:hover:bg-white/28"
            }`}
            aria-expanded={menuOpen}
            aria-label={menuOpen ? "Close menu" : "Open menu"}
          >
            {menuOpen ? (
              <X className="w-5 h-5" strokeWidth={1.75} aria-hidden="true" />
            ) : (
              <Menu className="w-5 h-5" strokeWidth={1.75} aria-hidden="true" />
            )}
          </button>
        </div>
      </div>

      {/* Mobile Drawer */}
      {menuOpen && (
        <div className="xl:hidden mt-2 mx-auto max-w-[1560px] rounded-3xl bg-ocean-primary-hover border border-ocean-sunlit/35 p-4 text-white shadow-[0_16px_40px_rgba(7,26,47,0.24)] space-y-3">
          <div className="relative md:hidden">
            <Search
              className="w-4 h-4 absolute top-1/2 -translate-y-1/2 start-3.5 text-white/80 pointer-events-none"
              strokeWidth={2}
              aria-hidden="true"
            />
            <input
              type="search"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder={locale === "ar" ? "ابحث في المتجر..." : "Search store..."}
              aria-label={locale === "ar" ? "ابحث في المتجر" : "Search store"}
              className="w-full min-h-[44px] rounded-full ps-10 pe-4 text-sm font-medium bg-white/15 border border-white/30 text-white placeholder:text-white/75 outline-none"
            />
            {searchQuery.trim().length > 0 && searchResults.length > 0 && (
              <div className="mt-2 rounded-2xl bg-white text-ocean-navy border border-ocean-border overflow-hidden divide-y divide-ocean-muted">
                {searchResults.map((p) => (
                  <Link
                    key={p.id}
                    href={`/product/${p.id}/`}
                    onClick={() => setMenuOpen(false)}
                    className="p-2.5 flex items-center justify-between gap-2 hover:bg-ocean-ice"
                  >
                    <span className="text-sm font-extrabold truncate">
                      {locale === "ar" ? p.nameAr : p.nameEn}
                    </span>
                    <span className="text-xs font-extrabold text-ocean-primary tabular-nums shrink-0">
                      {p.priceEgp} {t.products.currency}
                    </span>
                  </Link>
                ))}
              </div>
            )}
          </div>
          <nav className="flex flex-col gap-1.5" aria-label="Mobile navigation">
            <Link
              href="/shop/"
              onClick={() => setMenuOpen(false)}
              className="min-h-[48px] inline-flex items-center justify-center gap-2 rounded-full bg-ocean-yellow text-ocean-navy font-extrabold text-base px-5 cursor-pointer"
            >
              <Store className="w-4 h-4" strokeWidth={2} aria-hidden="true" />
              <span>{locale === "ar" ? "افتح المتجر والبحث" : "Open Store & Search"}</span>
            </Link>
            {navLinks.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                onClick={() => setMenuOpen(false)}
                className="min-h-[48px] flex items-center px-4 rounded-2xl text-base font-bold text-white hover:bg-white/15 transition-colors cursor-pointer"
              >
                {link.label}
              </Link>
            ))}
          </nav>
        </div>
      )}
    </header>
  );
}
