"use client";

import React from "react";
import Link from "next/link";
import { Clock, MapPin, Phone, Store } from "lucide-react";
import { contactInfo } from "@/lib/contact";
import { useLanguage } from "../LanguageProvider";
import { SectionReveal } from "../SectionReveal";

export function ContactSection() {
  const { locale, t } = useLanguage();
  const address = locale === "ar" ? contactInfo.addressAr : contactInfo.addressEn;

  return (
    <section
      id="contact"
      className="py-12 sm:py-16 px-4 sm:px-6 bg-gradient-to-b from-ocean-ice to-ocean-muted"
    >
      <div className="max-w-[1560px] mx-auto">
        <SectionReveal>
          <div className="rounded-[2.25rem] bg-white border border-ocean-border overflow-hidden shadow-[0_12px_36px_rgba(7,26,47,0.06)] grid grid-cols-1 lg:grid-cols-12">
            {/* Left Image-Led Showroom Visual (5 cols) */}
            <div className="lg:col-span-5 relative min-h-[260px] bg-ocean-navy overflow-hidden flex flex-col justify-between p-6 sm:p-8 text-white">
              <img
                src="/frames/frame_096.webp"
                alt={locale === "ar" ? "معرض مصطفى عمار" : "Mostafa Ammar Showroom"}
                loading="lazy"
                className="absolute inset-0 w-full h-full object-cover opacity-75"
              />
              <div
                className="absolute inset-0 bg-gradient-to-t from-ocean-navy/95 via-ocean-navy/50 to-ocean-navy/30"
                aria-hidden="true"
              />

              <div className="relative z-10 flex items-center justify-between gap-2">
                <span className="inline-flex items-center gap-2 rounded-full bg-ocean-whatsapp text-white px-3.5 py-1 text-xs font-extrabold shadow-sm">
                  <span className="w-2 h-2 rounded-full bg-white animate-pulse" />
                  <span>{locale === "ar" ? "المعرض مفتوح الآن" : "Showroom Open Now"}</span>
                </span>
              </div>

              <div className="relative z-10 space-y-2 mt-12">
                <p className="text-xs font-extrabold text-ocean-yellow uppercase tracking-wider">
                  {locale === "ar" ? "الفرع الرئيسي — الدقي" : "Flagship Showroom — Dokki"}
                </p>
                <h2 className="text-2xl sm:text-3xl font-extrabold leading-tight">
                  {t.contact.title}
                </h2>
                <p className="inline-flex items-center gap-2 text-sm sm:text-base font-semibold text-ocean-sunlit">
                  <MapPin className="w-4 h-4 text-ocean-yellow shrink-0" aria-hidden="true" />
                  <span>{address}</span>
                </p>
              </div>
            </div>

            {/* Right Schedule & Actions (7 cols) */}
            <div className="lg:col-span-7 p-6 sm:p-9 flex flex-col justify-between space-y-6">
              <div className="flex flex-wrap items-center justify-between gap-3">
                <div className="flex flex-wrap items-center gap-2.5">
                  <Link
                    href="/shop/"
                    className="min-h-[48px] inline-flex items-center gap-2 rounded-xl bg-ocean-primary [@media(hover:hover)]:hover:bg-ocean-primary-hover text-white font-extrabold text-sm sm:text-base px-5 transition-colors cursor-pointer"
                  >
                    <Store className="w-4 h-4 shrink-0" strokeWidth={2} aria-hidden="true" />
                    <span>{locale === "ar" ? "تصفح المتجر أونلاين" : "Shop Online"}</span>
                  </Link>
                  <a
                    href={contactInfo.mapsUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="min-h-[48px] inline-flex items-center gap-2 rounded-xl bg-ocean-yellow [@media(hover:hover)]:hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-sm sm:text-base px-5 transition-colors cursor-pointer"
                  >
                    <MapPin className="w-4 h-4 shrink-0" strokeWidth={2} aria-hidden="true" />
                    <span>{t.contact.mapsBtn}</span>
                  </a>
                  <a
                    href={contactInfo.phoneHref}
                    className="min-h-[48px] inline-flex items-center gap-2 rounded-xl bg-ocean-ice border border-ocean-border [@media(hover:hover)]:hover:bg-ocean-muted text-ocean-navy font-extrabold text-sm sm:text-base px-5 transition-colors cursor-pointer"
                  >
                    <Phone className="w-4 h-4 shrink-0" strokeWidth={1.75} aria-hidden="true" />
                    <span>{t.contact.callBtn}</span>
                  </a>
                </div>

                {/* Social Icons */}
                <div className="flex items-center gap-2">
                  <a
                    href={contactInfo.youtubeUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    aria-label="YouTube"
                    className="w-11 h-11 rounded-full bg-[#FF0000] border border-ocean-border flex items-center justify-center text-white [@media(hover:hover)]:hover:opacity-90 transition-opacity cursor-pointer"
                  >
                    <svg viewBox="0 0 24 24" className="w-5 h-5 fill-current" aria-hidden="true">
                      <path d="M21.8 8s-.2-1.4-.8-2c-.8-.8-1.6-.8-2-.9C16.2 5 12 5 12 5h0s-4.2 0-7 .1c-.4.1-1.2.1-2 .9-.6.6-.8 2-.8 2S2 9.6 2 11.2v1.5C2 14.4 2.2 16 2.2 16s.2 1.4.8 2c.8.8 1.8.8 2.2.9 1.6.1 6.8.1 6.8.1s4.2 0 7-.1c.4-.1 1.2-.1 2-.9.6-.6.8-2 .8-2s.2-1.6.2-3.3v-1.5C22 9.6 21.8 8 21.8 8zM10 14.6V9.2l5.2 2.7-5.2 2.7z" />
                    </svg>
                  </a>
                  <a
                    href={contactInfo.facebookUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    aria-label="Facebook"
                    className="w-11 h-11 rounded-full bg-ocean-ice border border-ocean-border flex items-center justify-center p-2.5 [@media(hover:hover)]:hover:bg-ocean-muted transition-colors cursor-pointer"
                  >
                    <img
                      src="/social/facebook.png"
                      alt="Facebook"
                      width={24}
                      height={24}
                      className="w-full h-full object-contain"
                    />
                  </a>
                  <a
                    href={contactInfo.instagramUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    aria-label="Instagram"
                    className="w-11 h-11 rounded-full bg-ocean-ice border border-ocean-border flex items-center justify-center p-2.5 [@media(hover:hover)]:hover:bg-ocean-muted transition-colors cursor-pointer"
                  >
                    <img
                      src="/social/instagram.png"
                      alt="Instagram"
                      width={24}
                      height={24}
                      className="w-full h-full object-contain"
                    />
                  </a>
                  <a
                    href={contactInfo.tiktokUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    aria-label="TikTok"
                    className="w-11 h-11 rounded-full bg-ocean-ice border border-ocean-border flex items-center justify-center p-2.5 [@media(hover:hover)]:hover:bg-ocean-muted transition-colors cursor-pointer"
                  >
                    <img
                      src="/social/tik-tok.png"
                      alt="TikTok"
                      width={24}
                      height={24}
                      className="w-full h-full object-contain"
                    />
                  </a>
                </div>
              </div>

              {/* 7-Day Schedule Strip */}
              <div>
                <div className="inline-flex items-center gap-2 text-sm font-extrabold text-ocean-primary mb-3">
                  <Clock className="w-4 h-4" strokeWidth={1.75} aria-hidden="true" />
                  <span>{t.contact.hoursTitle}</span>
                </div>

                <div className="grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-7 gap-2">
                  {contactInfo.weekDays.map((day) => (
                    <div
                      key={day.dayEn}
                      className={`rounded-2xl p-2.5 text-center border ${
                        day.isFriday
                          ? "bg-ocean-yellow-soft/70 border-ocean-yellow text-ocean-navy"
                          : "bg-ocean-ice border-ocean-border text-ocean-navy"
                      }`}
                    >
                      <p className="text-xs font-extrabold">
                        {locale === "ar" ? day.dayAr : day.dayEn}
                      </p>
                      <p className="mt-1 text-xs font-bold text-ocean-slate tabular-nums">
                        {locale === "ar" ? day.hoursAr : day.hoursEn}
                      </p>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </SectionReveal>
      </div>
    </section>
  );
}
