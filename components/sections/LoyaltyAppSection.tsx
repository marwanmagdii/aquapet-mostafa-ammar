"use client";

import React, { useState } from "react";
import { Award, Bell, ShieldCheck, Smartphone, Sparkles, Wifi } from "lucide-react";
import { buildWhatsappUrl } from "@/lib/contact";
import { useLanguage } from "../LanguageProvider";
import { SectionReveal } from "../SectionReveal";

const TIER_DATA = [
  {
    pointsAr: "350 نقطة",
    pointsEn: "350 pts",
    perkAr: "خصم 5% وتنبيهات الإطعام",
    perkEn: "5% off + feeding alerts",
    pct: 34,
  },
  {
    pointsAr: "780 نقطة",
    pointsEn: "780 pts",
    perkAr: "خصم 10% وتوصيل مجاني",
    perkEn: "10% off + free delivery",
    pct: 66,
  },
  {
    pointsAr: "1,250 نقطة",
    pointsEn: "1,250 pts",
    perkAr: "خصم 15% + أولوية الكشف",
    perkEn: "15% off + priority vet",
    pct: 90,
  },
];

export function LoyaltyAppSection() {
  const { locale, t } = useLanguage();
  const [activeTier, setActiveTier] = useState<number>(2);

  const earlyAccessUrl = buildWhatsappUrl(
    locale === "ar"
      ? "مرحباً مصطفى عمار، أريد التسجيل للحصول على التطبيق."
      : "Hello Mostafa Ammar Aquatics, I'd like early access to the app."
  );

  const currentTier = TIER_DATA[activeTier];
  const currentTierName = t.loyaltyApp.tiers[activeTier];

  return (
    <section id="app" className="py-8 sm:py-12 px-4 sm:px-6 max-w-[1560px] mx-auto">
      <div className="rounded-[2rem] bg-gradient-to-br from-ocean-primary via-ocean-deep to-ocean-mid px-6 pt-8 pb-0 sm:px-10 sm:pt-10 lg:py-0 text-white border border-ocean-sunlit/35 shadow-[0_20px_50px_rgba(42,108,165,0.2)] overflow-hidden">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
          <div className="lg:col-span-7 lg:py-10 space-y-5">
            <SectionReveal>
              <span className="inline-flex items-center gap-1.5 rounded-full bg-white/15 border border-white/25 px-3.5 py-1 text-xs font-extrabold text-ocean-yellow">
                <Sparkles className="w-3.5 h-3.5" strokeWidth={2} aria-hidden="true" />
                <span>{t.loyaltyApp.comingSoon}</span>
              </span>

              <h2 className="mt-3 text-3xl sm:text-4xl font-extrabold tracking-tight leading-tight">
                {t.loyaltyApp.title}
              </h2>
              <p className="mt-2 text-sm sm:text-base text-ocean-muted font-medium">
                {t.loyaltyApp.subtitle}
              </p>

              {/* Tier Segmented Selector (Hick's Law: clear benefit per option, spacious on mobile) */}
              <div className="mt-5 grid grid-cols-1 sm:grid-cols-3 gap-2.5">
                {t.loyaltyApp.tiers.map((tier, idx) => {
                  const isSelected = idx === activeTier;
                  const data = TIER_DATA[idx];
                  return (
                    <button
                      key={tier}
                      type="button"
                      onClick={() => setActiveTier(idx)}
                      className={`min-h-[54px] sm:min-h-[60px] rounded-2xl px-4 sm:px-3 py-2.5 flex sm:block items-center justify-between text-start sm:text-center border transition-[background-color,transform,border-color] duration-200 active:scale-[0.98] cursor-pointer ${
                        isSelected
                          ? "bg-ocean-yellow text-ocean-navy border-ocean-yellow-hover font-extrabold shadow-md"
                          : "bg-white/10 text-white border-white/20 font-bold [@media(hover:hover)]:hover:bg-white/18"
                      }`}
                    >
                      <span className="inline-flex items-center justify-center gap-1.5 text-sm font-extrabold">
                        <Award
                          className={`w-4 h-4 shrink-0 ${
                            isSelected ? "text-ocean-navy" : "text-ocean-yellow"
                          }`}
                          strokeWidth={1.75}
                          aria-hidden="true"
                        />
                        <span>{tier}</span>
                      </span>
                      <span
                        className={`sm:mt-0.5 block text-xs sm:text-[11px] leading-tight ${
                          isSelected ? "text-ocean-navy/85 font-bold" : "text-ocean-muted/90 font-medium"
                        }`}
                      >
                        {locale === "ar" ? data.perkAr : data.perkEn}
                      </span>
                    </button>
                  );
                })}
              </div>

              {/* Single Prominent Primary CTA (Fitts's Law) */}
              <div className="mt-6">
                <a
                  href={earlyAccessUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-full sm:w-auto min-h-[52px] inline-flex items-center justify-center gap-2.5 rounded-full bg-ocean-yellow [@media(hover:hover)]:hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-base px-8 transition-[background-color,transform] duration-200 active:scale-[0.97] cursor-pointer shadow-md"
                >
                  <Smartphone className="w-5 h-5 shrink-0" strokeWidth={1.75} aria-hidden="true" />
                  <span>{t.loyaltyApp.getApp}</span>
                </a>
              </div>
            </SectionReveal>
          </div>

          {/* Slim Portrait Phone Mockup Peeking Up from Bottom Edge */}
          <div className="lg:col-span-5 flex justify-center self-end pt-2 lg:pt-8">
            <SectionReveal delayMs={80}>
              <div className="w-[272px] sm:w-[292px] rounded-t-[2.75rem] bg-[#0B1726] p-2.5 pb-0 border-[3px] border-b-0 border-white/25 shadow-[0_-12px_40px_rgba(7,26,47,0.38)]">
                <div className="rounded-t-[2.15rem] bg-[#F8FBFF] text-ocean-navy px-4 pt-3 pb-6 space-y-3">
                  {/* iOS Status Bar + Dynamic Island */}
                  <div className="flex items-center justify-between px-1 pb-1" dir="ltr">
                    <span className="text-[11px] font-extrabold text-ocean-navy tabular-nums">
                      9:41
                    </span>
                    <div className="w-20 h-4 rounded-full bg-[#0B1726]" aria-hidden="true" />
                    <Wifi className="w-3.5 h-3.5 text-ocean-navy" strokeWidth={2.25} aria-hidden="true" />
                  </div>

                  {/* App Header */}
                  <div className="flex items-center justify-between gap-2">
                    <div className="flex items-center gap-2">
                      <img
                        src="/logo.webp"
                        alt={t.loyaltyApp.mockupBrand}
                        width={26}
                        height={26}
                        className="w-6 h-6 object-contain"
                      />
                      <span className="text-xs font-extrabold">{t.loyaltyApp.mockupBrand}</span>
                    </div>
                    <span className="rounded-full bg-ocean-yellow text-ocean-navy px-2.5 py-0.5 text-[11px] font-extrabold">
                      {currentTierName}
                    </span>
                  </div>

                  {/* Membership Pass Card */}
                  <div className="rounded-2xl bg-gradient-to-br from-ocean-navy to-[#12375E] p-3.5 text-white space-y-2.5 shadow-sm">
                    <div className="flex items-baseline justify-between gap-2">
                      <p className="text-xl font-extrabold tabular-nums">
                        {locale === "ar" ? currentTier.pointsAr : currentTier.pointsEn}
                      </p>
                      <span className="text-[11px] font-extrabold text-ocean-yellow tabular-nums">
                        {currentTier.pct}%
                      </span>
                    </div>
                    <div className="h-2 rounded-full bg-white/15 overflow-hidden">
                      <div
                        className="h-full rounded-full bg-ocean-yellow transition-[width] duration-300 ease-[cubic-bezier(0.22,1,0.36,1)]"
                        style={{ width: `${currentTier.pct}%` }}
                      />
                    </div>
                    <p className="text-[11px] font-semibold text-ocean-sunlit">
                      {locale === "ar" ? currentTier.perkAr : currentTier.perkEn}
                    </p>
                  </div>

                  {/* Reminder & Quick Status */}
                  <div className="space-y-2">
                    <div className="rounded-xl bg-white border border-ocean-border px-3 py-2.5 flex items-center gap-2.5">
                      <div className="w-8 h-8 rounded-lg bg-ocean-ice text-ocean-primary flex items-center justify-center shrink-0">
                        <Bell className="w-4 h-4" strokeWidth={1.75} aria-hidden="true" />
                      </div>
                      <span className="text-xs font-extrabold text-ocean-navy">
                        {t.loyaltyApp.mockupReminder}
                      </span>
                    </div>
                    <div className="rounded-xl bg-white border border-ocean-border px-3 py-2 flex items-center gap-2.5">
                      <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-700 flex items-center justify-center shrink-0">
                        <ShieldCheck className="w-4 h-4" strokeWidth={1.75} aria-hidden="true" />
                      </div>
                      <span className="text-xs font-bold text-ocean-slate">
                        {locale === "ar" ? "فحص دوري للحوض • نشط" : "Tank checkup • Active"}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </SectionReveal>
          </div>
        </div>
      </div>
    </section>
  );
}
