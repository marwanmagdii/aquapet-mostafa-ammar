export type ProductCategory =
  | "fish"
  | "food"
  | "tanks"
  | "filters"
  | "care"
  | "decor";

export interface CategoryMeta {
  id: ProductCategory;
  nameAr: string;
  nameEn: string;
  countAr: string;
  countEn: string;
  image: string;
}

export interface Product {
  id: string;
  category: ProductCategory;
  nameAr: string;
  nameEn: string;
  detailAr: string;
  detailEn: string;
  specAr: string;
  specEn: string;
  priceEgp: number;
  oldPriceEgp?: number;
  rating: number;
  reviews: number;
  image: string;
  bestSeller?: boolean;
  featured?: boolean;
}

export const categories: CategoryMeta[] = [
  {
    id: "fish",
    nameAr: "أسماك وسلاحف حية",
    nameEn: "Live Fish & Turtles",
    countAr: "3 فصائل",
    countEn: "3 species",
    image: "https://upload.wikimedia.org/wikipedia/commons/1/10/HM_Orange_M_Sarawut.jpg",
  },
  {
    id: "tanks",
    nameAr: "أحواض زجاجية",
    nameEn: "Glass Aquariums",
    countAr: "حوضان",
    countEn: "2 tanks",
    image:
      "https://cdn.shopify.com/s/files/1/1167/8568/files/uns-60u-20-5-gallon-ultra-clear-rimless-aquarium-1219639416.jpg",
  },
  {
    id: "filters",
    nameAr: "فلاتر ومضخات",
    nameEn: "Filters & Pumps",
    countAr: "منتجان",
    countEn: "2 items",
    image:
      "https://cdn.shopify.com/s/files/1/1167/8568/files/mighty-aquarium-filter-hob-35724033360072.jpg",
  },
  {
    id: "food",
    nameAr: "أغذية وفيتامينات",
    nameEn: "Fish & Turtle Food",
    countAr: "منتجان",
    countEn: "2 items",
    image:
      "https://cdn.shopify.com/s/files/1/0311/3149/files/xtreme-krill-flakes-8795996.jpg",
  },
  {
    id: "care",
    nameAr: "معالجة المياه",
    nameEn: "Water Conditioning",
    countAr: "منتجان",
    countEn: "2 items",
    image:
      "https://cdn.shopify.com/s/files/1/0311/3149/files/fritz-complete-water-conditioner-8116195.jpg",
  },
  {
    id: "decor",
    nameAr: "أخشاب ونباتات طبيعية",
    nameEn: "Driftwood & Plants",
    countAr: "منتج واحد",
    countEn: "1 item",
    image:
      "https://cdn.shopify.com/s/files/1/1167/8568/products/anubias-nana-on-driftwood-32215276355784.jpg",
  },
];

// TODO(owner): replace mock product names, details, EGP prices, and image URLs with real inventory
export const products: Product[] = [
  {
    id: "prod-1",
    category: "fish",
    nameAr: "سمكة بيتا هاف مون ملكي",
    nameEn: "Royal Halfmoon Betta",
    detailAr: "ألوان زاهية وبصحة ممتازة",
    detailEn: "Vibrant fins, quarantined",
    specAr: "حجم 5 سم • مياه عذبة 24-28°",
    specEn: "5cm size • Freshwater 24-28°C",
    priceEgp: 220,
    oldPriceEgp: 260,
    rating: 4.9,
    reviews: 142,
    image: "https://upload.wikimedia.org/wikipedia/commons/1/10/HM_Orange_M_Sarawut.jpg",
    bestSeller: true,
    featured: true,
  },
  {
    id: "prod-2",
    category: "fish",
    nameAr: "سلحفاة مائية خضراء",
    nameEn: "Green Aquatic Turtle",
    detailAr: "درع قوي ونشيطة",
    detailEn: "Active, calcium-fed shell",
    specAr: "حجم 6 سم • برمائية",
    specEn: "6cm shell • Semi-aquatic",
    priceEgp: 350,
    rating: 4.9,
    reviews: 98,
    image:
      "https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?auto=format&fit=crop&w=800&q=80",
    featured: true,
  },
  {
    id: "prod-3",
    category: "fish",
    nameAr: "زوج أنجل فيش مخطط",
    nameEn: "Striped Angelfish Pair",
    detailAr: "هادئ للأحواض المزروعة",
    detailEn: "Peaceful community pair",
    specAr: "زوج متناسق • 7 سم",
    specEn: "Matched pair • 7cm",
    priceEgp: 280,
    rating: 4.8,
    reviews: 64,
    image:
      "https://cdn.shopify.com/s/files/1/2046/4839/files/Gold_Marble_Angelfish.png",
  },
  {
    id: "prod-4",
    category: "food",
    nameAr: "رقائق تيترا لتعزيز الألوان",
    nameEn: "Tropical Color Flakes 250g",
    detailAr: "فيتامينات وأوميجا 3",
    detailEn: "Vitamin & Omega-3 formula",
    specAr: "عبوة 250 جم • لا يعكر الماء",
    specEn: "250g canister • Non-clouding",
    priceEgp: 195,
    oldPriceEgp: 230,
    rating: 4.9,
    reviews: 215,
    image:
      "https://cdn.shopify.com/s/files/1/0311/3149/files/xtreme-krill-flakes-8795996.jpg",
    featured: true,
  },
  {
    id: "prod-5",
    category: "food",
    nameAr: "أعواد سلاحف بالكالسيوم",
    nameEn: "Calcium Turtle Sticks",
    detailAr: "أعواد طافية لنمو الدرع",
    detailEn: "Floating D3 + Calcium sticks",
    specAr: "عبوة 200 جم • غني بالكالسيوم",
    specEn: "200g pack • High calcium",
    priceEgp: 160,
    rating: 4.7,
    reviews: 73,
    image:
      "https://cdn.shopify.com/s/files/1/0311/3149/files/xtreme-big-fella-pellets-2830428.jpg",
  },
  {
    id: "prod-6",
    category: "tanks",
    nameAr: "حوض زجاجي 60 سم بإضاءة LED",
    nameEn: "60cm Rimless LED Glass Tank",
    detailAr: "زجاج نقي 8 مم مع إضاءة",
    detailEn: "8mm crystal glass + LED bar",
    specAr: "60×35×40 سم • سعة 84 لتر",
    specEn: "60x35x40cm • 84L capacity",
    priceEgp: 1850,
    oldPriceEgp: 2100,
    rating: 5.0,
    reviews: 89,
    image:
      "https://cdn.shopify.com/s/files/1/1167/8568/files/uns-60u-20-5-gallon-ultra-clear-rimless-aquarium-1219639416.jpg",
    featured: true,
  },
  {
    id: "prod-7",
    category: "tanks",
    nameAr: "حوض نانو مكتبي 25 لتر",
    nameEn: "25L Curved Nano Cube Tank",
    detailAr: "زوايا بانوراما وفلتر مدمج",
    detailEn: "Curved glass + rear filter",
    specAr: "30×30×30 سم • إضاءة كليب",
    specEn: "30x30x30cm • Clip LED",
    priceEgp: 1150,
    rating: 4.8,
    reviews: 52,
    image:
      "https://cdn.shopify.com/s/files/1/1167/8568/files/uns-all-in-one-rimless-aquarium-white-34326166044872.jpg",
  },
  {
    id: "prod-8",
    category: "filters",
    nameAr: "فلتر شلال ثلاثي المراحل",
    nameEn: "Silent 3-Stage Waterfall Filter",
    detailAr: "ترشيح بيولوجي وميكانيكي",
    detailEn: "Bio-sponge + carbon + ceramic",
    specAr: "حتى 120 لتر • 500 لتر/ساعة",
    specEn: "Up to 120L • 500 L/h flow",
    priceEgp: 460,
    rating: 4.9,
    reviews: 118,
    image:
      "https://cdn.shopify.com/s/files/1/1167/8568/files/mighty-aquarium-filter-hob-35724033360072.jpg",
    featured: true,
  },
  {
    id: "prod-9",
    category: "filters",
    nameAr: "مضخة هواء مزدوجة هادئة",
    nameEn: "Dual-Outlet Silent Air Pump",
    detailAr: "أكسجين مستقر بدون اهتزاز",
    detailEn: "Anti-vibration dual oxygenation",
    specAr: "مخرجان + حجرا هواء",
    specEn: "2 outlets + 2 airstones",
    priceEgp: 290,
    rating: 4.7,
    reviews: 44,
    image:
      "https://cdn.shopify.com/s/files/1/0311/3149/files/aquarium-co-op-air-pump-with-battery-backup-7221907.jpg",
  },
  {
    id: "prod-10",
    category: "care",
    nameAr: "مزيل كلور فوري أكوا سيف",
    nameEn: "AquaSafe Instant Dechlorinator",
    detailAr: "حماية فورية للسمك",
    detailEn: "Neutralizes chlorine & metals",
    specAr: "250 مل • يعالج 1000 لتر",
    specEn: "250ml • Treats 1,000L",
    priceEgp: 140,
    rating: 4.9,
    reviews: 176,
    image:
      "https://cdn.shopify.com/s/files/1/0311/3149/files/fritz-complete-water-conditioner-8116195.jpg",
    featured: true,
  },
  {
    id: "prod-11",
    category: "care",
    nameAr: "بكتيريا نافعة لتأسيس الحوض",
    nameEn: "Live Bio-Starter Bacteria",
    detailAr: "توازن سريع للمياه الجديدة",
    detailEn: "Fast nitrogen cycle starter",
    specAr: "250 مل • يمنع الأمونيا",
    specEn: "250ml • Ammonia control",
    priceEgp: 210,
    rating: 4.8,
    reviews: 61,
    image:
      "https://cdn.shopify.com/s/files/1/0311/3149/files/fritz-zyme-7-live-bacteria-freshwater-3972840.jpg",
  },
  {
    id: "prod-12",
    category: "decor",
    nameAr: "خشب أبانوس طبيعي مع أنوبياس",
    nameEn: "Natural Driftwood + Live Anubias",
    detailAr: "مخبأ طبيعي ونبات حي",
    detailEn: "Pre-cured wood & hardy plant",
    specAr: "طول 25-30 سم • غاطس جاهز",
    specEn: "25-30cm • Pre-sunk wood",
    priceEgp: 320,
    rating: 4.9,
    reviews: 83,
    image:
      "https://cdn.shopify.com/s/files/1/1167/8568/products/anubias-nana-on-driftwood-32215276355784.jpg",
  },
];
