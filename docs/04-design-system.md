# 04 — Design System (Code vs. `MASTER.md`)

## 1. Colors Actually Used in Code (`design-system/fishshop/tokens.css` & components)

| Token / Role | Actual Hex / RGBA in Code | Where Used |
| --- | --- | --- |
| Horizon Royal Blue (`--ocean-royal-blue`) | `#2A6CA5` | Footer bg, active nav pill, prices, flow icons, Loyalty card gradient |
| Deep Water Blue (`--ocean-deep-blue`) | `#378FC8` | Hero canvas fallback bg, App section gradient |
| Center Water Cyan (`--ocean-center-cyan`) | `#45ACD4` | Hero loader gradient, image tile tint (`#45ACD4/15`, `#45ACD4/20`) |
| Bright Mid-Water Cyan (`--ocean-mid-cyan`) | `#5ECAE2` | Hero Feature 2 accent bar, Hero eyebrow pill (`#5ECAE2/25`) |
| Sunlit Top Cyan (`--ocean-sunlit-cyan`) | `#BFE9DA` | Hero glass borders (`#BFE9DA/35..50`), logo drop-shadow |
| Royal Scrim (`--ocean-royal-scrim`) | `#1B5183` / `rgba(27,81,131,0.78)` | Hero glass panels, unscrolled header pill, mobile drawer |
| Sunny Yellow CTA (`--ocean-cta-yellow`) | `#FACC15` (hover `#EAB308`) | Primary CTAs, Best Seller card frame, Gold loyalty tier, focus ring |
| Deep Navy Ink (`--ocean-navy-ink`) | `#071A2F` | Headings, body text, CTA text on yellow, phone mockup frame |
| Slate Ink (`--ocean-slate-ink`) | `#334155` | Card details, subtitles, week strip hours |
| Page Ice Background (`--ocean-surface-ice`) | `#F0F9FF` | Body bg, scrolled header (`#F0F9FF/94`), inner tiles |
| Muted Ice (`--ocean-surface-muted`) | `#E0F2FE` | Double-bezel outer shells, icon containers, Call buttons |
| Light Border (`--ocean-border-light`) | `#BAE6FD` | Card & tile borders |
| WhatsApp Green (Hardcoded) | `#15803D` (hover `#166534`), `#25D366` (ContactSection) | WhatsApp buttons |

## 2. Typography (`app/layout.tsx`, `LanguageProvider.tsx`)
- **Arabic (`dir="rtl"`):** `Cairo` (weights `400, 500, 600, 700, 800`), CSS var `--font-cairo`.
- **English (`dir="ltr"`):** `Plus Jakarta Sans` (weights `400, 500, 600, 700, 800`), CSS var `--font-jakarta`.
- **Type Scale in Code:**
  - `h1` (Hero): `text-4xl sm:text-6xl md:text-7xl font-extrabold` (`36px` -> `60px` -> `72px`)
  - `h2` (Sections): `text-3xl sm:text-4xl font-extrabold` (`30px` -> `36px`; `48px` in App section)
  - `h3` (Cards): `text-base sm:text-lg font-extrabold` (`16px` -> `18px`)
  - Body / Buttons: `text-sm` (`14px`) to `text-base` (`16px`)

## 3. Spacing, Radius, Shadows & Motion
- **Section Padding:** `py-20 sm:py-24 px-4 sm:px-6 lg:px-8` (`80px` / `96px` vertical)
- **Card Radii:** Outer shell `rounded-[1.5rem]` to `rounded-[2.25rem]`, inner core `rounded-[calc(...-0.375rem)]`, buttons `rounded-full` or `rounded-xl`.
- **Shadows:** Soft ocean-tinted (`rgba(42,108,165,0.12)` on scrolled header, `rgba(250,204,21,0.28)` on Best Seller card, `rgba(27,81,131,0.28)` on Hero glass).
- **Icon Set:** `lucide-react` (`strokeWidth={1.75}` everywhere) + PNG brand icons in `public/social/`.
- **Motion (`SectionReveal.tsx`, `Header.tsx`):** `cubic-bezier(0.32, 0.72, 0, 1)`, `200ms–520ms`, GPU-only (`transform`, `opacity`), `@media (hover: hover)` hover gating, `prefers-reduced-motion` honored in `globals.css` and `HeroScrollScene.tsx`.

## 4. Differences Between Code & `design-system/fishshop/MASTER.md`

| Item | `MASTER.md` Spec | Actual Code |
| --- | --- | --- |
| Primary Button Color | `--color-accent` (`#EA580C` / `#FACC15`) | Uses hardcoded hex `#FACC15` and `#2A6CA5` instead of `var(--color-accent)` / `var(--color-primary)`. |
| WhatsApp Button Green | Not defined in `tokens.css` | Hardcoded `#15803D` in Hero/Products/Vets/MobileBar vs `#25D366` in `ContactSection.tsx` (inconsistent). |
| Typography Tokens | `--font-heading` / `--font-body` | `LanguageProvider.tsx` sets `document.body.style.fontFamily` directly to `var(--font-cairo)` or `var(--font-jakarta)`. |
| Icon Set | Single SVG icon set | Mixes `lucide-react` SVGs with raster PNGs (`public/social/*.png`). |
| Component Classes | `.btn-primary`, `.card` in `MASTER.md` | Tailwind utility classes inline on JSX; `MASTER.md` CSS classes are unused. |
