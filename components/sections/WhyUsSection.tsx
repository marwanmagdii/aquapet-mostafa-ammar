"use client";

import React from "react";
import {
  ArrowRight,
  Award,
  BellRing,
  HeartPulse,
  RefreshCw,
  ShoppingBag,
  Stethoscope,
  Truck,
} from "lucide-react";
import { useLanguage } from "../LanguageProvider";
import { SectionReveal } from "../SectionReveal";

const tileIcons = [HeartPulse, Truck, Award, Stethoscope];
const flowIcons = [ShoppingBag, BellRing, RefreshCw];

export function WhyUsSection() {
  const { t } = useLanguage();

  return (
    <section
      id="why-us"
      className="relative py-14 sm:py-20 px-4 sm:px-6 bg-gradient-to-b from-ocean-navy via-ocean-primary-hover to-ocean-primary text-white overflow-hidden"
    >
      {/* Subtle sunlit water glow at top */}
      <div
        className="pointer-events-none absolute -top-24 inset-x-0 mx-auto w-[680px] h-[260px] rounded-full bg-ocean-cyan/20 blur-3xl"
        aria-hidden="true"
      />

      <div className="relative max-w-[1560px] mx-auto space-y-12">
        <SectionReveal>
          <div className="max-w-2xl">
            <h2 className="text-3xl sm:text-5xl font-extrabold text-white tracking-tight">
              {t.whyUs.title}
            </h2>
            <p className="mt-3 text-base sm:text-xl text-ocean-muted leading-relaxed line-clamp-2">
              {t.whyUs.caption}
            </p>
          </div>
        </SectionReveal>

        <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-5">
          {t.whyUs.items.map((item, idx) => {
            const Icon = tileIcons[idx % tileIcons.length];
            return (
              <SectionReveal key={item.title} delayMs={idx * 60}>
                <div className="h-full rounded-2xl sm:rounded-[1.75rem] bg-white/12 md:bg-white/10 md:backdrop-blur-md p-4 sm:p-6 border border-ocean-sunlit/25 transition-transform duration-300 ease-[cubic-bezier(0.22,1,0.36,1)] [@media(hover:hover)]:hover:-translate-y-1">
                  <div className="w-10 h-10 sm:w-12 sm:h-12 rounded-xl sm:rounded-2xl bg-ocean-yellow text-ocean-navy flex items-center justify-center mb-3 sm:mb-5 shadow-md">
                    <Icon className="w-5 h-5 sm:w-6 sm:h-6" strokeWidth={1.75} aria-hidden="true" />
                  </div>
                  <h3 className="text-base sm:text-xl font-extrabold text-white">{item.title}</h3>
                  <p className="mt-1 text-xs sm:text-base text-ocean-muted">{item.detail}</p>
                </div>
              </SectionReveal>
            );
          })}
        </div>

        {/* Connected 3-Step Reminder Flow (Law of Uniform Connectedness) */}
        <SectionReveal delayMs={120}>
          <div className="rounded-3xl sm:rounded-[2rem] bg-white/12 md:bg-white/10 md:backdrop-blur-md border border-ocean-sunlit/30 p-4 sm:p-8">
            <p className="text-base font-extrabold text-ocean-yellow mb-5">
              {t.whyUs.flowTitle}
            </p>
            <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3">
              {t.whyUs.flowSteps.map((step, idx) => {
                const Icon = flowIcons[idx];
                return (
                  <React.Fragment key={step}>
                    <div className="flex-1 flex items-center gap-3.5 rounded-2xl bg-ocean-navy/55 border border-ocean-sunlit/25 px-4 py-4">
                      <div className="w-11 h-11 rounded-xl bg-ocean-yellow text-ocean-navy flex items-center justify-center shrink-0">
                        <Icon className="w-5 h-5" strokeWidth={1.75} aria-hidden="true" />
                      </div>
                      <span className="text-base sm:text-lg font-extrabold text-white">{step}</span>
                    </div>
                    {idx < 2 && (
                      <div
                        className="flex items-center justify-center text-ocean-yellow"
                        aria-hidden="true"
                      >
                        <ArrowRight
                          className="w-5 h-5 rotate-90 sm:rotate-0 sm:rtl:rotate-180"
                          strokeWidth={2}
                        />
                      </div>
                    )}
                  </React.Fragment>
                );
              })}
            </div>
          </div>
        </SectionReveal>
      </div>
    </section>
  );
}
