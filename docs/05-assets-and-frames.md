# 05 — Assets & Frame Pipeline

## 1. Frame Pipeline (`scripts/prepare-frames.mjs`)
- **Command:** `npm run frames`
- **Source Folder:** `D:\web\fish\frames` (`240` JPGs: `ezgif-frame-001.jpg` .. `ezgif-frame-240.jpg`, untouched)
- **Desktop Output (`public/frames/`):**
  - `240` WebP files (`frame_001.webp` .. `frame_240.webp`)
  - Dimensions: `1280×720` (`withoutEnlargement: true`), quality `75`
  - Total Size: **14.89 MB** (`15,609,498` bytes + `manifest.json`)
- **Mobile Output (`public/frames-mobile/`):**
  - `120` WebP files (`frame_001.webp` .. `frame_120.webp`, every 2nd frame)
  - Dimensions: `800×450`, quality `70`
  - Total Size: **4.40 MB** (`4,611,928` bytes + `manifest.json`)

## 2. Complete `public/` Asset Inventory

| Asset Path | Size | Where Used | Status / Flag |
| --- | ---: | --- | --- |
| `public/frames/` (240 + manifest) | 14.89 MB | `HeroScrollScene.tsx` (desktop `>= 768px`) | OK (under 25 MB) |
| `public/frames-mobile/` (120 + manifest) | 4.40 MB | `HeroScrollScene.tsx` (mobile `< 768px`) | OK |
| `public/logo.png` | **913,594 B (892 KB)** | `layout.tsx`, `Header.tsx`, `HeroScrollScene.tsx`, `LoyaltyAppSection.tsx`, `Footer.tsx` | **FLAG: Oversized** (use `logo.webp` instead) |
| `public/logo.webp` | 129,654 B (126.6 KB) | **Unused in UI components** | **FLAG: Unused** (85% smaller than `logo.png`) |
| `public/images/turtle.webp` | 10,014 B | `products.ts` (`prod-2`, `prod-5`) | OK |
| `public/images/betta.webp` | 11,174 B | `CategoriesSection`, `products.ts` (`prod-1`, `prod-11`) | OK |
| `public/images/angelfish.webp` | 11,180 B | `CategoriesSection`, `products.ts` (`prod-3`, `prod-10`) | OK |
| `public/images/goldfish.webp` | 14,314 B | `CategoriesSection`, `products.ts` (`prod-4`) | OK |
| `public/images/gourami.webp` | 14,772 B | `CategoriesSection`, `products.ts` (`prod-7`, `prod-8`) | OK |
| `public/images/swordtail.webp` | 15,660 B | `CategoriesSection`, `products.ts` (`prod-9`) | OK |
| `public/images/aquascape.webp` | 22,484 B | `CategoriesSection`, `products.ts` (`prod-6`, `prod-12`) | OK |
| `public/social/whatsapp.png` | 28,478 B | `HeroScrollScene`, `ProductsSection`, `VetsSection`, `ContactSection`, `MobileActionBar` | OK |
| `public/social/facebook.png` | 16,039 B | `ContactSection.tsx` | OK |
| `public/social/instagram.png` | 42,247 B | `ContactSection.tsx` | OK |
| `public/social/tik-tok.png` | 25,374 B | `ContactSection.tsx` | OK |
| `public/social/linkedin.png` | 18,212 B | **Unused** (removed per user request) | **FLAG: Unused file** |
| `public/social/search.png` | 20,103 B | **Unused** (replaced by `MapPin` icon) | **FLAG: Unused file** |
| **Total `public/`** | **20.52 MB (21,515,288 B)** | 377 files | — |
