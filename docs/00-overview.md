# 00 — Project Overview

## Front End Only
- This website is **FRONT END ONLY**. There is no backend, no server, no database, no API routes, and no login.
- It builds as a pure static export (`output: "export"` in `next.config.ts`).
- All data (products, vets, contact details) lives in local TypeScript files (`lib/products.ts`, `lib/vets.ts`, `lib/contact.ts`), and ordering happens through WhatsApp links (`wa.me`).

## What the Site Is
- **Brand:** Mostafa Ammar Aquatics (`مصطفى عمار للأكواريوم`)
- **Purpose:** Static front-end showcase and WhatsApp-ordering website for an Egyptian aquatic pet shop selling ornamental fish, aquatic turtles, fish food, glass tanks, filters/pumps, water care products, and tank decor.
- **Audience:** Aquarium hobbyists and pet owners in Egypt (Arabic RTL default, English LTR switchable).
- **Ordering Model:** No cart, checkout, backend, or database; all orders and inquiries route to `wa.me` WhatsApp links or `tel:` phone links.

## Tech Stack & Versions (`package.json`)

| Package | Version | Role |
| --- | --- | --- |
| `next` | `^15.2.0` (installed `15.5.29`) | App Router + static export (`output: "export"`) |
| `react` / `react-dom` | `^19.0.0` | UI runtime |
| `typescript` | `^5.7.3` | Type safety |
| `tailwindcss` | `^4.0.9` | Utility styling via `@tailwindcss/postcss` |
| `gsap` | `^3.12.7` | `ScrollTrigger` for hero scroll progress |
| `lenis` | `^1.2.3` | Smooth wheel scrolling synced with GSAP ticker |
| `lucide-react` | `^0.475.0` | UI icon set (`strokeWidth={1.75}`) |
| `sharp` | `^0.33.5` (dev) | Image cropping and WebP frame pipeline |
| `eslint` / `eslint-config-next` | `^9.21.0` / `^15.2.0` | Linting |

## How to Run, Build & Deploy

| Command | Action |
| --- | --- |
| `npm install` | Install project dependencies locally |
| `npm run frames` | Convert `frames/*.jpg` into `public/frames/` and `public/frames-mobile/` |
| `npm run dev` | Start Next.js dev server on `http://localhost:3000` |
| `npm run lint` | Run ESLint (ignores legacy Flutter directories in `eslint.config.mjs`) |
| `npm run build` | Generate static HTML/CSS/JS export in `out/` |

### Deploy
- **Vercel / Netlify:** Connect repository, set build command to `npm run build`, and publish directory to `out`.

## Folder Tree

```text
D:\web\fish\
├── app/
│   ├── layout.tsx              # Root layout, Cairo + Plus Jakarta Sans fonts, metadata, LanguageProvider
│   ├── page.tsx                # Single-page composition: Header, Hero + 6 sections, Footer, MobileActionBar
│   └── globals.css             # Tailwind v4 import, tokens.css import, focus-visible & reduced-motion rules
├── components/
│   ├── LanguageProvider.tsx    # Arabic (ar/rtl) & English (en/ltr) state, localStorage persistence, <html> dir/lang sync
│   ├── Header.tsx              # Fixed pill navbar: logo, 5 nav links, active section highlight, EN/عربي toggle, Get App CTA
│   ├── HeroScrollScene.tsx     # 500vh/400vh pinned canvas hero, progressive WebP loader, choreographed text & logo reveal
│   ├── SectionReveal.tsx       # IntersectionObserver fade-up wrapper (transform + opacity)
│   ├── MobileActionBar.tsx     # Mobile sticky bottom WhatsApp + Call bar; desktop floating WhatsApp button
│   ├── Footer.tsx              # Brand logo, 5 nav links, language toggle, copyright
│   └── sections/
│       ├── CategoriesSection.tsx  # 6 category cards with cropped WebP images + Lucide icons
│       ├── ProductsSection.tsx    # 8 featured products (expandable to 12) with 1 Best Seller highlight
│       ├── WhyUsSection.tsx       # 4 trust tiles + 2-line caption + 3-step Buy/Reminded/Reorder flow
│       ├── LoyaltyAppSection.tsx  # Bronze/Silver/Gold tier bar + CSS phone mockup + Get App CTA
│       ├── VetsSection.tsx        # 3 area-grouped vet contact cards (Call, WhatsApp, Social, Maps)
│       └── ContactSection.tsx     # Shop address, WhatsApp/Call/Maps CTAs, Facebook/IG/TikTok, 7-day hours strip
├── lib/
│   ├── i18n.ts                 # Complete Arabic & English UI dictionary
│   ├── products.ts             # 6 categories & 12 products (EGP prices, images, WhatsApp message builder)
│   ├── vets.ts                 # 3 mock vet clinic records
│   └── contact.ts              # Shop phone, WhatsApp, address, social URLs, 7-day schedule
├── scripts/
│   └── prepare-frames.mjs      # sharp script generating desktop/mobile WebP frames + manifest.json + logo.webp
├── design-system/fishshop/
│   ├── MASTER.md               # Persisted design system specification
│   └── tokens.css              # 3-layer CSS custom properties (primitive -> semantic -> component)
├── public/
│   ├── frames/                 # 240 desktop WebP frames (1280x720) + manifest.json
│   ├── frames-mobile/          # 120 mobile WebP frames (800x450) + manifest.json
│   ├── images/                 # 7 cropped WebP creature/aquascape tiles from frame_240.webp
│   ├── social/                 # 6 brand PNG icons (whatsapp, facebook, instagram, tik-tok, linkedin, search)
│   ├── logo.png                # Transparent shop logo (892 KB, currently used in UI)
│   └── logo.webp               # WebP version of shop logo (126 KB, currently unused in UI)
├── frames/                     # Original 240 source JPGs (untouched)
├── next.config.ts              # output: "export", images: { unoptimized: true }
├── eslint.config.mjs           # ESLint flat config ignoring out/, .next/, scripts/, and legacy Flutter folders
└── docs/                       # Documentation and audit files
```
