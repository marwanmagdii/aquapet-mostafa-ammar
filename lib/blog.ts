export type BlogCategory = "all" | "tanks" | "fish" | "turtles" | "water";

export interface BlogSectionContent {
  headingAr: string;
  headingEn: string;
  bodyAr: string;
  bodyEn: string;
}

export interface BlogPost {
  slug: string;
  category: Exclude<BlogCategory, "all">;
  categoryAr: string;
  categoryEn: string;
  titleAr: string;
  titleEn: string;
  excerptAr: string;
  excerptEn: string;
  readTimeAr: string;
  readTimeEn: string;
  dateAr: string;
  dateEn: string;
  authorAr: string;
  authorEn: string;
  image: string;
  keyPointsAr: string[];
  keyPointsEn: string[];
  sections: BlogSectionContent[];
  relatedProductIds: string[];
}

export const blogPosts: BlogPost[] = [
  {
    slug: "cycling-aquarium-guide",
    category: "tanks",
    categoryAr: "تأسيس الأحواض",
    categoryEn: "Tank Setup",
    titleAr: "الدورة البيولوجية للمبتدئين: كيف تؤسس حوضك بدون خسائر",
    titleEn: "Aquarium Nitrogen Cycle: Zero-Loss Setup Guide",
    excerptAr:
      "أهم خطوة قبل شراء أي سمكة جديدة: تشغيل الفلتر والبكتيريا النافعة لمدة 14 إلى 21 يوماً.",
    excerptEn:
      "The #1 rule before adding any fish: establish beneficial nitrifying bacteria for clean, zero-ammonia water.",
    readTimeAr: "4 دقائق",
    readTimeEn: "4 min read",
    dateAr: "نوفمبر 2026",
    dateEn: "Nov 2026",
    authorAr: "فريق مصطفى عمار",
    authorEn: "Mostafa Ammar Team",
    image:
      "https://cdn.shopify.com/s/files/1/1167/8568/files/uns-60u-20-5-gallon-ultra-clear-rimless-aquarium-1219639416.jpg",
    keyPointsAr: [
      "أضف مزيل الكلور فوراً عند ملء الحوض لأول مرة.",
      "شغّل الفلتر 24 ساعة يومياً بدون إطفاء نهائياً.",
      "أضف بكتيريا نافعة واختبر الماء قبل إدخال أول سمكة.",
      "ابدأ بعدد قليل من الأسماك القوية وتدرّج في الإضافة.",
    ],
    keyPointsEn: [
      "Treat tap water with a dechlorinator immediately on initial fill.",
      "Keep your biological filter running 24/7—never switch it off at night.",
      "Dose live bio-starter bacteria before introducing your first fish.",
      "Stock gradually starting with 2–3 hardy fish while ammonia stays at 0 ppm.",
    ],
    sections: [
      {
        headingAr: "لماذا تموت الأسماك في الأسبوع الأول؟",
        headingEn: "Why do new tanks lose fish in week one?",
        bodyAr:
          "السبب الأكثر شيوعاً هو تراكم الأمونيا الناتجة عن فضلات الأسماك وبقايا الطعام في حوض لم تتكون فيه البكتيريا النافعة بعد. الكلور في مياه الصنبور يقتل هذه البكتيريا ويجرح خياشيم الأسماك، لذلك تبدأ الدورة البيولوجية السليمة دائماً بإزالة الكلور وإضافة البكتيريا النافعة.",
        bodyEn:
          "Unseen ammonia builds up rapidly from fish waste and leftover food when beneficial bacteria colonies have not settled into your filter media yet. Tap chlorine burns gills and wipes out good bacteria, which is why every healthy setup starts with dechlorinator plus live nitrifying bacteria.",
      },
      {
        headingAr: "الخطوات العملية لتأسيس الحوض",
        headingEn: "Step-by-step setup routine",
        bodyAr:
          "اغسل الجرش بالماء فقط بدون صابون، ثبّت الفلتر والسخان على 25-26 درجة، أضف الجرعة الموصى بها من مزيل الكلور أكوا سيف، ثم أضف بكتيريا نافعة لتسريع التوازن البيولوجي. اترك الفلتر يعمل باستمرار وأطعم بقدر ضئيل أو انتظر استقرار المياه قبل إدخال الأسماك الحساسة.",
        bodyEn:
          "Rinse substrate with plain water only (never soap), mount your filter and set the heater around 25–26°C, dose instant dechlorinator, and seed live bio-starter bacteria into the filter media. Keep circulation running continuously before adding sensitive species.",
      },
    ],
    relatedProductIds: ["prod-6", "prod-10", "prod-11", "prod-8"],
  },
  {
    slug: "betta-fish-complete-care",
    category: "fish",
    categoryAr: "رعاية الأسماك",
    categoryEn: "Fish Care",
    titleAr: "الدليل الشامل لتربية سمكة البيتا هاف مون والحفاظ على ذيلها",
    titleEn: "Royal Halfmoon Betta Care: Tank Size, Flow & Diet",
    excerptAr:
      "لماذا لا تناسب البولة الصغيرة سمكة البيتا؟ المواصفات المثالية للحجم والحرارة والفلترة الهادئة.",
    excerptEn:
      "Why tiny bowls stunt Betta health—learn the ideal heated tank size, gentle filtration, and high-protein feeding.",
    readTimeAr: "3 دقائق",
    readTimeEn: "3 min read",
    dateAr: "نوفمبر 2026",
    dateEn: "Nov 2026",
    authorAr: "فريق مصطفى عمار",
    authorEn: "Mostafa Ammar Team",
    image:
      "https://upload.wikimedia.org/wikipedia/commons/1/10/HM_Orange_M_Sarawut.jpg",
    keyPointsAr: [
      "حوض لا يقل عن 15-25 لتر مع غطاء محكم.",
      "درجة حرارة مستقرة بين 25 و28 درجة مئوية.",
      "تيار مياه هادئ يحافظ على الزعانف الطويلة من التمزق.",
      "نباتات ناعمة مثل الأنوبياس بدون حواف بلاستيكية حادة.",
    ],
    keyPointsEn: [
      "Use at least a 15–25L tank with a snug lid (Bettas jump).",
      "Maintain warm tropical water steadily between 25–28°C.",
      "Choose low-flow filtration so long Halfmoon fins never tear.",
      "Decorate with smooth live Anubias or cured driftwood instead of sharp plastic.",
    ],
    sections: [
      {
        headingAr: "الحوض المثالي لسمكة البيتا",
        headingEn: "The right habitat for Halfmoon fins",
        bodyAr:
          "تحتاج البيتا هاف مون إلى مساحة كافية للسباحة ومياه دافئة مستقرة. الكرات الزجاجية الصغيرة تفقد الحرارة بسرعة وتراكم السموم خلال ساعات، بينما حوض النانو 25 لتر مع فلتر هادئ ونباتات حية يمنحها ألواناً زاهية وعمرًا أطول.",
        bodyEn:
          "Halfmoon Bettas thrive in warm, calm water with room to explore. Small bowls suffer wild temperature swings and fast ammonia spikes, whereas a 25L nano tank with gentle filtration and live plants keeps fins intact and colors bright.",
      },
      {
        headingAr: "نظام التغذية اليومي",
        headingEn: "Daily feeding without bloat",
        bodyAr:
          "معدة البيتا صغيرة بحجم عينها تقريباً. قدّم كمية صغيرة تلتهمها في دقيقة واحدة مرة أو مرتين يومياً، وتجنب الإفراط حتى لا يتعكر الماء أو تصاب السمكة بانتفاخ المثانة.",
        bodyEn:
          "A Betta's stomach is roughly the size of its eye. Feed small high-protein portions once or twice daily that are finished within 60 seconds, with one fasting day per week if needed to prevent swim-bladder bloat.",
      },
    ],
    relatedProductIds: ["prod-1", "prod-7", "prod-4", "prod-12"],
  },
  {
    slug: "aquatic-turtle-basking-uvb",
    category: "turtles",
    categoryAr: "السلاحف المائية",
    categoryEn: "Turtle Care",
    titleAr: "رعاية السلاحف المائية: منصة التشمس وإضاءة UVB والوقاية من ليونة الدرع",
    titleEn: "Aquatic Turtle Care: Basking Platform, UVB & Shell Health",
    excerptAr:
      "كل ما تحتاجه سلحفاتك المائية لتنمو بدرع قوي وصلب: جزيرة جافة، كالسيوم، وفيتامين D3.",
    excerptEn:
      "Essential daily setup for thriving semi-aquatic turtles: dry basking dock, heat + UVB light, and calcium nutrition.",
    readTimeAr: "4 دقائق",
    readTimeEn: "4 min read",
    dateAr: "نوفمبر 2026",
    dateEn: "Nov 2026",
    authorAr: "بإشراف د. سلمى منصور",
    authorEn: "Reviewed with Dr. Salma Mansour",
    image:
      "https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?auto=format&fit=crop&w=800&q=80",
    keyPointsAr: [
      "وفّر منصة تشمس جافة بالكامل تخرج عليها السلحفاة بسهولة.",
      "استخدم إضاءة UVB لمدة 8-10 ساعات يومياً لامتصاص الكالسيوم.",
      "قدّم أعواد السلاحف الغنية بالكالسيوم وفيتامين D3.",
      "راقب نظافة المياه بفلتر قوي لأن السلاحف تستهلك غذاءً عالياً.",
    ],
    keyPointsEn: [
      "Provide a completely dry basking platform easy for the turtle to climb onto.",
      "Run dedicated UVB + heat lighting 8–10 hours daily for calcium absorption.",
      "Feed floating pellets enriched with Calcium and Vitamin D3.",
      "Use oversized filtration because aquatic turtles create heavy bioload.",
    ],
    sections: [
      {
        headingAr: "لماذا تلين صدفة السلحفاة؟",
        headingEn: "Preventing soft-shell syndrome early",
        bodyAr:
          "اعتماد السلاحف الصغيرة على الخس والجمبري المجفف فقط مع غياب منصة التشمس يسبب نقص الكالسيوم وضعف الدرع سريعاً. الجمع بين التغذية المتوازنة بالأعواد المدعمة والتشمس الجاف تحت إضاءة مناسبة يبني صدفة قوية ويحمي العظام.",
        bodyEn:
          "Feeding only dried shrimp or lettuce without proper basking quickly triggers calcium deficiency and shell softening. Pairing balanced fortified turtle sticks with dry basking heat and UVB builds dense, healthy shell growth.",
      },
      {
        headingAr: "متى تراجع الطبيب البيطري؟",
        headingEn: "When to book an aquatic vet checkup",
        bodyAr:
          "إذا لاحظت تورم العينين، أو تنفساً بفم مفتوح مع فقاعات، أو بقعاً بيضاء رخوة على الدرع، تواصل فوراً مع طبيب السلاحف المختص للفحص المبكر.",
        bodyEn:
          "If your turtle shows swollen eyes, wheezing, open-mouth breathing, or soft discolored shell spots, book an exotic/aquatic vet visit promptly for targeted care.",
      },
    ],
    relatedProductIds: ["prod-2", "prod-5", "prod-8", "prod-10"],
  },
  {
    slug: "water-changes-filter-maintenance",
    category: "water",
    categoryAr: "جودة المياه",
    categoryEn: "Water Care",
    titleAr: "تغيير المياه وتنظيف الفلتر أسبوعياً بدون تدمير البكتيريا النافعة",
    titleEn: "Weekly Water Changes Without Crashing Your Bio-Filter",
    excerptAr:
      "الخطأ الشائع الذي يسبب تعكر الحوض بعد التنظيف، والطريقة الآمنة للحفاظ على مياه كريستالية.",
    excerptEn:
      "Stop cloudy post-cleaning blooms: learn the 25–30% water change rule and safe filter sponge rinsing.",
    readTimeAr: "3 دقائق",
    readTimeEn: "3 min read",
    dateAr: "نوفمبر 2026",
    dateEn: "Nov 2026",
    authorAr: "فريق مصطفى عمار",
    authorEn: "Mostafa Ammar Team",
    image:
      "https://cdn.shopify.com/s/files/1/0311/3149/files/fritz-complete-water-conditioner-8116195.jpg",
    keyPointsAr: [
      "غيّر 25% إلى 30% من مياه الحوض أسبوعياً فقط — لا تفرغ الحوض كاملاً.",
      "لا تغسل إسفنجة الفلتر بماء الحنفية أو الصابون نهائياً.",
      "اشطف ميديا الفلتر في دلو من مياه الحوض المسحوبة نفسها.",
      "أضف مزيل الكلور للمياه الجديدة قبل صبّها وتطابق الحرارة.",
    ],
    keyPointsEn: [
      "Change only 25–30% of water weekly—never empty or scrub the entire tank.",
      "Never rinse filter sponges under chlorinated tap water or soap.",
      "Gently squeeze filter sponges in a bucket of removed tank water.",
      "Always dechlorinate and temperature-match fresh replacement water.",
    ],
    sections: [
      {
        headingAr: "قاعدة التغيير الجزئي 30%",
        headingEn: "The 30% partial change rule",
        bodyAr:
          "تفريغ الحوض بالكامل وغسل الجرش تحت الصنبور يصدم الأسماك ويزيل مستعمرات البكتيريا المفيدة فيتحول الماء إلى لون ضبابي خلال يومين. سحب ثلث الماء بالشفاط وإعادة تعبئته بمياه معالجة يحافظ على نقاء مثالي واستقرار دائم.",
        bodyEn:
          "Draining 100% of your aquarium shocks fish and strips away beneficial bacteria, causing milky bacterial blooms within days. Siphoning 25–30% of water weekly and refilling with temperature-matched conditioned water keeps water crystal clear.",
      },
      {
        headingAr: "طريقة تنظيف الفلتر الآمنة",
        headingEn: "Safe filter media rinsing",
        bodyAr:
          "افصل الفلتر مؤقتاً أثناء سحب المياه، وضع الإسفنجة في الدلو الذي سحبت فيه ماء الحوض واعصرها برفق لإزالة الأوساخ الظاهرة فقط ثم أعدها فوراً.",
        bodyEn:
          "Pause the filter during your siphon routine, gently swish and squeeze the sponge inside your bucket of old aquarium water to clear debris, then reinstall right away.",
      },
    ],
    relatedProductIds: ["prod-10", "prod-8", "prod-11", "prod-9"],
  },
];
