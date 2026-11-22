# 08 — Content Editing Guide

All editable content lives in `lib/`, `public/`, and `design-system/`. No database or CMS is required.

## 1. Where to Edit Everything

| What You Want to Change | Exact File to Edit | Notes |
| --- | --- | --- |
| **All Arabic & English Copy** (headlines, section titles, buttons, labels) | `lib/i18n.ts` | Edit `dictionaries.ar` and `dictionaries.en` in parallel. |
| **Products, Prices (EGP) & Categories** | `lib/products.ts` | Edit `categories` (6 items) or `products` (12 items). Set `featured: true` for the initial 8; `bestSeller: true` for the highlighted card. |
| **Trusted Vets** | `lib/vets.ts` | Edit `trustedVets` (`areaAr/En`, `nameAr/En`, `specialtyAr/En`, `phoneHref`, `whatsappNumber`, `socialUrl`, `mapsUrl`). |
| **Shop Address, Phone, WhatsApp, Hours, Social Links** | `lib/contact.ts` | Edit `contactInfo` and `weekDays`. All WhatsApp links use `contactInfo.whatsappNumber`. |
| **Shop Logo** | `logo.png` (root) -> run `npm run frames` | Copies to `public/logo.png` and generates `public/logo.webp`. |
| **Product / Category Images** | `public/images/*.webp` | Referenced by `image` paths in `lib/products.ts`. |
| **Colors & Design Tokens** | `design-system/fishshop/tokens.css` & `app/globals.css` | Also check hardcoded Tailwind hexes (`#FACC15`, `#2A6CA5`, `#15803D`) in `components/`. |
| **Fonts** | `app/layout.tsx` & `components/LanguageProvider.tsx` | Loaded via `next/font/google` (`Cairo` for `ar`, `Plus_Jakarta_Sans` for `en`). |
| **Hero Video Frames** | `frames/*.jpg` -> run `npm run frames` | Never edit `frames/` directly unless replacing source frames; `npm run frames` regenerates `public/frames/` and `public/frames-mobile/`. |
| **SEO / Domain (`metadataBase`)** | `app/layout.tsx` | Update `metadataBase: new URL("https://your-domain.com")` and `metadata` title/description. |

## 2. How to Rebuild & Deploy After Any Edit

1. **Test locally:**
   ```bash
   npm run dev
   ```
   Open `http://localhost:3000` and check both Arabic (`عربي`) and English (`EN`).
2. **Lint and build static export:**
   ```bash
   npm run lint
   npm run build
   ```
   This outputs the complete static website to `out/`.
3. **Deploy:**
   - **Vercel:** Push changes to Git; Vercel runs `npm run build` and serves `out/`.
   - **Netlify:** Push changes to Git (or drag-and-drop the `out/` folder in Netlify Drop).
