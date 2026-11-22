import sharp from "sharp";

const svgs = {
  "product-tank-60.webp": `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
    <defs>
      <linearGradient id="bg" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#071a2f"/><stop offset="100%" stop-color="#133c63"/></linearGradient>
      <linearGradient id="water" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#5ecae2" stop-opacity="0.88"/><stop offset="100%" stop-color="#1b5183" stop-opacity="0.96"/></linearGradient>
      <linearGradient id="sand" x1="0" y1="0" x2="1" y2="0"><stop offset="0%" stop-color="#d4b26f"/><stop offset="50%" stop-color="#e8c580"/><stop offset="100%" stop-color="#c5a059"/></linearGradient>
    </defs>
    <rect width="800" height="600" fill="url(#bg)"/>
    <ellipse cx="400" cy="110" rx="280" ry="60" fill="#5ecae2" opacity="0.22"/>
    <rect x="170" y="88" width="460" height="18" rx="9" fill="#071a2f" stroke="#5ecae2" stroke-width="2"/>
    <rect x="210" y="104" width="380" height="6" rx="3" fill="#fef08a"/>
    <line x1="200" y1="106" x2="200" y2="155" stroke="#94a3b8" stroke-width="5"/>
    <line x1="600" y1="106" x2="600" y2="155" stroke="#94a3b8" stroke-width="5"/>
    <rect x="150" y="155" width="500" height="310" rx="6" fill="#ffffff" fill-opacity="0.06" stroke="#bfe9da" stroke-width="4"/>
    <rect x="156" y="185" width="488" height="274" fill="url(#water)"/>
    <path d="M156 185 Q280 177 400 185 T644 185" fill="none" stroke="#e0f7fa" stroke-width="3"/>
    <path d="M220 440 Q200 350 235 280 Q245 350 240 440 Z" fill="#66a470"/>
    <path d="M245 440 Q235 370 265 310 Q270 375 260 440 Z" fill="#4d8b57"/>
    <path d="M560 440 Q580 340 545 265 Q535 340 540 440 Z" fill="#66a470"/>
    <path d="M530 440 Q545 360 515 300 Q510 365 518 440 Z" fill="#84cc16"/>
    <path d="M330 440 L375 355 L445 380 L470 440 Z" fill="#64748b"/>
    <ellipse cx="360" cy="270" rx="18" ry="9" fill="#facc15"/>
    <polygon points="342,270 328,260 328,280" fill="#f59e0b"/>
    <ellipse cx="455" cy="310" rx="15" ry="8" fill="#fb7185"/>
    <polygon points="470,310 482,302 482,318" fill="#f43f5e"/>
    <path d="M156 425 Q300 410 450 425 T644 422 L644 459 L156 459 Z" fill="url(#sand)"/>
    <polygon points="170,165 215,165 180,445 162,445" fill="#ffffff" opacity="0.14"/>
    <rect x="130" y="465" width="540" height="22" rx="4" fill="#071a2f" stroke="#334155" stroke-width="2"/>
  </svg>`,

  "product-nano-tank.webp": `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
    <defs>
      <linearGradient id="bg2" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stop-color="#071a2f"/><stop offset="100%" stop-color="#1b5183"/></linearGradient>
      <linearGradient id="w2" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#46b8da"/><stop offset="100%" stop-color="#0f4c81"/></linearGradient>
    </defs>
    <rect width="800" height="600" fill="url(#bg2)"/>
    <path d="M480 180 L480 110 Q480 90 455 90 L355 90" fill="none" stroke="#cbd5e1" stroke-width="10" stroke-linecap="round"/>
    <rect x="310" y="80" width="95" height="20" rx="10" fill="#071a2f" stroke="#5ecae2" stroke-width="2"/>
    <ellipse cx="358" cy="104" rx="36" ry="6" fill="#fef08a"/>
    <rect x="250" y="165" width="300" height="310" rx="26" fill="#ffffff" fill-opacity="0.08" stroke="#bfe9da" stroke-width="4"/>
    <rect x="258" y="198" width="284" height="268" rx="18" fill="url(#w2)"/>
    <circle cx="400" cy="355" r="55" fill="#4d8b57"/>
    <circle cx="370" cy="385" r="42" fill="#66a470"/>
    <circle cx="435" cy="385" r="40" fill="#84cc16"/>
    <rect x="258" y="432" width="284" height="34" rx="10" fill="#e8c580"/>
    <polygon points="272,180 305,180 282,445 265,445" fill="#ffffff" opacity="0.16"/>
  </svg>`,

  "product-filter.webp": `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
    <defs>
      <linearGradient id="bg3" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#071a2f"/><stop offset="100%" stop-color="#1d4e7a"/></linearGradient>
    </defs>
    <rect width="800" height="600" fill="url(#bg3)"/>
    <rect x="275" y="130" width="250" height="290" rx="28" fill="#1e293b" stroke="#5ecae2" stroke-width="3"/>
    <rect x="295" y="110" width="210" height="32" rx="12" fill="#0f172a" stroke="#94a3b8" stroke-width="2"/>
    <rect x="305" y="175" width="190" height="55" rx="10" fill="#334155" stroke="#64748b" stroke-width="2"/>
    <text x="400" y="210" text-anchor="middle" fill="#bfe9da" font-family="sans-serif" font-size="18" font-weight="bold">BIO-SPONGE</text>
    <rect x="305" y="245" width="190" height="55" rx="10" fill="#0f4c81" stroke="#5ecae2" stroke-width="2"/>
    <text x="400" y="280" text-anchor="middle" fill="#ffffff" font-family="sans-serif" font-size="18" font-weight="bold">CARBON + CERAMIC</text>
    <rect x="305" y="315" width="190" height="55" rx="10" fill="#15803d" stroke="#86efac" stroke-width="2"/>
    <text x="400" y="350" text-anchor="middle" fill="#ffffff" font-family="sans-serif" font-size="18" font-weight="bold">SILENT MOTOR</text>
    <rect x="220" y="155" width="55" height="22" rx="10" fill="#38bdf8"/>
    <rect x="220" y="155" width="22" height="330" rx="10" fill="#38bdf8" fill-opacity="0.65" stroke="#bae6fd" stroke-width="2"/>
    <path d="M280 155 Q235 190 245 270" fill="none" stroke="#e0f7fa" stroke-width="8" stroke-linecap="round" opacity="0.8"/>
    <circle cx="255" cy="310" r="8" fill="#e0f7fa" opacity="0.8"/>
    <circle cx="275" cy="345" r="5" fill="#e0f7fa" opacity="0.7"/>
  </svg>`,

  "product-flakes.webp": `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
    <defs>
      <linearGradient id="bg4" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stop-color="#123456"/><stop offset="100%" stop-color="#071a2f"/></linearGradient>
      <linearGradient id="can" x1="0" y1="0" x2="1" y2="0"><stop offset="0%" stop-color="#1b5183"/><stop offset="50%" stop-color="#2a6ca5"/><stop offset="100%" stop-color="#133b61"/></linearGradient>
    </defs>
    <rect width="800" height="600" fill="url(#bg4)"/>
    <circle cx="400" cy="300" r="210" fill="#facc15" opacity="0.1"/>
    <rect x="285" y="105" width="230" height="52" rx="14" fill="#facc15" stroke="#eab308" stroke-width="3"/>
    <rect x="270" y="152" width="260" height="335" rx="26" fill="url(#can)" stroke="#bfe9da" stroke-width="3"/>
    <rect x="275" y="205" width="250" height="195" fill="#071a2f" fill-opacity="0.82"/>
    <rect x="310" y="225" width="180" height="30" rx="15" fill="#facc15"/>
    <text x="400" y="246" text-anchor="middle" fill="#071a2f" font-family="sans-serif" font-size="16" font-weight="bold">MOSTAFA AMMAR</text>
    <text x="400" y="298" text-anchor="middle" fill="#ffffff" font-family="sans-serif" font-size="28" font-weight="bold">COLOR FLAKES</text>
    <text x="400" y="332" text-anchor="middle" fill="#5ecae2" font-family="sans-serif" font-size="18" font-weight="bold">VITAMIN + OMEGA 3</text>
    <circle cx="355" cy="368" r="10" fill="#fb7185"/>
    <circle cx="385" cy="365" r="11" fill="#facc15"/>
    <circle cx="418" cy="369" r="9" fill="#4ade80"/>
    <circle cx="446" cy="364" r="10" fill="#38bdf8"/>
  </svg>`,

  "product-conditioner.webp": `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
    <defs>
      <linearGradient id="bg5" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#071a2f"/><stop offset="100%" stop-color="#1b5183"/></linearGradient>
    </defs>
    <rect width="800" height="600" fill="url(#bg5)"/>
    <rect x="362" y="88" width="76" height="55" rx="10" fill="#5ecae2" stroke="#ffffff" stroke-width="2"/>
    <rect x="352" y="138" width="96" height="24" rx="6" fill="#071a2f"/>
    <path d="M325 185 Q325 160 352 160 L448 160 Q475 160 475 185 L495 230 L495 475 Q495 500 470 500 L330 500 Q305 500 305 475 L305 230 Z" fill="#ffffff" stroke="#bae6fd" stroke-width="4"/>
    <rect x="315" y="245" width="170" height="210" rx="14" fill="#0f4c81"/>
    <path d="M400 270 Q428 308 428 328 A28 28 0 1 1 372 328 Q372 308 400 270 Z" fill="#5ecae2"/>
    <text x="400" y="388" text-anchor="middle" fill="#ffffff" font-family="sans-serif" font-size="21" font-weight="bold">AQUA SAFE</text>
    <text x="400" y="416" text-anchor="middle" fill="#facc15" font-family="sans-serif" font-size="15" font-weight="bold">DECHLORINATOR</text>
    <text x="400" y="440" text-anchor="middle" fill="#bfe9da" font-family="sans-serif" font-size="13" font-weight="bold">250 ML</text>
  </svg>`,

  "product-driftwood.webp": `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600">
    <defs>
      <linearGradient id="bg6" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stop-color="#071a2f"/><stop offset="100%" stop-color="#19517d"/></linearGradient>
    </defs>
    <rect width="800" height="600" fill="url(#bg6)"/>
    <ellipse cx="400" cy="460" rx="260" ry="36" fill="#e8c580" opacity="0.85"/>
    <path d="M180 445 Q280 410 350 330 L430 210 L465 225 L395 340 Q470 320 565 255 L585 280 Q485 365 415 390 L615 435 L600 465 Q410 445 310 450 Z" fill="#8b5a2b" stroke="#5c3a1b" stroke-width="5" stroke-linejoin="round"/>
    <ellipse cx="355" cy="310" rx="42" ry="24" transform="rotate(-28 355 310)" fill="#66a470" stroke="#166534" stroke-width="3"/>
    <ellipse cx="405" cy="295" rx="46" ry="26" transform="rotate(15 405 295)" fill="#84cc16" stroke="#15803d" stroke-width="3"/>
    <ellipse cx="320" cy="355" rx="38" ry="22" transform="rotate(-12 320 355)" fill="#4ade80" stroke="#166534" stroke-width="3"/>
    <ellipse cx="465" cy="335" rx="44" ry="24" transform="rotate(22 465 335)" fill="#66a470" stroke="#166534" stroke-width="3"/>
  </svg>`
};

for (const [name, svg] of Object.entries(svgs)) {
  await sharp(Buffer.from(svg)).webp({ quality: 92 }).toFile(`public/images/${name}`);
  console.log("Generated", name);
}
