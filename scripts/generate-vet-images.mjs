import sharp from "sharp";

const vetSvgs = {
  "vet-clinic-1.webp": `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="500" viewBox="0 0 800 500">
    <defs>
      <linearGradient id="v1bg" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stop-color="#071a2f"/><stop offset="55%" stop-color="#123e6b"/><stop offset="100%" stop-color="#2a6ca5"/></linearGradient>
      <linearGradient id="v1glow" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#5ecae2" stop-opacity="0.45"/><stop offset="100%" stop-color="#1b5183" stop-opacity="0.1"/></linearGradient>
    </defs>
    <rect width="800" height="500" fill="url(#v1bg)"/>
    <circle cx="620" cy="120" r="180" fill="#5ecae2" opacity="0.14"/>
    <!-- Diagnostic Aquarium Wall -->
    <rect x="70" y="80" width="380" height="250" rx="18" fill="url(#v1glow)" stroke="#bfe9da" stroke-width="3"/>
    <path d="M75 130 Q180 120 260 130 T445 128" fill="none" stroke="#e0f7fa" stroke-width="2.5"/>
    <!-- Healthy Betta & Angelfish silhouettes in observation tank -->
    <ellipse cx="210" cy="215" rx="34" ry="18" fill="#facc15"/>
    <path d="M176 215 L140 190 L148 215 L140 240 Z" fill="#f59e0b"/>
    <ellipse cx="330" cy="240" rx="24" ry="22" fill="#e0f2fe"/>
    <polygon points="330,198 312,240 330,282" fill="#38bdf8"/>
    <!-- Water Quality Digital Monitor -->
    <rect x="490" y="95" width="240" height="235" rx="22" fill="#071a2f" fill-opacity="0.88" stroke="#5ecae2" stroke-width="2.5"/>
    <rect x="515" y="122" width="110" height="26" rx="13" fill="#15803d"/>
    <text x="570" y="140" text-anchor="middle" fill="#ffffff" font-family="sans-serif" font-size="13" font-weight="bold">LAB VERIFIED</text>
    <text x="518" y="185" fill="#bfe9da" font-family="sans-serif" font-size="15" font-weight="bold">pH BALANCE</text>
    <text x="702" y="185" text-anchor="end" fill="#facc15" font-family="sans-serif" font-size="22" font-weight="bold">7.2</text>
    <rect x="518" y="198" width="184" height="8" rx="4" fill="#1e293b"/>
    <rect x="518" y="198" width="142" height="8" rx="4" fill="#5ecae2"/>
    <text x="518" y="242" fill="#bfe9da" font-family="sans-serif" font-size="15" font-weight="bold">OXYGEN (DO)</text>
    <text x="702" y="242" text-anchor="end" fill="#4ade80" font-family="sans-serif" font-size="22" font-weight="bold">99%</text>
    <rect x="518" y="255" width="184" height="8" rx="4" fill="#1e293b"/>
    <rect x="518" y="255" width="175" height="8" rx="4" fill="#4ade80"/>
    <text x="518" y="302" fill="#94a3b8" font-family="sans-serif" font-size="13" font-weight="bold">NILE AQUA VET LAB • MOHANDESSIN</text>
    <!-- Lab Counter -->
    <rect x="50" y="365" width="700" height="16" rx="8" fill="#bfe9da" opacity="0.35"/>
  </svg>`,

  "vet-clinic-2.webp": `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="500" viewBox="0 0 800 500">
    <defs>
      <linearGradient id="v2bg" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stop-color="#092338"/><stop offset="60%" stop-color="#164e63"/><stop offset="100%" stop-color="#15803d"/></linearGradient>
    </defs>
    <rect width="800" height="500" fill="url(#v2bg)"/>
    <circle cx="230" cy="140" r="150" fill="#facc15" opacity="0.16"/>
    <!-- UVB Basking Lamp Dome -->
    <path d="M180 60 L280 60 L310 120 L150 120 Z" fill="#071a2f" stroke="#facc15" stroke-width="3"/>
    <ellipse cx="230" cy="122" rx="65" ry="10" fill="#fef08a"/>
    <polygon points="165,125 295,125 360,360 100,360" fill="#fef08a" opacity="0.12"/>
    <!-- Turtle Basking Terrarium -->
    <rect x="90" y="155" width="620" height="240" rx="22" fill="#ffffff" fill-opacity="0.08" stroke="#bfe9da" stroke-width="3"/>
    <path d="M95 315 Q260 285 410 325 T705 315 L705 390 L95 390 Z" fill="#38bdf8" fill-opacity="0.45"/>
    <!-- Basking Dock & Healthy Green Turtle -->
    <path d="M150 320 Q235 255 330 315 Z" fill="#d4b26f" stroke="#a17c38" stroke-width="3"/>
    <ellipse cx="240" cy="268" rx="52" ry="34" fill="#4d8b57" stroke="#071a2f" stroke-width="4"/>
    <path d="M205 268 Q240 242 275 268" fill="none" stroke="#84cc16" stroke-width="3"/>
    <circle cx="302" cy="256" r="15" fill="#66a470" stroke="#071a2f" stroke-width="3"/>
    <circle cx="307" cy="253" r="3.5" fill="#071a2f"/>
    <!-- Diagnostic Shell Health Card -->
    <rect x="445" y="185" width="235" height="175" rx="18" fill="#071a2f" fill-opacity="0.88" stroke="#86efac" stroke-width="2.5"/>
    <text x="470" y="222" fill="#4ade80" font-family="sans-serif" font-size="14" font-weight="bold">TURTLE CARE UNIT • MAADI</text>
    <text x="470" y="258" fill="#ffffff" font-family="sans-serif" font-size="21" font-weight="bold">UVB + Calcium D3</text>
    <text x="470" y="288" fill="#bfe9da" font-family="sans-serif" font-size="15">Shell density &amp; amphibious</text>
    <text x="470" y="312" fill="#bfe9da" font-family="sans-serif" font-size="15">nutrition diagnostics</text>
  </svg>`,

  "vet-clinic-3.webp": `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="500" viewBox="0 0 800 500">
    <defs>
      <linearGradient id="v3bg" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stop-color="#071a2f"/><stop offset="50%" stop-color="#1b5183"/><stop offset="100%" stop-color="#0f4c81"/></linearGradient>
    </defs>
    <rect width="800" height="500" fill="url(#v3bg)"/>
    <circle cx="400" cy="250" r="210" fill="#5ecae2" opacity="0.1"/>
    <!-- Pathology & Nutrition Cards -->
    <rect x="85" y="100" width="630" height="300" rx="26" fill="#071a2f" fill-opacity="0.78" stroke="#5ecae2" stroke-width="3"/>
    <circle cx="225" cy="250" r="88" fill="#1b5183" stroke="#facc15" stroke-width="4"/>
    <circle cx="225" cy="250" r="58" fill="#2a6ca5" stroke="#bfe9da" stroke-width="2" stroke-dasharray="8 6"/>
    <!-- Cross / Medical Emblem -->
    <rect x="213" y="212" width="24" height="76" rx="6" fill="#facc15"/>
    <rect x="187" y="238" width="76" height="24" rx="6" fill="#facc15"/>
    <!-- Right Text Specs -->
    <rect x="355" y="145" width="165" height="28" rx="14" fill="#5ecae2" fill-opacity="0.2"/>
    <text x="437" y="164" text-anchor="middle" fill="#5ecae2" font-family="sans-serif" font-size="13" font-weight="bold">BLUE REEF CLINIC • NASR CITY</text>
    <text x="355" y="215" fill="#ffffff" font-family="sans-serif" font-size="28" font-weight="bold">Aquatic Pathology</text>
    <text x="355" y="250" fill="#bfe9da" font-family="sans-serif" font-size="18">&amp; Quarantine Care</text>
    <rect x="355" y="285" width="145" height="44" rx="12" fill="#15803d"/>
    <text x="427" y="313" text-anchor="middle" fill="#ffffff" font-family="sans-serif" font-size="15" font-weight="bold">PARASITE FREE</text>
    <rect x="515" y="285" width="150" height="44" rx="12" fill="#1e293b" stroke="#5ecae2" stroke-width="2"/>
    <text x="590" y="313" text-anchor="middle" fill="#facc15" font-family="sans-serif" font-size="15" font-weight="bold">IMMUNITY BOOST</text>
  </svg>`
};

for (const [name, svg] of Object.entries(vetSvgs)) {
  await sharp(Buffer.from(svg)).webp({ quality: 92 }).toFile(`public/images/${name}`);
  console.log("Generated", name);
}
