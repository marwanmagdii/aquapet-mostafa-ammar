# Pre-Redesign Audit (`docs/audit-before.md`)

**Date:** 2026-11-22  
**Target:** `D:\web\fish` (before redesign)  
**Lighthouse:** Not available (Lighthouse CLI not installed locally; audited via code inspection and browser DOM/viewport checks).

---

## 1. Word Count by Section (Arabic & English)

| Section | Arabic Words | English Words | Text Budget Status |
| --- | ---: | ---: | --- |
| Hero (`#hero`) | 39 | 44 | Over (feature lines 7–9 words; target 4–6 words) |
| Products (`#products`) | 298 | 278 | Severely over (12 long product descriptions + 7 filters) |
| Why Us (`#why-us`) | 80 | 82 | Over (target < 30 words) |
| Loyalty & App (`#app`) | 74 | 77 | Over (3 bullet sentences + long subtitle) |
| Trusted Vets (`#vets`) | 75 | 77 | Over (long clinic & specialty sentences) |
| About (`#about`) | 73 | 77 | Over + Redundant (2 long paragraphs; repeats Why Us) |
| Contact (`#contact`) | 54 | 61 | Over (long address/hours sentences) |
| **Total** | **693** | **696** | **Needs ~75% reduction + visual replacement** |

---

## 2. Text-Only / Missing Image or Icon Places

| Location | Issue |
| --- | --- |
| Product cards (12 cards) | No product photos or cropped creature/item visuals — text + tiny category pill only. |
| Category tiles | Small 16px icons inside 36px boxes; not large visual icon/image tiles. |
| Why Us (`#why-us`) | 4 text-heavy cards with 12–15 word descriptions; no 3-step visual flow for reminders. |
| Loyalty & App (`#app`) | 3 text bullets instead of a visual Bronze/Silver/Gold tier progress graphic. |
| About (`#about`) | Two 30-word paragraphs + 3 text-only stat boxes without icons. |
| Contact (`#contact`) | Text-only opening hours string instead of a visual week strip. |

---

## 3. Tap Targets Smaller Than 48px

| Element | Current Size | Issue |
| --- | --- | --- |
| Header nav links (`Header.tsx`) | ~20px height | Below 48px; 6 links (exceeds Hick's 5-link limit). |
| Header language toggle | ~36px height (`py-2`) | Below 48px mobile target. |
| Header mobile menu button | `40×40px` (`w-10 h-10`) | Below 48px Fitts's Law minimum. |
| Product WhatsApp button | ~40px height (`py-2.5`) | Below 48px mobile / 56px desktop primary target. |
| Vet action buttons (Call/WA/Social/Maps) | ~38px height (`py-2.5`) | Below 48px minimum. |
| Social icon circles (`ContactSection.tsx`) | `36×36px` (`w-9 h-9`) | Below 48px minimum. |
| Footer links & language toggle | ~28px height (`py-1.5`) | Below 48px minimum. |
| Mobile thumb zone | Missing | No sticky bottom WhatsApp + Call bar on mobile. |

---

## 4. Repeated / Redundant Sections

1. **About (`#about`) vs. Why Us (`#why-us`):** Both sections explain healthy livestock inspection, pre-delivery checks, and WhatsApp care advice. Should be merged into a single concise **Why Us** section.
2. **Hero CTAs vs. Header CTA vs. Product CTAs:** Multiple competing yellow/green buttons on the same screen without a single clear Von Restorff focal action per section.
3. **7-item filter bar + 12-card product grid:** Violates Miller's Law (max 6 items per group) and Hick's Law (choice overload).

---

## 5. Pre-Redesign Scorecard Estimate: **5 / 16**

- Passes: One H1 hierarchy, buttons look clickable, text contrast over hero, Arabic RTL & English LTR, smooth hero scroll.
- Fails: Word count (<30/section), card imagery, paragraph length, <=6 main sections, no repetition, Hick (<=5 nav links, 1 yellow CTA/screen), Fitts (>=48px/56px + mobile thumb bar), Miller (<=6/group), Von Restorff, consistent visual polish.
