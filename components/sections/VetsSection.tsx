"use client";

import React from "react";
import Link from "next/link";
import { ArrowRight, CalendarCheck, Clock, MapPin, Stethoscope } from "lucide-react";
import { trustedVets } from "@/lib/vets";
import { useLanguage } from "../LanguageProvider";
import { SectionReveal } from "../SectionReveal";

export function VetsSection() {
  const { locale, t } = useLanguage();

  return (
    <section
      id="vets"
      className="py-10 sm:py-12 px-4 sm:px-6 max-w-[1560px] mx-auto"
    >
      {/* Compact Header Row (Hick's Law: 1 section-level navigation action) */}
      <SectionReveal>
        <div className="flex flex-wrap items-end justify-between gap-4 mb-6">
          <div className="space-y-1.5">
            <span className="inline-flex items-center gap-1.5 rounded-full bg-ocean-primary/10 text-ocean-primary px-3 py-1 text-xs font-extrabold">
              <Stethoscope className="w-3.5 h-3.5" strokeWidth={2} aria-hidden="true" />
              <span>{locale === "ar" ? "رعاية بيطرية معتمدة" : "Certified Vet Care"}</span>
            </span>
            <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-ocean-navy">
              {t.vets.title}
            </h2>
          </div>

          <Link
            href="/vets/"
            className="min-h-[44px] inline-flex items-center gap-1.5 rounded-full bg-white border border-ocean-border [@media(hover:hover)]:hover:border-ocean-primary px-4 text-sm font-extrabold text-ocean-navy transition-colors shrink-0"
          >
            <span>{locale === "ar" ? "عرض كل الأطباء" : "All Vets"}</span>
            <ArrowRight className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
          </Link>
        </div>
      </SectionReveal>

      {/* 3 Compact Vet Cards (Hick's Law: 1 CTA per card; Fitts's Law: full-width 48px target) */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
        {trustedVets.map((vet, idx) => {
          const area = locale === "ar" ? vet.areaAr : vet.areaEn;
          const name = locale === "ar" ? vet.nameAr : vet.nameEn;
          const specialty = locale === "ar" ? vet.specialtyAr : vet.specialtyEn;
          const hours = locale === "ar" ? vet.hoursAr : vet.hoursEn;

          return (
            <SectionReveal key={vet.id} delayMs={idx * 50} className="h-full">
              <article className="group h-full rounded-2xl bg-white border border-ocean-border overflow-hidden flex flex-col justify-between shadow-[0_6px_20px_rgba(7,26,47,0.05)] transition-transform duration-300 ease-[cubic-bezier(0.22,1,0.36,1)] [@media(hover:hover)]:hover:-translate-y-1">
                <div>
                  <Link
                    href={`/vets/${vet.id}/`}
                    className="block relative h-40 w-full bg-ocean-navy overflow-hidden"
                  >
                    <img
                      src={vet.image}
                      alt={name}
                      loading="lazy"
                      className="w-full h-full object-cover object-top transition-transform duration-500 [@media(hover:hover)]:group-hover:scale-105"
                    />
                    <div
                      className="absolute inset-0 bg-gradient-to-t from-ocean-navy/65 via-transparent to-transparent"
                      aria-hidden="true"
                    />
                    <span className="absolute top-2.5 start-2.5 inline-flex items-center gap-1 rounded-full bg-ocean-navy/92 md:bg-ocean-navy/85 md:backdrop-blur-md border border-white/20 text-ocean-sunlit px-2.5 py-0.5 text-xs font-extrabold">
                      <MapPin className="w-3 h-3 text-ocean-yellow" aria-hidden="true" />
                      <span>{area}</span>
                    </span>
                  </Link>

                  <div className="p-4 space-y-1.5">
                    <Link href={`/vets/${vet.id}/`} className="block">
                      <h3 className="text-lg font-extrabold text-ocean-navy [@media(hover:hover)]:hover:text-ocean-primary leading-snug">
                        {name}
                      </h3>
                    </Link>

                    <p className="text-sm font-semibold text-ocean-slate line-clamp-1">
                      {specialty}
                    </p>

                    <div className="pt-1.5 flex items-center justify-between gap-2 text-xs font-bold text-ocean-slate">
                      <span className="inline-flex items-center gap-1 truncate">
                        <Clock className="w-3.5 h-3.5 text-ocean-primary shrink-0" aria-hidden="true" />
                        <span>{hours}</span>
                      </span>
                      <span className="shrink-0 font-extrabold text-ocean-navy">
                        {vet.feeEgp} {locale === "ar" ? "ج.م" : "EGP"}
                      </span>
                    </div>
                  </div>
                </div>

                <div className="px-4 pb-4 pt-2">
                  <Link
                    href={`/vets/${vet.id}/`}
                    className="w-full min-h-[48px] inline-flex items-center justify-center gap-2 rounded-xl bg-ocean-yellow [@media(hover:hover)]:hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-sm px-4 whitespace-nowrap transition-transform active:scale-[0.98] cursor-pointer"
                  >
                    <CalendarCheck className="w-4 h-4 shrink-0" aria-hidden="true" />
                    <span>{locale === "ar" ? "احجز موعد كشف" : "Book Appointment"}</span>
                  </Link>
                </div>
              </article>
            </SectionReveal>
          );
        })}
      </div>
    </section>
  );
}
