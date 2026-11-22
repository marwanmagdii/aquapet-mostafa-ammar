"use client";

import React, { useState } from "react";
import Link from "next/link";
import {
  CalendarCheck,
  CheckCircle2,
  ChevronRight,
  Clock,
  HeartPulse,
  MapPin,
  Phone,
  ShieldAlert,
  Stethoscope,
  X,
} from "lucide-react";
import { Footer } from "@/components/Footer";
import { Header } from "@/components/Header";
import { useLanguage } from "@/components/LanguageProvider";
import { MobileActionBar } from "@/components/MobileActionBar";
import { trustedVets, type VetContact } from "@/lib/vets";

export default function VetsPage() {
  const { locale } = useLanguage();
  const [selectedArea, setSelectedArea] = useState<string>("all");
  const [bookingVet, setBookingVet] = useState<VetContact | null>(null);
  const [petType, setPetType] = useState("");
  const [ownerName, setOwnerName] = useState("");
  const [ownerPhone, setOwnerPhone] = useState("");
  const [bookedSuccess, setBookedSuccess] = useState(false);

  const areas = [
    { id: "all", ar: "كل المناطق (3)", en: "All Areas (3)" },
    { id: "المهندسين", ar: "المهندسين", en: "Mohandessin" },
    { id: "المعادي", ar: "المعادي", en: "Maadi" },
    { id: "مدينة نصر", ar: "مدينة نصر", en: "Nasr City" },
  ];

  const filteredVets =
    selectedArea === "all"
      ? trustedVets
      : trustedVets.filter((v) => v.areaAr === selectedArea);

  const symptoms =
    locale === "ar"
      ? [
          {
            title: "نقاط بيضاء على الجسم أو الزعانف (Ich)",
            care: "ارفع الحرارة تدريجياً إلى 28° وأضف معالج الفطريات مع تهوية قوية.",
            doctor: "د. أحمد الشربيني — أخصائي أسماك الزينة",
          },
          {
            title: "ليونة الدرع أو خمول السلحفاة المائية",
            care: "وفّر إضاءة UVB للتشمس مع أعواد الكالسيوم وفيتامين D3 يومياً.",
            doctor: "د. سلمى منصور — أخصائية السلاحف المائية",
          },
          {
            title: "فقدان الشهية أو تآكل أطراف الزعانف",
            care: "غيّر 30% من الماء مع مزيل كلور أكوا سيف وافحص مستوى الأمونيا.",
            doctor: "د. كريم عادل — أخصائي علاج وتغذية الأسماك",
          },
        ]
      : [
          {
            title: "White Spots on Body or Fins (Ich)",
            care: "Gradually raise tank temp to 28°C, increase aeration, and dose anti-parasite care.",
            doctor: "Dr. Ahmed Sherbiny — Ornamental Fish Specialist",
          },
          {
            title: "Soft Shell or Lethargy in Aquatic Turtles",
            care: "Provide daily UVB basking lamp exposure and Calcium + D3 floating sticks.",
            doctor: "Dr. Salma Mansour — Aquatic Turtle Specialist",
          },
          {
            title: "Loss of Appetite or Fin Rot",
            care: "Perform a 30% dechlorinated water change and check ammonia/nitrite balance.",
            doctor: "Dr. Karim Adel — Fish Health & Nutrition",
          },
        ];

  const handleBookSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setBookedSuccess(true);
  };

  return (
    <div className="min-h-screen flex flex-col bg-ocean-ice text-ocean-navy">
      <Header />
      <main className="flex-1 pt-24 pb-20 px-4 sm:px-6 max-w-[1560px] mx-auto w-full">
        {/* Breadcrumb */}
        <nav
          className="flex items-center gap-2 text-sm font-bold text-ocean-slate mb-4"
          aria-label="Breadcrumb"
        >
          <Link href="/" className="hover:text-ocean-primary transition-colors">
            {locale === "ar" ? "الرئيسية" : "Home"}
          </Link>
          <ChevronRight className="w-4 h-4 rtl:rotate-180" aria-hidden="true" />
          <span className="text-ocean-navy">
            {locale === "ar" ? "الأطباء البيطريون" : "Aquatic Doctors"}
          </span>
        </nav>

        {/* Hero Banner */}
        <div className="rounded-[2.25rem] bg-gradient-to-br from-ocean-navy via-ocean-primary-hover to-ocean-primary text-white p-6 sm:p-10 mb-8 border border-ocean-sunlit/30 flex flex-col lg:flex-row lg:items-center justify-between gap-6">
          <div className="max-w-2xl space-y-2">
            <span className="inline-flex items-center gap-1.5 rounded-full bg-ocean-yellow text-ocean-navy px-3.5 py-1 text-xs font-extrabold">
              <Stethoscope className="w-3.5 h-3.5" />
              <span>
                {locale === "ar" ? "شبكة الرعاية البيطرية المعتمدة" : "Certified Aquatic Vet Network"}
              </span>
            </span>
            <h1 className="text-3xl sm:text-5xl font-extrabold tracking-tight">
              {locale === "ar"
                ? "أطباء متخصصون في أسماك الزينة والسلاحف"
                : "Specialists in Ornamental Fish & Turtles"}
            </h1>
            <p className="text-base sm:text-lg text-ocean-muted">
              {locale === "ar"
                ? "احجز كشفاً بالعيادة أو استشارة طارئة لحماية أسماكك وسلاحفك المائية."
                : "Book an in-clinic checkup or emergency consultation for your aquatic pets."}
            </p>
          </div>

          <div className="rounded-2xl bg-white/10 backdrop-blur-md border border-ocean-sunlit/30 p-4 text-center shrink-0">
            <HeartPulse className="w-8 h-8 text-ocean-yellow mx-auto mb-1" />
            <p className="text-xl font-extrabold">24 / 7</p>
            <p className="text-xs text-ocean-muted font-bold">
              {locale === "ar" ? "طوارئ واستشارات الأحواض" : "Emergency Tank Support"}
            </p>
          </div>
        </div>

        {/* Area Filter Pills */}
        <div className="flex flex-wrap items-center gap-2 mb-8">
          {areas.map((a) => (
            <button
              key={a.id}
              type="button"
              onClick={() => setSelectedArea(a.id)}
              className={`min-h-[44px] rounded-full px-5 text-sm sm:text-base font-extrabold transition-colors cursor-pointer ${
                selectedArea === a.id
                  ? "bg-ocean-primary text-white shadow-sm"
                  : "bg-white border border-ocean-border text-ocean-navy hover:bg-ocean-muted"
              }`}
            >
              {locale === "ar" ? a.ar : a.en}
            </button>
          ))}
        </div>

        {/* Doctors Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-14">
          {filteredVets.map((vet) => {
            const area = locale === "ar" ? vet.areaAr : vet.areaEn;
            const name = locale === "ar" ? vet.nameAr : vet.nameEn;
            const clinic = locale === "ar" ? vet.clinicAr : vet.clinicEn;
            const specialty = locale === "ar" ? vet.specialtyAr : vet.specialtyEn;
            const hours = locale === "ar" ? vet.hoursAr : vet.hoursEn;

            return (
              <article
                key={vet.id}
                className="group rounded-3xl bg-white border border-ocean-border overflow-hidden flex flex-col justify-between shadow-sm hover:-translate-y-1 transition-transform"
              >
                <div>
                  <Link
                    href={`/vets/${vet.id}/`}
                    className="block relative aspect-[16/10] w-full bg-ocean-navy overflow-hidden"
                  >
                    <img
                      src={vet.image}
                      alt={clinic}
                      loading="lazy"
                      className="w-full h-full object-cover object-top group-hover:scale-105 transition-transform duration-500"
                    />
                    <div
                      className="absolute inset-0 bg-gradient-to-t from-ocean-navy/80 via-transparent to-transparent"
                      aria-hidden="true"
                    />
                    <div className="absolute top-3 inset-x-3 flex items-center justify-between gap-2">
                      <span className="inline-flex items-center gap-1 rounded-full bg-ocean-navy/85 backdrop-blur-md border border-white/20 text-ocean-sunlit px-3 py-1 text-xs font-extrabold">
                        <MapPin className="w-3.5 h-3.5 text-ocean-yellow" />
                        <span>{area}</span>
                      </span>
                      <span className="rounded-full bg-ocean-whatsapp text-white px-3 py-1 text-xs font-extrabold shadow-sm">
                        {locale === "ar" ? "متاح اليوم" : "Available Today"}
                      </span>
                    </div>
                  </Link>

                  <div className="p-6 space-y-3">
                    <div>
                      <p className="text-xs font-extrabold text-ocean-primary uppercase tracking-wide">
                        {clinic}
                      </p>
                      <Link href={`/vets/${vet.id}/`} className="block">
                        <h2 className="text-xl font-extrabold text-ocean-navy hover:text-ocean-primary mt-0.5">
                          {name}
                        </h2>
                      </Link>
                      <p className="text-sm font-semibold text-ocean-slate mt-1">{specialty}</p>
                    </div>

                    <div className="rounded-2xl bg-ocean-ice border border-ocean-border p-3.5 space-y-2 text-xs sm:text-sm font-semibold text-ocean-slate">
                      <div className="flex items-center gap-2">
                        <Clock className="w-4 h-4 text-ocean-primary shrink-0" />
                        <span>{hours}</span>
                      </div>
                      <div className="flex items-center justify-between pt-1 border-t border-ocean-border text-ocean-navy font-extrabold">
                        <span>{locale === "ar" ? "سعر الكشف / الاستشارة" : "Consultation Fee"}</span>
                        <span>
                          {vet.feeEgp} {locale === "ar" ? "ج.م" : "EGP"}
                        </span>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="px-6 pb-6 pt-3 border-t border-ocean-ice flex items-center gap-2">
                  <Link
                    href={`/vets/${vet.id}/`}
                    className="flex-1 min-h-[48px] inline-flex items-center justify-center gap-2 rounded-xl bg-ocean-yellow hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-sm sm:text-base px-4 shadow-sm cursor-pointer"
                  >
                    <CalendarCheck className="w-4 h-4 shrink-0" />
                    <span>{locale === "ar" ? "احجز موعد كشف" : "Book Appointment"}</span>
                  </Link>

                  <a
                    href={vet.phoneHref}
                    aria-label={locale === "ar" ? `اتصال ${name}` : `Call ${name}`}
                    className="w-12 h-12 rounded-xl bg-ocean-ice border border-ocean-border hover:bg-ocean-muted text-ocean-navy flex items-center justify-center shrink-0 cursor-pointer"
                  >
                    <Phone className="w-4 h-4" />
                  </a>
                  <a
                    href={vet.mapsUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    aria-label={locale === "ar" ? `موقع ${name}` : `Map ${name}`}
                    className="w-12 h-12 rounded-xl bg-ocean-ice border border-ocean-border hover:bg-ocean-muted text-ocean-primary flex items-center justify-center shrink-0 cursor-pointer"
                  >
                    <MapPin className="w-4 h-4" />
                  </a>
                </div>
              </article>
            );
          })}
        </div>

        {/* Symptom & First-Aid Guide */}
        <section className="rounded-[2.25rem] bg-white border border-ocean-border p-6 sm:p-10">
          <div className="flex items-center gap-2.5 mb-6">
            <ShieldAlert className="w-6 h-6 text-ocean-primary" />
            <h2 className="text-2xl sm:text-3xl font-extrabold text-ocean-navy">
              {locale === "ar"
                ? "دليل التشخيص السريع والإسعافات الأولية"
                : "Quick Symptom & First-Aid Guide"}
            </h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
            {symptoms.map((sym) => (
              <div
                key={sym.title}
                className="rounded-2xl bg-ocean-ice border border-ocean-border p-5 flex flex-col justify-between space-y-3"
              >
                <div>
                  <h3 className="text-base sm:text-lg font-extrabold text-ocean-navy">
                    {sym.title}
                  </h3>
                  <p className="mt-2 text-sm text-ocean-slate leading-relaxed">{sym.care}</p>
                </div>
                <p className="pt-3 border-t border-ocean-border text-xs font-extrabold text-ocean-primary">
                  {sym.doctor}
                </p>
              </div>
            ))}
          </div>
        </section>
      </main>

      {/* Appointment Booking Modal */}
      {bookingVet && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-ocean-navy/65 backdrop-blur-sm p-4"
          role="dialog"
          aria-modal="true"
        >
          <div className="w-full max-w-md rounded-3xl bg-white border border-ocean-border p-6 shadow-2xl space-y-5">
            <div className="flex items-center justify-between">
              <h3 className="text-xl font-extrabold text-ocean-navy">
                {locale === "ar"
                  ? `حجز موعد — ${bookingVet.nameAr}`
                  : `Book Visit — ${bookingVet.nameEn}`}
              </h3>
              <button
                type="button"
                onClick={() => setBookingVet(null)}
                className="w-10 h-10 rounded-full bg-ocean-ice flex items-center justify-center text-ocean-navy cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {bookedSuccess ? (
              <div className="text-center py-6 space-y-4">
                <div className="w-16 h-16 rounded-full bg-ocean-whatsapp text-white flex items-center justify-center mx-auto">
                  <CheckCircle2 className="w-9 h-9" />
                </div>
                <h4 className="text-xl font-extrabold text-ocean-navy">
                  {locale === "ar" ? "تم تأكيد حجز الموعد!" : "Appointment Confirmed!"}
                </h4>
                <p className="text-sm text-ocean-slate">
                  {locale === "ar"
                    ? `سيتواصل معك مكتب ${bookingVet.nameAr} على الرقم ${ownerPhone} لتأكيد الساعة.`
                    : `${bookingVet.nameEn}'s clinic will contact ${ownerPhone} to confirm your time slot.`}
                </p>
                <button
                  type="button"
                  onClick={() => setBookingVet(null)}
                  className="w-full min-h-[48px] rounded-full bg-ocean-primary text-white font-extrabold cursor-pointer"
                >
                  {locale === "ar" ? "إغلاق" : "Done"}
                </button>
              </div>
            ) : (
              <form onSubmit={handleBookSubmit} className="space-y-4">
                <div>
                  <label className="block text-sm font-bold text-ocean-navy mb-1">
                    {locale === "ar" ? "اسمك" : "Your Name"}
                  </label>
                  <input
                    type="text"
                    required
                    value={ownerName}
                    onChange={(e) => setOwnerName(e.target.value)}
                    className="w-full min-h-[46px] rounded-xl bg-ocean-ice border border-ocean-border px-3.5 text-base"
                  />
                </div>
                <div>
                  <label className="block text-sm font-bold text-ocean-navy mb-1">
                    {locale === "ar" ? "رقم الموبايل" : "Phone Number"}
                  </label>
                  <input
                    type="tel"
                    required
                    dir="ltr"
                    value={ownerPhone}
                    onChange={(e) => setOwnerPhone(e.target.value)}
                    className="w-full min-h-[46px] rounded-xl bg-ocean-ice border border-ocean-border px-3.5 text-base"
                  />
                </div>
                <div>
                  <label className="block text-sm font-bold text-ocean-navy mb-1">
                    {locale === "ar" ? "نوع الكائن والحالة" : "Pet Type & Symptoms"}
                  </label>
                  <input
                    type="text"
                    required
                    value={petType}
                    onChange={(e) => setPetType(e.target.value)}
                    placeholder={
                      locale === "ar"
                        ? "مثال: سمكة بيتا — خمول أو نقاط بيضاء"
                        : "e.g. Betta fish — white spots"
                    }
                    className="w-full min-h-[46px] rounded-xl bg-ocean-ice border border-ocean-border px-3.5 text-base"
                  />
                </div>
                <button
                  type="submit"
                  className="w-full min-h-[52px] rounded-full bg-ocean-yellow hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-base shadow-md cursor-pointer"
                >
                  {locale === "ar" ? "تأكيد الحجز (150 ج.م)" : "Confirm Booking (150 EGP)"}
                </button>
              </form>
            )}
          </div>
        </div>
      )}

      <Footer />
      <MobileActionBar />
    </div>
  );
}
