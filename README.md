# Mostafa Ammar Aquatics — مصطفى عمار للأكواريوم

A static-exported Next.js scroll-animation website for an aquatic pet shop featuring an Apple-style frame-by-frame underwater hero, Arabic (RTL default) and English (LTR) support, WhatsApp ordering, and a CSS mobile loyalty app preview.

## Running Locally

```bash
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Building for Static Export

```bash
npm run lint
npm run build
```

This generates the static site in `out/`.

## Regenerating Video Frames

Source frames live in `frames/` (untouched). To regenerate the optimized desktop (`public/frames/`) and mobile (`public/frames-mobile/`) WebP sequences and `logo.webp`:

```bash
npm run frames
```

## Editing Content

- **Translations & Hero Copy:** Edit `lib/i18n.ts` (`ar` and `en` dictionaries).
- **Products & Categories:** Edit `lib/products.ts` (prices in EGP, category IDs, Arabic/English names).
- **Trusted Vets:** Edit `lib/vets.ts` (names, specialties, phone, WhatsApp, social, and Maps links).
- **Shop Contact Details:** Edit `lib/contact.ts` (address, opening hours, phone, WhatsApp number, social links).

## Deploying for Free

### Vercel
1. Push the repository to GitHub/GitLab/Bitbucket.
2. Import the project in Vercel; Next.js (`output: 'export'`) is detected automatically.
3. Build command: `npm run build` — Output directory: `out`.

### Netlify
1. Connect your repository in Netlify.
2. Build command: `npm run build`
3. Publish directory: `out`
