"use client";

import React, { useState } from "react";
import Link from "next/link";
import {
  ArrowLeft,
  CalendarCheck,
  CheckCircle2,
  ChevronRight,
  Clock,
  MapPin,
  Phone,
  ShieldCheck,
} from "lucide-react";
import { Footer } from "@/components/Footer";
import { Header } from "@/components/Header";
import { useLanguage } from "@/components/LanguageProvider";
import { MobileActionBar } from "@/components/MobileActionBar";
import { trustedVets, type VetContact } from "@/lib/vets";

export function VetDetailClient({ vet }: { vet: VetContact }) {
  const { locale } = useLanguage();
  const [ownerName, setOwnerName] = useState("");
  const [ownerPhone, setOwnerPhone] = useState("");
  const [petType, setPetType] = useState("");
  const [slot, setSlot] = useState("today-evening");
  const [booked, setBooked] = useState(false);

  const area = locale === "ar" ? vet.areaAr : vet.areaEn;
  const name = locale === "ar" ? vet.nameAr : vet.nameEn;
  const clinic = locale === "ar" ? vet.clinicAr : vet.clinicEn;
  const specialty = locale === "ar" ? vet.specialtyAr : vet.specialtyEn;
  const bio = locale === "ar" ? vet.bioAr : vet.bioEn;
  const hours = locale === "ar" ? vet.hoursAr : vet.hoursEn;

  const otherVets = trustedVets.filter((v) => v.id !== vet.id);

  const handleBook = (e: React.FormEvent) => {
    e.preventDefault();
    setBooked(true);
  };

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
          <Link href="/vets/" className="hover:text-ocean-primary transition-colors">
            {locale === "ar" ? "الأطباء البيطريون" : "Aquatic Doctors"}
          </Link>
          <ChevronRight className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
          <span className="text-ocean-navy">{name}</span>
        </nav>

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          {/* Left: Doctor Profile Card (7 cols) */}
          <div className="lg:col-span-7 rounded-[2.25rem] bg-white border border-ocean-border overflow-hidden shadow-sm">
            <div className="relative aspect-[16/10] w-full bg-ocean-navy overflow-hidden">
              <img src={vet.image} alt={name} className="w-full h-full object-cover" />
              <div
                className="absolute inset-0 bg-gradient-to-t from-ocean-navy/85 via-transparent to-transparent"
                aria-hidden="true"
              />
              <div className="absolute top-4 inset-x-4 flex items-center justify-between">
                <span className="inline-flex items-center gap-1.5 rounded-full bg-ocean-navy/85 backdrop-blur-md border border-white/20 text-ocean-sunlit px-3.5 py-1 text-xs font-extrabold">
                  <MapPin className="w-3.5 h-3.5 text-ocean-yellow" />
                  <span>{area}</span>
                </span>
                <span className="rounded-full bg-ocean-whatsapp text-white px-3.5 py-1 text-xs font-extrabold">
                  {locale === "ar" ? "متاح للحجز اليوم" : "Available Today"}
                </span>
              </div>
            </div>

            <div className="p-6 sm:p-8 space-y-6">
              <div>
                <p className="text-xs font-extrabold text-ocean-primary uppercase tracking-wider">
                  {clinic}
                </p>
                <h1 className="text-2xl sm:text-4xl font-extrabold text-ocean-navy mt-1">
                  {name}
                </h1>
                <p className="mt-1 text-base sm:text-lg font-bold text-ocean-primary">
                  {specialty}
                </p>
                <p className="mt-4 text-base text-ocean-slate leading-relaxed">{bio}</p>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div className="rounded-2xl bg-ocean-ice border border-ocean-border p-4 flex items-center gap-3">
                  <Clock className="w-6 h-6 text-ocean-primary shrink-0" />
                  <div>
                    <p className="text-xs font-bold text-ocean-slate">
                      {locale === "ar" ? "مواعيد العيادة" : "Clinic Hours"}
                    </p>
                    <p className="text-sm font-extrabold text-ocean-navy">{hours}</p>
                  </div>
                </div>
                <div className="rounded-2xl bg-ocean-ice border border-ocean-border p-4 flex items-center gap-3">
                  <ShieldCheck className="w-6 h-6 text-ocean-primary shrink-0" />
                  <div>
                    <p className="text-xs font-bold text-ocean-slate">
                      {locale === "ar" ? "سعر الكشف / الفحص" : "Consultation Fee"}
                    </p>
                    <p className="text-sm font-extrabold text-ocean-navy">
                      {vet.feeEgp} {locale === "ar" ? "ج.م" : "EGP"}
                    </p>
                  </div>
                </div>
              </div>

              <div className="flex flex-wrap items-center gap-3 pt-2">
                <a
                  href={vet.phoneHref}
                  className="min-h-[48px] inline-flex items-center gap-2 rounded-xl bg-ocean-muted hover:bg-ocean-border text-ocean-navy font-extrabold text-sm sm:text-base px-5 cursor-pointer"
                >
                  <Phone className="w-4 h-4" />
                  <span>{locale === "ar" ? "اتصال مباشر بالعيادة" : "Call Clinic"}</span>
                </a>
                <a
                  href={vet.mapsUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="min-h-[48px] inline-flex items-center gap-2 rounded-xl bg-white border border-ocean-border hover:bg-ocean-ice text-ocean-navy font-extrabold text-sm sm:text-base px-5 cursor-pointer"
                >
                  <MapPin className="w-4 h-4 text-ocean-primary" />
                  <span>{locale === "ar" ? "موقع العيادة على الخريطة" : "Open Clinic Map"}</span>
                </a>
              </div>
            </div>
          </div>

          {/* Right: Inline Appointment Booking Form (5 cols) */}
          <div className="lg:col-span-5 rounded-[2.25rem] bg-white border border-ocean-border p-6 sm:p-8 shadow-sm">
            <div className="flex items-center gap-2.5 mb-5">
              <div className="w-10 h-10 rounded-xl bg-ocean-yellow text-ocean-navy flex items-center justify-center">
                <CalendarCheck className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-xl font-extrabold text-ocean-navy">
                  {locale === "ar" ? "احجز موعد كشف بالعيادة" : "Book Clinic Appointment"}
                </h2>
                <p className="text-xs font-bold text-ocean-slate">
                  {locale === "ar" ? "تأكيد فوري بدون انتظار" : "Instant booking confirmation"}
                </p>
              </div>
            </div>

            {booked ? (
              <div className="rounded-2xl bg-ocean-ice border border-ocean-border p-6 text-center space-y-4">
                <div className="w-14 h-14 rounded-full bg-ocean-whatsapp text-white flex items-center justify-center mx-auto">
                  <CheckCircle2 className="w-8 h-8" />
                </div>
                <h3 className="text-xl font-extrabold text-ocean-navy">
                  {locale === "ar" ? "تم تسجيل حجزك بنجاح!" : "Appointment Reserved!"}
                </h3>
                <p className="text-sm text-ocean-slate">
                  {locale === "ar"
                    ? `تم حجز موعد مع ${name} (${clinic}) باسم ${ownerName}. سنتصل بك على ${ownerPhone}.`
                    : `Booked with ${name} (${clinic}) for ${ownerName}. Confirmation call to ${ownerPhone}.`}
                </p>
                <button
                  type="button"
                  onClick={() => setBooked(false)}
                  className="w-full min-h-[48px] rounded-full bg-ocean-primary text-white font-extrabold cursor-pointer"
                >
                  {locale === "ar" ? "حجز موعد آخر" : "Book Another Slot"}
                </button>
              </div>
            ) : (
              <form onSubmit={handleBook} className="space-y-4">
                <div>
                  <label className="block text-sm font-bold text-ocean-navy mb-1">
                    {locale === "ar" ? "الاسم الكامل" : "Your Full Name"}
                  </label>
                  <input
                    type="text"
                    required
                    value={ownerName}
                    onChange={(e) => setOwnerName(e.target.value)}
                    placeholder={locale === "ar" ? "مثال: محمد علي" : "e.g. Mohamed Ali"}
                    className="w-full min-h-[46px] rounded-xl bg-ocean-ice border border-ocean-border px-3.5 text-base"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-ocean-navy mb-1">
                    {locale === "ar" ? "رقم الموبايل" : "Mobile Number"}
                  </label>
                  <input
                    type="tel"
                    required
                    dir="ltr"
                    value={ownerPhone}
                    onChange={(e) => setOwnerPhone(e.target.value)}
                    placeholder="010 1234 5678"
                    className="w-full min-h-[46px] rounded-xl bg-ocean-ice border border-ocean-border px-3.5 text-base"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-ocean-navy mb-1">
                    {locale === "ar" ? "الموعد المفضل" : "Preferred Time Slot"}
                  </label>
                  <select
                    value={slot}
                    onChange={(e) => setSlot(e.target.value)}
                    className="w-full min-h-[46px] rounded-xl bg-ocean-ice border border-ocean-border px-3.5 text-base font-semibold text-ocean-navy"
                  >
                    <option value="today-evening">
                      {locale === "ar" ? "اليوم — الفترة المسائية (5 م – 9 م)" : "Today — Evening (5 PM – 9 PM)"}
                    </option>
                    <option value="tomorrow-afternoon">
                      {locale === "ar" ? "غداً — فترة الظهيرة (1 ظ – 5 م)" : "Tomorrow — Afternoon (1 PM – 5 PM)"}
                    </option>
                    <option value="tomorrow-evening">
                      {locale === "ar" ? "غداً — الفترة المسائية (5 م – 9 م)" : "Tomorrow — Evening (5 PM – 9 PM)"}
                    </option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-bold text-ocean-navy mb-1">
                    {locale === "ar" ? "نوع السمكة / السلحفاة والأعراض" : "Pet Type & Symptoms"}
                  </label>
                  <input
                    type="text"
                    required
                    value={petType}
                    onChange={(e) => setPetType(e.target.value)}
                    placeholder={
                      locale === "ar"
                        ? "مثال: سلحفاة مائية — خمول أو ليونة بالدرع"
                        : "e.g. Aquatic turtle — soft shell or lethargy"
                    }
                    className="w-full min-h-[46px] rounded-xl bg-ocean-ice border border-ocean-border px-3.5 text-base"
                  />
                </div>

                <button
                  type="submit"
                  className="w-full min-h-[54px] inline-flex items-center justify-center gap-2 rounded-2xl bg-ocean-yellow hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-base shadow-md cursor-pointer"
                >
                  <CalendarCheck className="w-5 h-5" />
                  <span>
                    {locale === "ar"
                      ? `تأكيد حجز الكشف (${vet.feeEgp} ج.م)`
                      : `Confirm Appointment (${vet.feeEgp} EGP)`}
                  </span>
                </button>
              </form>
            )}
          </div>
        </div>

        {/* Other Doctors */}
        <section className="mt-14">
          <div className="flex items-center justify-between gap-4 mb-6">
            <h2 className="text-2xl font-extrabold text-ocean-navy">
              {locale === "ar" ? "أطباء آخرون في الشبكة" : "Other Certified Vets"}
            </h2>
            <Link
              href="/vets/"
              className="inline-flex items-center gap-1.5 text-sm font-extrabold text-ocean-primary hover:underline"
            >
              <span>{locale === "ar" ? "كل الأطباء" : "All Doctors"}</span>
              <ArrowLeft className="w-4 h-4 ltr:rotate-180" />
            </Link>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
            {otherVets.map((ov) => (
              <Link
                key={ov.id}
                href={`/vets/${ov.id}/`}
                className="rounded-3xl bg-white border border-ocean-border p-4 flex items-center gap-4 hover:-translate-y-1 transition-transform shadow-sm"
              >
                <img
                  src={ov.image}
                  alt={locale === "ar" ? ov.nameAr : ov.nameEn}
                  className="w-24 h-20 rounded-2xl object-cover shrink-0 bg-ocean-navy"
                />
                <div>
                  <span className="text-xs font-extrabold text-ocean-primary">
                    {locale === "ar" ? ov.areaAr : ov.areaEn} •{" "}
                    {locale === "ar" ? ov.clinicAr : ov.clinicEn}
                  </span>
                  <h3 className="text-lg font-extrabold text-ocean-navy">
                    {locale === "ar" ? ov.nameAr : ov.nameEn}
                  </h3>
                  <p className="text-sm text-ocean-slate">
                    {locale === "ar" ? ov.specialtyAr : ov.specialtyEn}
                  </p>
                </div>
              </Link>
            ))}
          </div>
        </section>
      </main>
      <Footer />
      <MobileActionBar />
    </div>
  );
}
