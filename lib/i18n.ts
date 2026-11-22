export type Locale = "ar" | "en";

export const DEFAULT_LOCALE: Locale = "ar";

export interface Dictionary {
  meta: {
    title: string;
    description: string;
  };
  nav: {
    categories: string;
    products: string;
    whyUs: string;
    app: string;
    vets: string;
    blog: string;
    getApp: string;
    langSwitch: string;
  };
  hero: {
    eyebrow: string;
    headline: string;
    feature1: string;
    feature2: string;
    feature3: string;
    ctaShop: string;
    ctaApp: string;
    ctaWhatsapp: string;
    scrollHint: string;
    loading: string;
  };
  categories: {
    title: string;
    subtitle: string;
  };
  products: {
    title: string;
    showing: string;
    clearFilter: string;
    bestSeller: string;
    currency: string;
    order: string;
    seeAll: string;
    showLess: string;
  };
  whyUs: {
    title: string;
    caption: string;
    items: Array<{ title: string; detail: string }>;
    flowTitle: string;
    flowSteps: [string, string, string];
  };
  loyaltyApp: {
    title: string;
    subtitle: string;
    tiers: [string, string, string];
    getApp: string;
    comingSoon: string;
    mockupBrand: string;
    mockupTier: string;
    mockupPointsValue: string;
    mockupReminder: string;
  };
  vets: {
    title: string;
    call: string;
    whatsapp: string;
    maps: string;
    social: string;
  };
  contact: {
    title: string;
    hoursTitle: string;
    whatsappBtn: string;
    callBtn: string;
    mapsBtn: string;
  };
  mobileBar: {
    whatsapp: string;
    call: string;
  };
  footer: {
    rights: string;
  };
}

export const dictionaries: Record<Locale, Dictionary> = {
  ar: {
    meta: {
      title: "مصطفى عمار للأكواريوم | أسماك الزينة",
      description: "أسماك زينة، سلاحف مائية، مستلزمات الأحواض، ورعاية بيطرية موثوقة.",
    },
    nav: {
      categories: "الأقسام",
      products: "المنتجات",
      whyUs: "لماذا نحن",
      app: "التطبيق",
      vets: "الأطباء",
      blog: "المدونة",
      getApp: "التطبيق",
      langSwitch: "EN",
    },
    hero: {
      eyebrow: "مصطفى عمار للأكواريوم",
      headline: "سمكتك. عالمك.",
      feature1: "أسماك وسلاحف بصحة ممتازة",
      feature2: "أغذية وفلاتر وأحواض متكاملة",
      feature3: "توصيل آمن للأسماك الحية",
      ctaShop: "تصفح المتجر",
      ctaApp: "حمّل التطبيق",
      ctaWhatsapp: "اطلب واتساب",
      scrollHint: "مرر للأسفل",
      loading: "جاري تجهيز الحوض...",
    },
    categories: {
      title: "الأقسام",
      subtitle: "كل ما يحتاجه حوضك في 6 أقسام",
    },
    products: {
      title: "الأكثر طلباً",
      showing: "عرض:",
      clearFilter: "إلغاء التصفية",
      bestSeller: "الأكثر مبيعاً",
      currency: "ج.م",
      order: "اطلب",
      seeAll: "عرض الكل (12)",
      showLess: "عرض أقل",
    },
    whyUs: {
      title: "لماذا نحن",
      caption: "أسماك مفحوصة صحياً قبل التسليم.",
      items: [
        { title: "فحص صحي", detail: "قبل التسليم" },
        { title: "توصيل آمن", detail: "أكسجين كامل" },
        { title: "نقاط ولاء", detail: "كل طلب" },
        { title: "أطباء موثوقون", detail: "رعاية سريعة" },
      ],
      flowTitle: "تذكير الأكل",
      flowSteps: ["اشترِ", "تنبيه", "أعد"],
    },
    loyaltyApp: {
      title: "التطبيق والولاء",
      subtitle: "اجمع النقاط وتابع مواعيد الإطعام",
      tiers: ["برونزية", "فضية", "ذهبية"],
      getApp: "سجّل للتطبيق",
      comingSoon: "قريباً على آيفون وأندرويد",
      mockupBrand: "نادي مصطفى عمار",
      mockupTier: "ذهبية",
      mockupPointsValue: "1,250 نقطة",
      mockupReminder: "موعد الأكل • 7:00 م",
    },
    vets: {
      title: "أطباء موثوقون",
      call: "اتصال",
      whatsapp: "واتساب",
      maps: "الموقع",
      social: "الصفحة",
    },
    contact: {
      title: "زُرنا وتواصل",
      hoursTitle: "مواعيد العمل",
      whatsappBtn: "واتساب المتجر",
      callBtn: "اتصل بنا",
      mapsBtn: "خريطة جوجل",
    },
    mobileBar: {
      whatsapp: "واتساب",
      call: "اتصال",
    },
    footer: {
      rights: "مصطفى عمار للأكواريوم © 2026",
    },
  },
  en: {
    meta: {
      title: "Mostafa Ammar Aquatics | Fish & Tanks",
      description: "Healthy ornamental fish, turtles, tank gear, and trusted aquatic vets.",
    },
    nav: {
      categories: "Categories",
      products: "Products",
      whyUs: "Why Us",
      app: "App",
      vets: "Vets",
      blog: "Blog",
      getApp: "Get App",
      langSwitch: "عربي",
    },
    hero: {
      eyebrow: "Mostafa Ammar Aquatics",
      headline: "Your fish. Your world.",
      feature1: "Healthy fish selected with care",
      feature2: "Food, filters, and complete tanks",
      feature3: "Safe oxygenated live fish delivery",
      ctaShop: "Shop now",
      ctaApp: "Get app",
      ctaWhatsapp: "WhatsApp",
      scrollHint: "Scroll down",
      loading: "Preparing the tank...",
    },
    categories: {
      title: "Categories",
      subtitle: "Everything your tank needs in 6 categories",
    },
    products: {
      title: "Featured Products",
      showing: "Showing:",
      clearFilter: "Clear filter",
      bestSeller: "Best seller",
      currency: "EGP",
      order: "Order",
      seeAll: "See all (12)",
      showLess: "Show less",
    },
    whyUs: {
      title: "Why Us",
      caption: "Hand-picked, health-checked fish before delivery.",
      items: [
        { title: "Health Check", detail: "Every fish" },
        { title: "Safe Delivery", detail: "Oxygen pack" },
        { title: "Loyalty Points", detail: "Every order" },
        { title: "Trusted Vets", detail: "Fast care" },
      ],
      flowTitle: "Food reminder",
      flowSteps: ["Buy", "Alert", "Reorder"],
    },
    loyaltyApp: {
      title: "App & Loyalty",
      subtitle: "Collect points and track feeding times",
      tiers: ["Bronze", "Silver", "Gold"],
      getApp: "Get the app",
      comingSoon: "Coming soon iOS & Android",
      mockupBrand: "Mostafa Ammar Club",
      mockupTier: "Gold",
      mockupPointsValue: "1,250 pts",
      mockupReminder: "Feeding • 7:00 PM",
    },
    vets: {
      title: "Trusted Vets",
      call: "Call",
      whatsapp: "WhatsApp",
      maps: "Maps",
      social: "Social",
    },
    contact: {
      title: "Visit & Contact",
      hoursTitle: "Opening Hours",
      whatsappBtn: "Shop WhatsApp",
      callBtn: "Call Shop",
      mapsBtn: "Google Maps",
    },
    mobileBar: {
      whatsapp: "WhatsApp",
      call: "Call",
    },
    footer: {
      rights: "Mostafa Ammar Aquatics © 2026",
    },
  },
};
