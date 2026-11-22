export interface ContactInfo {
  shopNameAr: string;
  shopNameEn: string;
  phoneDisplay: string;
  phoneHref: string;
  whatsappNumber: string;
  addressAr: string;
  addressEn: string;
  hoursLabelAr: string;
  hoursLabelEn: string;
  mapsUrl: string;
  youtubeUrl: string;
  instagramUrl: string;
  facebookUrl: string;
  tiktokUrl: string;
  weekDays: Array<{
    dayAr: string;
    dayEn: string;
    hoursAr: string;
    hoursEn: string;
    isFriday?: boolean;
  }>;
}

export const contactInfo: ContactInfo = {
  shopNameAr: "مصطفى عمار للأكواريوم",
  shopNameEn: "Mostafa Ammar Aquatics",
  // TODO(owner): replace placeholder phone display and tel: link
  phoneDisplay: "+20 100 000 0000",
  // TODO(owner): replace placeholder phone href
  phoneHref: "tel:+201000000000",
  // TODO(owner): replace placeholder WhatsApp number (international format without +)
  whatsappNumber: "201000000000",
  // TODO(owner): replace placeholder shop street address (Arabic & English)
  addressAr: "شارع التحرير، الدقي، الجيزة",
  addressEn: "El Tahrir St., Dokki, Giza",
  // TODO(owner): replace placeholder opening hours summary
  hoursLabelAr: "11 ص – 11 م (الجمعة من 2 م)",
  hoursLabelEn: "11 AM – 11 PM (Fri from 2 PM)",
  // TODO(owner): replace placeholder Google Maps URL
  mapsUrl: "https://maps.google.com/?q=Dokki,Giza,Egypt",
  youtubeUrl: "https://www.youtube.com/@Mostafa.3mmar",
  instagramUrl: "https://www.instagram.com/darshammar/reels/",
  facebookUrl: "https://www.facebook.com/darsh.ammar1",
  tiktokUrl: "https://www.tiktok.com/discover/mostafa-ammar",
  // TODO(owner): replace placeholder daily schedule if needed
  weekDays: [
    { dayAr: "السبت", dayEn: "Sat", hoursAr: "11ص-11م", hoursEn: "11-11" },
    { dayAr: "الأحد", dayEn: "Sun", hoursAr: "11ص-11م", hoursEn: "11-11" },
    { dayAr: "الإثنين", dayEn: "Mon", hoursAr: "11ص-11م", hoursEn: "11-11" },
    { dayAr: "الثلاثاء", dayEn: "Tue", hoursAr: "11ص-11م", hoursEn: "11-11" },
    { dayAr: "الأربعاء", dayEn: "Wed", hoursAr: "11ص-11م", hoursEn: "11-11" },
    { dayAr: "الخميس", dayEn: "Thu", hoursAr: "11ص-11م", hoursEn: "11-11" },
    { dayAr: "الجمعة", dayEn: "Fri", hoursAr: "2م-11م", hoursEn: "2-11", isFriday: true },
  ],
};

export function buildWhatsappUrl(message: string): string {
  return `https://wa.me/${contactInfo.whatsappNumber}?text=${encodeURIComponent(message)}`;
}
