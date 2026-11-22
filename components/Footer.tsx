"use client";

import React from "react";
import Link from "next/link";
import { Globe } from "lucide-react";
import { contactInfo } from "@/lib/contact";
import { useLanguage } from "./LanguageProvider";

export function Footer() {
  const { locale, t, toggleLocale } = useLanguage();
  const brandName = locale === "ar" ? "مصطفى عمار للأكواريوم" : "Mostafa Ammar Aquatics";
  const description =
    locale === "ar"
      ? "أسماك زينة، سلاحف مائية، أحواض ومستلزمات، ورعاية بيطرية معتمدة."
      : "Ornamental fish, aquatic turtles, tanks, gear, and certified vet care.";

  const socials = [
    { label: "Facebook", href: contactInfo.facebookUrl, icon: "/social/facebook.png", bgClass: "" },
    { label: "Instagram", href: contactInfo.instagramUrl, icon: "/social/instagram.png", bgClass: "" },
    { label: "TikTok", href: contactInfo.tiktokUrl, icon: "/social/tik-tok.png", bgClass: "ring-white/25" },
    {
      label: "WhatsApp",
      href: `https://wa.me/${contactInfo.whatsappNumber}`,
      icon: "/social/whatsapp.png",
      bgClass: "bg-[#25D366] p-1.5",
      imgClass: "brightness-0 invert",
    },
  ];

  return (
    <footer className="bg-ocean-navy text-white border-t border-white/10 pb-20 md:pb-5">
      <div className="mx-auto max-w-[1560px] px-4 sm:px-6 pt-6 text-center space-y-2.5">
        {/* Centered Compact Brand Name */}
        <div className="flex items-center justify-center gap-2.5">
          <img
            src="/logo.webp"
            alt={brandName}
            width={36}
            height={36}
            className="w-9 h-9 object-contain"
          />
          <h2 className="text-lg sm:text-xl font-extrabold tracking-tight text-white">
            {brandName}
          </h2>
        </div>

        {/* Centered Single-Line Description */}
        <p className="mx-auto max-w-lg text-xs sm:text-sm text-ocean-muted/85">
          {description}
        </p>

        {/* Centered Social Logos */}
        <div className="flex items-center justify-center gap-3 pt-1">
          <a
            href={contactInfo.youtubeUrl}
            target="_blank"
            rel="noopener noreferrer"
            aria-label="YouTube"
            className="w-9 h-9 rounded-full bg-[#FF0000] text-white ring-1 ring-white/20 [@media(hover:hover)]:hover:ring-ocean-yellow [@media(hover:hover)]:hover:scale-105 flex items-center justify-center transition-all cursor-pointer"
          >
            <svg viewBox="0 0 24 24" className="w-4.5 h-4.5 fill-current" aria-hidden="true">
              <path d="M21.8 8s-.2-1.4-.8-2c-.8-.8-1.6-.8-2-.9C16.2 5 12 5 12 5h0s-4.2 0-7 .1c-.4.1-1.2.1-2 .9-.6.6-.8 2-.8 2S2 9.6 2 11.2v1.5C2 14.4 2.2 16 2.2 16s.2 1.4.8 2c.8.8 1.8.8 2.2.9 1.6.1 6.8.1 6.8.1s4.2 0 7-.1c.4-.1 1.2-.1 2-.9.6-.6.8-2 .8-2s.2-1.6.2-3.3v-1.5C22 9.6 21.8 8 21.8 8zM10 14.6V9.2l5.2 2.7-5.2 2.7z" />
            </svg>
          </a>
          {socials.map((s) => (
            <a
              key={s.label}
              href={s.href}
              target="_blank"
              rel="noopener noreferrer"
              aria-label={s.label}
              className={`w-9 h-9 rounded-full overflow-hidden ring-1 ring-white/20 [@media(hover:hover)]:hover:ring-ocean-yellow [@media(hover:hover)]:hover:scale-105 flex items-center justify-center transition-all cursor-pointer ${s.bgClass}`}
            >
              <img
                src={s.icon}
                alt={s.label}
                width={36}
                height={36}
                className={`w-full h-full object-contain ${s.imgClass ?? ""}`}
              />
            </a>
          ))}
        </div>

        {/* Bottom Bar: Quick Links + Language Switch + Copyright */}
        <div className="mt-4 pt-3.5 border-t border-white/10 flex flex-col sm:flex-row items-center justify-between md:pe-64 gap-2 text-xs sm:text-sm text-ocean-muted/75">
          <p>{t.footer.rights}</p>

          <nav className="flex flex-wrap items-center justify-center gap-1" aria-label="Footer navigation">
            <Link
              href="/shop/"
              className="min-h-[40px] inline-flex items-center px-2.5 font-bold [@media(hover:hover)]:hover:text-ocean-yellow transition-colors"
            >
              {t.nav.products}
            </Link>
            <Link
              href="/vets/"
              className="min-h-[40px] inline-flex items-center px-2.5 font-bold [@media(hover:hover)]:hover:text-ocean-yellow transition-colors"
            >
              {t.nav.vets}
            </Link>
            <Link
              href="/blog/"
              className="min-h-[40px] inline-flex items-center px-2.5 font-bold [@media(hover:hover)]:hover:text-ocean-yellow transition-colors"
            >
              {t.nav.blog}
            </Link>
            <Link
              href="/#contact"
              className="min-h-[40px] inline-flex items-center px-2.5 font-bold [@media(hover:hover)]:hover:text-ocean-yellow transition-colors"
            >
              {locale === "ar" ? "تواصل" : "Contact"}
            </Link>
            <button
              type="button"
              onClick={toggleLocale}
              className="min-h-[40px] min-w-[40px] inline-flex items-center justify-center gap-1.5 rounded-full bg-white/10 [@media(hover:hover)]:hover:bg-white/20 border border-white/20 px-3 text-xs sm:text-sm font-bold text-white transition-colors cursor-pointer"
            >
              <Globe className="w-3.5 h-3.5" strokeWidth={1.75} aria-hidden="true" />
              <span>{t.nav.langSwitch}</span>
            </button>
          </nav>
        </div>
      </div>
    </footer>
  );
}
