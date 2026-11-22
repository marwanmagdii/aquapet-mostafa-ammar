# 01 — Sitemap & Content Inventory

The site is a single-page application (`app/page.tsx`) with 7 main bands (`Hero` + 6 content sections), plus `Header`, `Footer`, and `MobileActionBar`.

---

## 1. Header (`components/Header.tsx`)
- **Purpose:** Brand anchor, 5-link section navigation, language toggle, mobile menu drawer.
- **Visible Text (AR / EN):**
  - Brand: `مصطفى عمار` / `Mostafa Ammar`
  - Nav links: `الأقسام` / `Categories`, `المنتجات` / `Products`, `لماذا نحن` / `Why Us`, `التطبيق` / `App`, `الأطباء` / `Vets`
  - Language button: `EN` (when AR) / `عربي` (when EN)
  - CTA button: `التطبيق` / `Get App`
- **Images & Icons:** `/logo.png`, Lucide `Globe`, `ArrowRight` (`rtl:rotate-180`), `Smartphone`, `Menu`, `X`.

---

## 2. Hero (`#hero` — `components/HeroScrollScene.tsx`)
- **Purpose:** Scroll-driven underwater story ending with logo reveal and primary CTAs.
- **Word Count:** `25` words (AR) / `29` words (EN)
- **Visible Text:**

| Element | Arabic | English |
| --- | --- | --- |
| Eyebrow | `مصطفى عمار للأكواريوم` | `Mostafa Ammar Aquatics` |
| H1 Headline | `سمكتك. عالمك.` | `Your fish. Your world.` |
| Feature 1 | `أسماك وسلاحف بصحة ممتازة` | `Healthy fish selected with care` |
| Feature 2 | `أغذية وفلاتر وأحواض متكاملة` | `Food, filters, and complete tanks` |
| Feature 3 | `توصيل آمن للأسماك الحية` | `Safe oxygenated live fish delivery` |
| Primary CTA | `تصفح المتجر` | `Shop now` |
| Secondary CTA 1 | `حمّل التطبيق` | `Get app` |
| Secondary CTA 2 | `اطلب واتساب` | `WhatsApp` |
| Scroll Hint | `مرر للأسفل` | `Scroll down` |
| Loader | `جاري تجهيز الحوض...` | `Preparing the tank...` |

- **Images & Icons:** Canvas frames (`/frames/frame_001.webp`..`240` or `/frames-mobile/frame_001.webp`..`120`), `/logo.png`, `/social/whatsapp.png`, Lucide `ShoppingBag`, `Smartphone`, `ChevronDown`.

---

## 3. Categories (`#categories` — `components/sections/CategoriesSection.tsx`)
- **Purpose:** 6 visual category tiles linking to `#products`.
- **Word Count:** `20` words (AR) / `23` words (EN)
- **Heading & Subtitle:** `الأقسام` / `Categories` — `كل ما يحتاجه حوضك في 6 أقسام` / `Everything your tank needs in 6 categories`
- **Tiles (6):**

| Category ID | Arabic Title | English Title | Image Path | Lucide Icon |
| --- | --- | --- | --- | --- |
| `fish` | `أسماك وسلاحف` | `Fish & Turtles` | `/images/betta.webp` | `Fish` |
| `food` | `أغذية الأسماك` | `Fish Food` | `/images/goldfish.webp` | `Utensils` |
| `tanks` | `أحواض زجاجية` | `Glass Tanks` | `/images/aquascape.webp` | `Box` |
| `filters` | `فلاتر ومضخات` | `Filters & Pumps` | `/images/gourami.webp` | `Waves` |
| `care` | `عناية بالمياه` | `Water Care` | `/images/angelfish.webp` | `Droplets` |
| `decor` | `ديكور ونباتات` | `Decor & Plants` | `/images/swordtail.webp` | `Leaf` |

---

## 4. Featured Products (`#products` — `components/sections/ProductsSection.tsx`)
- **Purpose:** Display 8 featured products (expandable to 12 via `عرض الكل (12)` / `See all (12)`) with direct WhatsApp ordering.
- **Word Count:** `87` words (AR) / `86` words (EN) when showing 8 featured items.
- **Heading & Controls:** `الأكثر طلباً` / `Featured Products` | Toggle: `عرض الكل (12)` / `See all (12)` <-> `عرض أقل` / `Show less` | Badge: `الأكثر مبيعاً` / `Best seller` | Button: `اطلب` / `Order`

| ID | Arabic Name & Detail | English Name & Detail | Price (EGP) | Image | Featured |
| --- | --- | --- | ---: | --- | --- |
| `prod-1` | `سمكة بيتا هاف مون` — `ألوان زاهية وصحة ممتازة` | `Halfmoon Betta Fish` — `Vibrant fins, health checked` | 220 | `/images/betta.webp` | Yes (Best seller) |
| `prod-2` | `سلحفاة مائية خضراء` — `درع قوي ونشاط عالي` | `Green Aquatic Turtle` — `Strong shell, active` | 350 | `/images/turtle.webp` | Yes |
| `prod-3` | `زوج أنجل فيش` — `هادئ ومناسب للأحواض المزروعة` | `Striped Angelfish Pair` — `Peaceful tank companions` | 280 | `/images/angelfish.webp` | Yes |
| `prod-4` | `أكل تيترا للألوان` — `يقوي المناعة بدون تعكير` | `Tropical Color Flakes` — `Clean water vitamin flakes` | 195 | `/images/goldfish.webp` | Yes |
| `prod-5` | `وجبة سلاحف بالكالسيوم` — `أعواد طافية لنمو الدرع` | `Calcium Turtle Sticks` — `Floating shell nutrition` | 160 | `/images/turtle.webp` | No |
| `prod-6` | `حوض زجاجي 60 سم` — `زجاج نقي بإضاءة LED` | `60cm LED Glass Tank` — `Clear glass + LED hood` | 1850 | `/images/aquascape.webp` | Yes |
| `prod-7` | `حوض نانو 25 لتر` — `زوايا دائرية وفلتر مدمج` | `25L Desktop Nano Tank` — `Curved glass, built-in filter` | 1150 | `/images/gourami.webp` | No |
| `prod-8` | `فلتر شلال هادئ` — `ترشيح ثلاثي بدون صوت` | `Quiet Waterfall Filter` — `Silent 3-stage filtration` | 460 | `/images/gourami.webp` | Yes |
| `prod-9` | `مضخة هواء مزدوجة` — `أكسجين مستقر للحوض` | `Dual Air Pump Kit` — `Steady tank oxygenation` | 290 | `/images/swordtail.webp` | No |
| `prod-10` | `مزيل كلور فوري` — `يحمي السمك فوراً` | `Instant Water Conditioner` — `Safe tap water instantly` | 140 | `/images/angelfish.webp` | Yes |
| `prod-11` | `بكتيريا نافعة للحوض` — `توازن سريع للمياه الجديدة` | `Live Tank Bacteria` — `Fast nitrogen cycle starter` | 210 | `/images/betta.webp` | No |
| `prod-12` | `خشب طبيعي مع أنوبياس` — `مخبأ طبيعي وتنقية للمياه` | `Driftwood + Live Anubias` — `Natural shelter & live plant` | 320 | `/images/aquascape.webp` | Yes |

- **Images & Icons:** Product images above, `/social/whatsapp.png`, Lucide `Star`, `ArrowDown`, `ArrowUp`.

---

## 5. Why Us (`#why-us` — `components/sections/WhyUsSection.tsx`)
- **Purpose:** Trust pillars (merged About story) + 3-step feeding reminder flow.
- **Word Count:** `34` words (AR) / `35` words (EN)
- **Heading & Caption:** `لماذا نحن` / `Why Us` — `نختار كل سمكة بعناية ونفحصها صحياً قبل التسليم.` / `Every fish is hand-picked and health-checked before delivery.`
- **4 Tiles:**
  1. `فحص صحي` (`قبل كل تسليم`) / `Health Check` (`Before every delivery`) — `HeartPulse`
  2. `توصيل آمن` (`أكسجين كامل`) / `Safe Delivery` (`Full oxygen pack`) — `Truck`
  3. `نقاط ولاء` (`مع كل طلب`) / `Loyalty Points` (`Earn every order`) — `Award`
  4. `أطباء موثوقون` (`رعاية فورية`) / `Trusted Vets` (`Fast expert care`) — `Stethoscope`
- **3-Step Flow:** `تذكير الأكل`: `اشترِ` → `تنبيه` → `أعد الطلب` / `Food reminder`: `Buy` → `Reminded` → `Reorder` (`ShoppingBag`, `BellRing`, `RefreshCw`, `ArrowRight`).

---

## 6. App & Loyalty (`#app` — `components/sections/LoyaltyAppSection.tsx`)
- **Purpose:** Present loyalty tiers and mobile app preview.
- **Word Count:** `27` words (AR) / `30` words (EN)
- **Heading & Subtitle:** `التطبيق والولاء` / `App & Loyalty` — `اجمع النقاط وتابع مواعيد الإطعام` / `Collect points and track feeding times`
- **Tier Bar:** `برونزية` / `Bronze`, `فضية` / `Silver`, `ذهبية` / `Gold` (highlighted)
- **CTAs:** `سجّل للتطبيق` / `Get the app`, badge `قريباً iOS و Android` / `Coming soon iOS & Android`
- **Phone Mockup:** `نادي مصطفى عمار` / `Mostafa Ammar Club`, `ذهبية` / `Gold`, `1,250 نقطة` / `1,250 pts`, `موعد الأكل • 7:00 م` / `Feeding • 7:00 PM`
- **Images & Icons:** `/logo.png`, Lucide `Award`, `Smartphone`, `Sparkles`, `Bell`.

---

## 7. Trusted Vets (`#vets` — `components/sections/VetsSection.tsx`)
- **Purpose:** 3 area-grouped aquatic vet contacts.
- **Word Count:** `37` words (AR) / `37` words (EN)
- **Heading:** `أطباء موثوقون` / `Trusted Vets`
- **Cards:**
  1. `المهندسين` / `Mohandessin` — `د. أحمد الشربيني` / `Dr. Ahmed El-Sherbiny` — `أمراض أسماك الزينة` / `Ornamental fish care`
  2. `المعادي` / `Maadi` — `د. سلمى عبد الرحمن` / `Dr. Salma Abdelrahman` — `رعاية السلاحف المائية` / `Aquatic turtle specialist`
  3. `مدينة نصر` / `Nasr City` — `د. كريم منصور` / `Dr. Karim Mansour` — `تغذية وعلاج الأسماك` / `Fish nutrition & treatment`
- **Buttons per card:** `اتصال` / `Call`, `واتساب` / `WhatsApp`, `الصفحة` / `Social`, `الموقع` / `Maps`
- **Images & Icons:** `/social/whatsapp.png`, Lucide `MapPin`, `Stethoscope`, `Phone`, `Share2`.

---

## 8. Contact & Location (`#contact` — `components/sections/ContactSection.tsx`)
- **Purpose:** Direct shop contact, location, social channels, and visual 7-day hours strip.
- **Word Count:** `14` words (AR) / `16` words (EN) (plus 7 day/hour cells)
- **Heading & Address:** `زُرنا وتواصل` / `Visit & Contact` — `شارع التحرير، الدقي، الجيزة` / `El Tahrir St., Dokki, Giza`
- **Buttons:** `واتساب المتجر` / `Shop WhatsApp`, `اتصل بنا` / `Call Shop`, `خريطة جوجل` / `Google Maps`
- **Hours Title:** `مواعيد العمل` / `Opening Hours` (`السبت`–`الخميس` `11ص-11م`, `الجمعة` `2م-11م` / `Sat`–`Thu` `11-11`, `Fri` `2-11`)
- **Images & Icons:** `/social/whatsapp.png`, `/social/facebook.png`, `/social/instagram.png`, `/social/tik-tok.png`, Lucide `MapPin`, `Phone`, `Clock`.

---

## 9. Footer & Mobile Action Bar (`Footer.tsx`, `MobileActionBar.tsx`)
- **Footer:** `/logo.png`, 5 nav links, `EN / عربي` toggle, `مصطفى عمار للأكواريوم © 2026` / `Mostafa Ammar Aquatics © 2026`.
- **Mobile Sticky Bar (`< 768px`):** `واتساب` / `WhatsApp` (`/social/whatsapp.png`) + `اتصال` / `Call` (Lucide `Phone`).
- **Desktop Floating Button (`>= 768px`):** `واتساب` / `WhatsApp` (`/social/whatsapp.png`) at `bottom-6 end-6`.
