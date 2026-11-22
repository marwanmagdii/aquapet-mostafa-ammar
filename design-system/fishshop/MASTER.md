# Design System Master File

> **LOGIC:** When building a specific page, first check `design-system/pages/[page-name].md`.
> If that file exists, its rules **override** this Master file.
> If not, strictly follow the rules below.

---

**Project:** fishshop
**Generated:** 2026-11-22 02:58:27
**Category:** E-commerce
**Token files:** `tokens.json` (W3C Design Tokens Community Group JSON).
**CSS variables:** `tokens.css` (`:root` custom properties).
Token files are master-level only; `--page` overrides do not emit tokens.

---

## Global Rules

### Color Palette (Sampled from `public/frames/frame_240.webp`)

| Role | Hex | CSS Variable |
|------|-----|--------------|
| Horizon Royal Blue (Primary) | `#2A6CA5` | `--color-primary` |
| Deep Water Blue | `#378FC8` | `--color-water-deep` |
| Center Water Cyan | `#45ACD4` | `--color-water-mid` |
| Bright Mid-Water Cyan | `#5ECAE2` | `--color-secondary` |
| Sunlit Top Cyan | `#BFE9DA` | `--color-sunlit-cyan` |
| Sea Plant Green | `#66A470` | `--color-plant-green` |
| Open Sandy Yellow | `#E8C580` | `--color-sand` |
| Sunny Yellow CTA | `#FACC15` | `--color-accent` |
| Deep Navy (Text & Small Accents Only) | `#071A2F` | `--color-foreground` |
| Hero Glass Surface | `rgba(27, 81, 131, 0.78)` | `--surface-hero-glass` |
| Hero Glass Border | `rgba(191, 233, 218, 0.40)` | `--border-hero-glass` |
| Page Background | `#F0F9FF` | `--color-background` |
| Card Surface | `#FFFFFF` | `--color-card` |
| Muted Surface | `#E0F2FE` | `--color-muted` |
| Muted Foreground | `#334155` | `--color-muted-foreground` |
| Border | `#BAE6FD` | `--color-border` |

**Color Notes:** Scene-matched bright ocean palette sampled directly from `public/frames/frame_240.webp` (`#BFE9DA`, `#5ECAE2`, `#45ACD4`, `#378FC8`, `#2A6CA5`, `#E8C580`, `#66A470`). Deep Navy `#071A2F` is reserved strictly for body/heading text, CTA text on Sunny Yellow `#FACC15`, and small dark accents — never as a dark hero background. Text over the bright ocean video sits on royal-blue ocean glass (`rgba(27, 81, 131, 0.78)`) or soft royal-blue scrims to guarantee >= 4.5:1 WCAG AA contrast. Zero purple/pink gradients, zero neon, zero heavy shadows.

### Typography

- **Arabic Font (RTL Primary):** Cairo (weights 400, 500, 600, 700, 800) via `next/font/google`
- **Latin Font (LTR Partner):** Plus Jakarta Sans (weights 400, 500, 600, 700, 800) via `next/font/google`
- **Mood:** deep ocean, fresh, premium, trustworthy, playfully aquatic
- **RTL Support:** `rtl_level: full` — Arabic (`dir="rtl"`, `lang="ar"`) default, English (`dir="ltr"`, `lang="en"`) switchable.

### Spacing Variables

| Token | Value | Usage |
|-------|-------|-------|
| `--space-xs` | `4px` / `0.25rem` | Tight gaps |
| `--space-sm` | `8px` / `0.5rem` | Icon gaps, inline spacing |
| `--space-md` | `16px` / `1rem` | Standard padding |
| `--space-lg` | `24px` / `1.5rem` | Section padding |
| `--space-xl` | `32px` / `2rem` | Large gaps |
| `--space-2xl` | `48px` / `3rem` | Section margins |
| `--space-3xl` | `64px` / `4rem` | Hero padding |

### Shadow Depths

| Level | Value | Usage |
|-------|-------|-------|
| `--shadow-sm` | `0 1px 2px rgba(0,0,0,0.05)` | Subtle lift |
| `--shadow-md` | `0 4px 6px rgba(0,0,0,0.1)` | Cards, buttons |
| `--shadow-lg` | `0 10px 15px rgba(0,0,0,0.1)` | Modals, dropdowns |
| `--shadow-xl` | `0 20px 25px rgba(0,0,0,0.15)` | Hero images, featured cards |

---

## Component Specs

### Buttons

```css
/* Primary Button */
.btn-primary {
  background: #EA580C;
  color: #000000;
  padding: 12px 24px;
  border-radius: 8px;
  font-weight: 600;
  transition: all 200ms ease;
  cursor: pointer;
}

.btn-primary:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}

/* Secondary Button */
.btn-secondary {
  background: transparent;
  color: #064E3B;
  border: 2px solid #059669;
  padding: 12px 24px;
  border-radius: 8px;
  font-weight: 600;
  transition: all 200ms ease;
  cursor: pointer;
}
```

### Cards

```css
.card {
  background: #ECFDF5;
  border-radius: 12px;
  padding: 24px;
  box-shadow: var(--shadow-md);
  transition: all 200ms ease;
  cursor: pointer;
}

.card:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-2px);
}
```

### Inputs

```css
.input {
  padding: 12px 16px;
  border: 1px solid #E2E8F0;
  border-radius: 8px;
  font-size: 16px;
  transition: border-color 200ms ease;
}

.input:focus {
  border-color: #059669;
  outline: none;
  box-shadow: 0 0 0 3px #05966920;
}
```

### Modals

```css
.modal-overlay {
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
}

.modal {
  background: white;
  border-radius: 16px;
  padding: 32px;
  box-shadow: var(--shadow-xl);
  max-width: 500px;
  width: 90%;
}
```

---

## Style Guidelines

**Style:** Vibrant & Block-based

**Keywords:** Bold, energetic, playful, block layout, geometric shapes, high color contrast, duotone, modern, energetic

**Best For:** Startups, creative agencies, gaming, social media, youth-focused, entertainment, consumer

**Key Effects:** Large sections (48px+ gaps), animated patterns, bold hover (color shift), scroll-snap, large type (32px+), 200-300ms

### Page Pattern

**Pattern Name:** Feature-Rich Showcase

- **Conversion Strategy:** Clear feature hierarchy. One key message per card. Strong CTA repetition.
- **CTA Placement:** Hero (sticky) + After features + Bottom
- **Section Order:** Hero (value prop) > Feature grid/cards (4-6) > Use cases or benefits > Social proof or logos > CTA

---

## Anti-Patterns (Do NOT Use)

- ❌ Flat design without depth
- ❌ Text-heavy pages

### Additional Forbidden Patterns

- ❌ **Emojis as icons** — Use SVG icons (Heroicons, Lucide, Simple Icons)
- ❌ **Missing cursor:pointer** — All clickable elements must have cursor:pointer
- ❌ **Layout-shifting hovers** — Avoid scale transforms that shift layout
- ❌ **Low contrast text** — Maintain 4.5:1 minimum contrast ratio
- ❌ **Instant state changes** — Always use transitions (150-300ms)
- ❌ **Invisible focus states** — Focus states must be visible for a11y

---

## Pre-Delivery Checklist

Before delivering any UI code, verify:

- [ ] No emojis used as icons (use SVG instead)
- [ ] All icons from consistent icon set (Heroicons/Lucide)
- [ ] `cursor-pointer` on all clickable elements
- [ ] Hover states with smooth transitions (150-300ms)
- [ ] Light mode: text contrast 4.5:1 minimum
- [ ] Focus states visible for keyboard navigation
- [ ] `prefers-reduced-motion` respected
- [ ] Responsive: 375px, 768px, 1024px, 1440px
- [ ] No content hidden behind fixed navbars
- [ ] No horizontal scroll on mobile
