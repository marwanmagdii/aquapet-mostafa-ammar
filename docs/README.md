# Website Documentation Index (`docs/README.md`)

Complete read-only study, audit, and pipeline documentation for **Mostafa Ammar Aquatics** (`D:\web\fish`).

## Front End Only
- This website is **FRONT END ONLY**. There is no backend, no server, no database, no API routes, and no login.
- It builds as a pure static export (`output: "export"` in `next.config.ts`).
- All data (products, vets, contact details) lives in local files, and ordering happens through WhatsApp links (`wa.me`). Do not suggest or add any backend; all fixes and features must remain front-end-only.

## Documents
- [00-overview.md](00-overview.md) — Project summary, tech stack versions, npm scripts, deployment, and folder tree.
- [01-sitemap-and-content.md](01-sitemap-and-content.md) — Every section in order with exact Arabic/English text, word counts, images, and Lucide icons.
- [02-hero-scroll-flow.md](02-hero-scroll-flow.md) — Hero canvas mechanics, 3-batch frame loading, scroll beat timeline, reduced-motion fallback, and Mermaid diagram.
- [03-user-flow.md](03-user-flow.md) — Visitor journey Mermaid flowchart and complete inventory of buttons/links with pixel sizes.
- [04-design-system.md](04-design-system.md) — Actual colors, fonts, spacing, radii, shadows, and motion used in code vs. `MASTER.md`.
- [05-assets-and-frames.md](05-assets-and-frames.md) — Desktop/mobile WebP frame pipeline stats and full `public/` asset inventory with size flags.
- [06-audit-and-fix-list.md](06-audit-and-fix-list.md) — Laws of UX & information design audit, 16-point scorecard (`16/16`), and prioritized fix list.
- [07-flow-pipeline.md](07-flow-pipeline.md) — Reusable Google Flow (Veo 3.1) + Gemini video-to-scroll workflow, lessons learned, and prompt slots.
- [08-content-editing-guide.md](08-content-editing-guide.md) — Exact files to edit for copy, products, vets, contact info, colors, fonts, and rebuilding/deploying.
- [09-owner-todo.md](09-owner-todo.md) — Table of all `// TODO(owner): replace` mock data fields.

*Previous audit snapshots:* [audit-before.md](audit-before.md) | [audit-after.md](audit-after.md)

---

## Status After Fix Pass

1. **WhatsApp Contrast Fixed:** `ContactSection.tsx` now uses `bg-ocean-whatsapp` (`#15803D`, `>= 4.5:1` with white).
2. **Logo Switched to `/logo.webp`:** `Header.tsx`, `HeroScrollScene.tsx`, `LoyaltyAppSection.tsx`, and `Footer.tsx` load `/logo.webp` (`126.6 KB`), saving `~765 KB`; `/logo.png` remains only for `layout.tsx` metadata.
3. **Category Tile Filtering Added:** Clicking a tile in `CategoriesSection.tsx` filters `ProductsSection.tsx` via `CategoryFilterProvider` and shows `"Showing: <category>"` with a `48×48px` `(X)` clear button.
4. **Tokens Applied:** Components now use `@theme inline` ocean tokens from `tokens.css` / `globals.css` (only `HeroScrollScene.tsx` retains its scene hexes).
5. **16px Body & Nav Text:** Nav labels, card details, and vet buttons updated to `text-base` (`16px`).
6. **Text Budget Tightened:** Products defaults to 6 featured items with <= 4-word details; Why Us is `28` words.
7. **Unused Social PNGs Removed:** Deleted `public/social/linkedin.png` and `public/social/search.png`.
8. **Hero `img.decode()` Added:** `HeroScrollScene.tsx` waits for `img.decode()` with `onload` fallback.
9. **Mock Data Marked:** All placeholder values tagged `// TODO(owner): replace` and listed in [09-owner-todo.md](09-owner-todo.md).
10. **Lighthouse:** Not installed locally (`npx --no-install lighthouse` unavailable); verified via `npm run lint`, `npm run build`, and multi-viewport browser checks.
