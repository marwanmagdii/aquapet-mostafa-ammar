"use client";

import React, { useEffect, useRef, useState } from "react";
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import Lenis from "lenis";
import { ChevronDown, HeartPulse, ShoppingBag, Smartphone, Sparkles, Truck } from "lucide-react";
import { buildWhatsappUrl } from "@/lib/contact";
import { useLanguage } from "./LanguageProvider";

gsap.registerPlugin(ScrollTrigger);

const DESKTOP_COUNT = 192;
const MOBILE_COUNT = 96;
const INITIAL_BATCH = 8;

function clamp01(v: number): number {
  return Math.max(0, Math.min(1, v));
}

function bandOpacity(p: number, fadeInStart: number, fullStart: number, fullEnd: number, fadeOutEnd: number): number {
  if (p <= fadeInStart || p >= fadeOutEnd) return 0;
  if (p < fullStart) return (p - fadeInStart) / (fullStart - fadeInStart);
  if (p <= fullEnd) return 1;
  return 1 - (p - fullEnd) / (fadeOutEnd - fullEnd);
}

export function HeroScrollScene() {
  const { locale, dir, t } = useLanguage();
  const containerRef = useRef<HTMLDivElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);

  // Direct DOM refs so scroll updates 0 React state and never triggers re-renders
  const introRef = useRef<HTMLDivElement>(null);
  const feat1Ref = useRef<HTMLDivElement>(null);
  const feat2Ref = useRef<HTMLDivElement>(null);
  const feat3Ref = useRef<HTMLDivElement>(null);
  const finaleRef = useRef<HTMLDivElement>(null);
  const hintRef = useRef<HTMLDivElement>(null);
  const barRef = useRef<HTMLDivElement>(null);

  const [isMobile, setIsMobile] = useState<boolean>(false);
  const [reducedMotion, setReducedMotion] = useState<boolean>(false);
  const [ready, setReady] = useState<boolean>(false);
  const [loadPercent, setLoadPercent] = useState<number>(0);

  const targetFrameRef = useRef<number>(0);
  const currentFrameRef = useRef<number>(0);
  const framesRef = useRef<(HTMLImageElement | null)[]>([]);
  const lastDrawnIndexRef = useRef<number>(-1);
  const dirRef = useRef<"rtl" | "ltr">(dir);

  useEffect(() => {
    dirRef.current = dir;
  }, [dir]);

  useEffect(() => {
    const mqMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
    const mqMobile = window.matchMedia("(max-width: 767px)");

    const update = () => {
      setReducedMotion(mqMotion.matches);
      setIsMobile(mqMobile.matches);
    };
    update();

    mqMotion.addEventListener("change", update);
    mqMobile.addEventListener("change", update);
    return () => {
      mqMotion.removeEventListener("change", update);
      mqMobile.removeEventListener("change", update);
    };
  }, []);

  // Progressive frame loader
  useEffect(() => {
    if (reducedMotion) {
      setReady(true);
      setLoadPercent(100);
      return;
    }

    let cancelled = false;
    const total = isMobile ? MOBILE_COUNT : DESKTOP_COUNT;
    const basePath = isMobile ? "/frames-mobile" : "/frames";
    const images: (HTMLImageElement | null)[] = new Array(total).fill(null);
    framesRef.current = images;
    lastDrawnIndexRef.current = -1;
    setReady(false);
    setLoadPercent(0);

    const loadFrame = (index: number): Promise<void> =>
      new Promise((resolve) => {
        if (cancelled || images[index]) {
          resolve();
          return;
        }
        const img = new Image();
        const num = String(index + 1).padStart(3, "0");
        img.decoding = "async";
        img.src = `${basePath}/frame_${num}.webp`;
        img.onload = () => {
          const finish = () => {
            if (!cancelled) {
              images[index] = img;
            }
            resolve();
          };
          if (!isMobile && typeof img.decode === "function") {
            img.decode().then(finish).catch(finish);
          } else {
            finish();
          }
        };
        img.onerror = () => resolve();
      });

    const run = async () => {
      const initialCount = Math.min(INITIAL_BATCH, total);
      let loadedInitial = 0;
      await Promise.all(
        Array.from({ length: initialCount }, (_, i) =>
          loadFrame(i).then(() => {
            loadedInitial += 1;
            if (!cancelled) {
              setLoadPercent(Math.round((loadedInitial / initialCount) * 100));
            }
          })
        )
      );

      if (cancelled) return;
      setReady(true);

      const step = isMobile ? 6 : 4;
      const sparseIndices: number[] = [];
      for (let i = initialCount; i < total; i += step) {
        sparseIndices.push(i);
      }

      const loadPool = async (indices: number[], concurrency: number) => {
        let cursor = 0;
        const workers = Array.from({ length: concurrency }, async () => {
          while (!cancelled && cursor < indices.length) {
            const idx = indices[cursor++];
            await loadFrame(idx);
          }
        });
        await Promise.all(workers);
      };

      await loadPool(sparseIndices, isMobile ? 4 : 6);
      if (cancelled) return;

      const restIndices: number[] = [];
      for (let i = initialCount; i < total; i++) {
        if (i % step !== 0) restIndices.push(i);
      }
      await loadPool(restIndices, isMobile ? 4 : 6);
    };

    run();

    return () => {
      cancelled = true;
    };
  }, [isMobile, reducedMotion]);

  // Native mobile scroll + Desktop Lenis + zero-re-render DOM choreography & on-demand canvas rAF
  useEffect(() => {
    if (reducedMotion || !containerRef.current || !canvasRef.current) return;

    const total = isMobile ? MOBILE_COUNT : DESKTOP_COUNT;
    const canvas = canvasRef.current;
    const ctx = canvas.getContext("2d", { alpha: false });
    if (!ctx) return;

    const applyOverlayStyles = (p: number) => {
      const currentDir = dirRef.current;
      const introOpacity = bandOpacity(p, -0.01, 0.0, 0.1, 0.16);
      const introY = p < 0.06 ? (1 - p / 0.06) * 18 : 0;
      if (introRef.current) {
        introRef.current.style.opacity = String(introOpacity);
        introRef.current.style.transform = `translate3d(0, ${introY}px, 0)`;
      }

      const feat1Opacity = bandOpacity(p, 0.16, 0.21, 0.34, 0.4);
      const feat1Enter = clamp01((p - 0.16) / 0.08);
      const feat1X = (1 - feat1Enter) * 36 * (currentDir === "rtl" ? 1 : -1);
      if (feat1Ref.current) {
        feat1Ref.current.style.opacity = String(feat1Opacity);
        feat1Ref.current.style.transform = `translate3d(${feat1X}px, 0, 0)`;
      }

      const feat2Opacity = bandOpacity(p, 0.4, 0.45, 0.58, 0.64);
      const feat2Enter = clamp01((p - 0.4) / 0.08);
      const feat2X = (1 - feat2Enter) * 36 * (currentDir === "rtl" ? -1 : 1);
      if (feat2Ref.current) {
        feat2Ref.current.style.opacity = String(feat2Opacity);
        feat2Ref.current.style.transform = `translate3d(${feat2X}px, 0, 0)`;
      }

      const feat3Opacity = bandOpacity(p, 0.64, 0.69, 0.81, 0.87);
      const feat3Enter = clamp01((p - 0.64) / 0.08);
      const feat3Scale = 0.92 + feat3Enter * 0.08;
      if (feat3Ref.current) {
        feat3Ref.current.style.opacity = String(feat3Opacity);
        feat3Ref.current.style.transform = `scale(${feat3Scale})`;
      }

      const finaleOpacity = clamp01((p - 0.87) / 0.06);
      const logoScale = 0.94 + finaleOpacity * 0.06;
      if (finaleRef.current) {
        finaleRef.current.style.opacity = String(finaleOpacity);
        finaleRef.current.style.transform = `scale(${logoScale})`;
        finaleRef.current.style.pointerEvents = finaleOpacity > 0.2 ? "auto" : "none";
      }

      const hintOpacity = p < 0.07 ? 1 - p / 0.07 : 0;
      if (hintRef.current) {
        hintRef.current.style.opacity = String(hintOpacity);
      }

      if (barRef.current) {
        barRef.current.style.height = `${Math.max(6, Math.round(p * 100))}%`;
      }
    };

    const resizeCanvas = () => {
      const dpr = isMobile ? 1 : Math.min(window.devicePixelRatio || 1, 1.5);
      const rect = canvas.getBoundingClientRect();
      canvas.width = Math.max(1, Math.floor(rect.width * dpr));
      canvas.height = Math.max(1, Math.floor(rect.height * dpr));
      lastDrawnIndexRef.current = -1;
    };
    resizeCanvas();
    window.addEventListener("resize", resizeCanvas);

    const findNearestLoaded = (targetIdx: number): HTMLImageElement | null => {
      const imgs = framesRef.current;
      if (imgs[targetIdx]) return imgs[targetIdx];
      for (let offset = 1; offset < total; offset++) {
        if (targetIdx - offset >= 0 && imgs[targetIdx - offset]) {
          return imgs[targetIdx - offset];
        }
        if (targetIdx + offset < total && imgs[targetIdx + offset]) {
          return imgs[targetIdx + offset];
        }
      }
      return null;
    };

    const drawCover = (img: HTMLImageElement) => {
      const cw = canvas.width;
      const ch = canvas.height;
      const iw = img.naturalWidth || 1280;
      const ih = img.naturalHeight || 720;
      const scale = Math.max(cw / iw, ch / ih);
      const dw = iw * scale;
      const dh = ih * scale;
      const dx = (cw - dw) / 2;
      const dy = (ch - dh) / 2;
      ctx.imageSmoothingEnabled = true;
      ctx.imageSmoothingQuality = isMobile ? "low" : "high";
      ctx.drawImage(img, dx, dy, dw, dh);
    };

    let rafId = 0;
    let rafActive = false;

    const renderLoop = () => {
      const diff = targetFrameRef.current - currentFrameRef.current;
      const lerp = isMobile ? 0.35 : 0.16;
      currentFrameRef.current = Math.abs(diff) < 0.08 ? targetFrameRef.current : currentFrameRef.current + diff * lerp;
      const rounded = Math.max(0, Math.min(total - 1, Math.round(currentFrameRef.current)));

      if (rounded !== lastDrawnIndexRef.current) {
        const img = findNearestLoaded(rounded);
        if (img) {
          drawCover(img);
          lastDrawnIndexRef.current = rounded;
        }
      }

      if (Math.abs(targetFrameRef.current - currentFrameRef.current) >= 0.08 || lastDrawnIndexRef.current === -1) {
        rafId = window.requestAnimationFrame(renderLoop);
      } else {
        rafActive = false;
      }
    };

    const wakeRenderLoop = () => {
      if (!rafActive) {
        rafActive = true;
        rafId = window.requestAnimationFrame(renderLoop);
      }
    };

    // Draw initial frame and initial overlay state immediately
    applyOverlayStyles(0);
    wakeRenderLoop();

    // Also repaint once initial frames finish loading
    const initialPaintTimer = window.setInterval(() => {
      if (lastDrawnIndexRef.current !== -1) {
        window.clearInterval(initialPaintTimer);
        return;
      }
      wakeRenderLoop();
    }, 120);

    // On touch/mobile devices use 100% native passive scroll (never hijack touch with Lenis)
    const isCoarsePointer = window.matchMedia("(pointer: coarse)").matches;
    if (isMobile || isCoarsePointer) {
      let ticking = false;
      const syncFromNativeScroll = () => {
        ticking = false;
        const el = containerRef.current;
        if (!el) return;
        const rect = el.getBoundingClientRect();
        const scrollable = Math.max(1, el.offsetHeight - window.innerHeight);
        const p = clamp01(-rect.top / scrollable);
        targetFrameRef.current = p * (total - 1);
        applyOverlayStyles(p);
        wakeRenderLoop();
      };

      const onScroll = () => {
        if (!ticking) {
          ticking = true;
          window.requestAnimationFrame(syncFromNativeScroll);
        }
      };

      syncFromNativeScroll();
      window.addEventListener("scroll", onScroll, { passive: true });
      return () => {
        window.clearInterval(initialPaintTimer);
        window.cancelAnimationFrame(rafId);
        window.removeEventListener("resize", resizeCanvas);
        window.removeEventListener("scroll", onScroll);
      };
    }

    // Desktop smooth wheel via Lenis + GSAP ScrollTrigger
    const lenis = new Lenis({
      duration: 1.05,
      easing: (x) => Math.min(1, 1.001 - Math.pow(2, -10 * x)),
      smoothWheel: true,
    });

    lenis.on("scroll", ScrollTrigger.update);
    const tickLenis = (time: number) => {
      lenis.raf(time * 1000);
    };
    gsap.ticker.add(tickLenis);
    gsap.ticker.lagSmoothing(0);

    const st = ScrollTrigger.create({
      trigger: containerRef.current,
      start: "top top",
      end: "bottom bottom",
      scrub: true,
      onUpdate: (self) => {
        const p = clamp01(self.progress);
        targetFrameRef.current = p * (total - 1);
        applyOverlayStyles(p);
        wakeRenderLoop();
      },
    });

    return () => {
      window.clearInterval(initialPaintTimer);
      window.cancelAnimationFrame(rafId);
      window.removeEventListener("resize", resizeCanvas);
      st.kill();
      gsap.ticker.remove(tickLenis);
      lenis.destroy();
    };
  }, [isMobile, reducedMotion]);

  const brandName = locale === "ar" ? "مصطفى عمار للأكواريوم" : "Mostafa Ammar Aquatics";
  const whatsappUrl = buildWhatsappUrl(
    locale === "ar"
      ? "مرحباً مصطفى عمار، أرغب في الطلب من المتجر."
      : "Hello Mostafa Ammar Aquatics, I would like to place an order."
  );

  // Reduced-motion static hero
  if (reducedMotion) {
    const staticFrame = isMobile ? "/frames-mobile/frame_096.webp" : "/frames/frame_192.webp";
    return (
      <section
        id="hero"
        className="relative min-h-[100dvh] w-full overflow-hidden bg-[#378FC8] flex items-center justify-center pt-24 pb-16 px-4"
      >
        <img
          src={staticFrame}
          alt={brandName}
          className="absolute inset-0 w-full h-full object-cover"
        />
        <div
          className="absolute inset-0"
          style={{
            background:
              "linear-gradient(180deg, rgba(27,81,131,0.58) 0%, rgba(42,108,165,0.42) 50%, rgba(27,81,131,0.72) 100%)",
          }}
        />
        <div className="relative z-10 mx-auto max-w-3xl text-center space-y-6 bg-[#1B5183]/88 md:bg-[#1B5183]/78 md:backdrop-blur-md border border-[#BFE9DA]/40 rounded-[2rem] p-6 sm:p-10 text-white">
          <img
            src="/logo.webp"
            alt={brandName}
            width={160}
            height={160}
            className="mx-auto w-24 h-24 sm:w-36 sm:h-36 object-contain drop-shadow-[0_8px_24px_rgba(191,233,218,0.45)]"
          />
          <p className="inline-flex items-center rounded-full bg-[#5ECAE2]/25 border border-[#BFE9DA]/45 px-4 py-1.5 text-xs sm:text-sm font-bold text-[#E0F7FA]">
            {t.hero.eyebrow}
          </p>
          <h1 className="text-3xl sm:text-6xl font-extrabold tracking-tight">{t.hero.headline}</h1>
          <ul className="space-y-2 text-sm sm:text-base text-[#E0F2FE] font-medium">
            <li>{t.hero.feature1}</li>
            <li>{t.hero.feature2}</li>
            <li>{t.hero.feature3}</li>
          </ul>
          <HeroCtaGroup
            ctaShop={t.hero.ctaShop}
            ctaApp={t.hero.ctaApp}
            ctaWhatsapp={t.hero.ctaWhatsapp}
            whatsappUrl={whatsappUrl}
          />
        </div>
      </section>
    );
  }

  return (
    <section
      id="hero"
      ref={containerRef}
      className="relative h-[165vh] md:h-[260vh] w-full bg-[#378FC8]"
      aria-label={brandName}
    >
      <div className="sticky top-0 h-[100dvh] w-full overflow-hidden bg-[#378FC8]">
        {/* Canvas */}
        <canvas
          ref={canvasRef}
          className="absolute inset-0 w-full h-full block"
          aria-hidden="true"
        />

        {/* Soft ocean royal-blue scrim */}
        <div
          className="pointer-events-none absolute inset-0"
          style={{
            background:
              "linear-gradient(180deg, rgba(27,81,131,0.42) 0%, rgba(42,108,165,0.14) 45%, rgba(27,81,131,0.48) 100%)",
          }}
        />

        {/* Loading Screen */}
        {!ready && (
          <div className="absolute inset-0 z-30 flex flex-col items-center justify-center bg-gradient-to-b from-[#2A6CA5] via-[#378FC8] to-[#45ACD4] text-white px-6">
            <img
              src="/logo.webp"
              alt={brandName}
              width={120}
              height={120}
              className="w-24 h-24 sm:w-28 sm:h-28 object-contain mb-6 drop-shadow-[0_10px_24px_rgba(7,26,47,0.28)]"
            />
            <p className="text-base sm:text-lg font-bold mb-4 text-white">{t.hero.loading}</p>
            <div className="w-56 sm:w-64 h-2.5 rounded-full bg-white/25 overflow-hidden border border-[#BFE9DA]/40">
              <div
                className="h-full bg-[#FACC15] rounded-full transition-all duration-200"
                style={{ width: `${loadPercent}%` }}
              />
            </div>
          </div>
        )}

        {/* 0-12%: Eyebrow + Main Headline */}
        <div
          ref={introRef}
          className="pointer-events-none absolute inset-0 flex items-center justify-center px-4 sm:px-8 will-change-[opacity,transform]"
        >
          <div className="max-w-3xl text-center bg-[#1B5183]/88 md:bg-[#1B5183]/76 md:backdrop-blur-md border border-[#BFE9DA]/40 rounded-[1.75rem] sm:rounded-[2rem] px-5 py-6 sm:px-12 sm:py-10 text-white shadow-[0_12px_36px_rgba(27,81,131,0.28)]">
            <span className="inline-block rounded-full bg-[#5ECAE2]/25 border border-[#BFE9DA]/45 px-3.5 py-1 text-xs sm:text-sm font-bold text-[#E0F7FA] mb-3 sm:mb-4">
              {t.hero.eyebrow}
            </span>
            <h1 className="text-3xl sm:text-6xl md:text-7xl font-extrabold tracking-tight leading-[1.15]">
              {t.hero.headline}
            </h1>
          </div>
        </div>

        {/* 18-38%: Feature 1 */}
        <div
          ref={feat1Ref}
          className="pointer-events-none absolute inset-x-0 top-[26%] sm:top-[28%] flex justify-start px-4 sm:px-14 md:px-24 will-change-[opacity,transform]"
          style={{ opacity: 0 }}
        >
          <div className="inline-flex items-center gap-2.5 sm:gap-3 rounded-full bg-[#1B5183]/88 md:bg-[#1B5183]/50 md:backdrop-blur-md border border-white/30 px-4 py-2.5 sm:px-5 sm:py-3 text-white shadow-[0_8px_24px_rgba(7,26,47,0.18)]">
            <HeartPulse className="w-4 h-4 sm:w-5 sm:h-5 text-[#FACC15] shrink-0" strokeWidth={2} aria-hidden="true" />
            <p className="text-sm sm:text-xl font-bold leading-snug">{t.hero.feature1}</p>
          </div>
        </div>

        {/* 42-62%: Feature 2 */}
        <div
          ref={feat2Ref}
          className="pointer-events-none absolute inset-x-0 top-[30%] sm:top-[32%] flex justify-end px-4 sm:px-14 md:px-24 will-change-[opacity,transform]"
          style={{ opacity: 0 }}
        >
          <div className="inline-flex items-center gap-2.5 sm:gap-3 rounded-full bg-[#1B5183]/88 md:bg-[#1B5183]/50 md:backdrop-blur-md border border-white/30 px-4 py-2.5 sm:px-5 sm:py-3 text-white shadow-[0_8px_24px_rgba(7,26,47,0.18)]">
            <Sparkles className="w-4 h-4 sm:w-5 sm:h-5 text-[#5ECAE2] shrink-0" strokeWidth={2} aria-hidden="true" />
            <p className="text-sm sm:text-xl font-bold leading-snug">{t.hero.feature2}</p>
          </div>
        </div>

        {/* 66-84%: Feature 3 */}
        <div
          ref={feat3Ref}
          className="pointer-events-none absolute inset-x-0 bottom-[16%] flex justify-center px-4 sm:px-8 will-change-[opacity,transform]"
          style={{ opacity: 0 }}
        >
          <div className="inline-flex items-center gap-2.5 sm:gap-3 rounded-full bg-[#1B5183]/88 md:bg-[#1B5183]/50 md:backdrop-blur-md border border-white/30 px-5 py-2.5 sm:px-6 sm:py-3 text-white shadow-[0_8px_24px_rgba(7,26,47,0.18)]">
            <Truck className="w-4 h-4 sm:w-5 sm:h-5 text-[#BFE9DA] shrink-0" strokeWidth={2} aria-hidden="true" />
            <p className="text-sm sm:text-xl font-bold leading-snug">{t.hero.feature3}</p>
          </div>
        </div>

        {/* 88-100%: Logo Reveal + CTAs */}
        <div
          ref={finaleRef}
          className="absolute inset-0 flex items-center justify-center px-4 sm:px-8 pointer-events-none will-change-[opacity,transform]"
          style={{ opacity: 0 }}
        >
          <div className="max-w-2xl w-full text-center bg-[#1B5183]/90 md:bg-[#1B5183]/78 md:backdrop-blur-md border border-[#BFE9DA]/45 rounded-[1.75rem] sm:rounded-[2rem] p-5 sm:p-10 text-white shadow-[0_16px_48px_rgba(27,81,131,0.32)]">
            <img
              src="/logo.webp"
              alt={brandName}
              width={200}
              height={200}
              className="mx-auto w-24 h-24 sm:w-44 sm:h-44 object-contain mb-4 sm:mb-5 drop-shadow-[0_0_24px_rgba(191,233,218,0.5)]"
            />
            <h2 className="text-2xl sm:text-4xl font-extrabold mb-5 sm:mb-6 text-white">
              {t.hero.headline}
            </h2>
            <HeroCtaGroup
              ctaShop={t.hero.ctaShop}
              ctaApp={t.hero.ctaApp}
              ctaWhatsapp={t.hero.ctaWhatsapp}
              whatsappUrl={whatsappUrl}
            />
          </div>
        </div>

        {/* Scroll Hint (0-7%) */}
        <div
          ref={hintRef}
          className="pointer-events-none absolute bottom-16 md:bottom-7 inset-x-0 flex justify-center px-4"
        >
          <div className="inline-flex items-center gap-2 rounded-full bg-[#1B5183]/90 md:bg-[#1B5183]/80 md:backdrop-blur-md border border-[#BFE9DA]/40 px-4 py-2 text-xs sm:text-sm font-semibold text-white">
            <span>{t.hero.scrollHint}</span>
            <ChevronDown className="w-4 h-4 text-[#FACC15] animate-bounce" aria-hidden="true" />
          </div>
        </div>

        {/* Side Progress Indicator */}
        <div
          className="pointer-events-none absolute top-1/2 -translate-y-1/2 end-3 sm:end-5 z-20 flex flex-col items-center gap-2"
          aria-hidden="true"
        >
          <div className="w-1.5 h-24 sm:h-36 rounded-full bg-[#1B5183]/45 border border-[#BFE9DA]/35 overflow-hidden">
            <div
              ref={barRef}
              className="w-full bg-[#FACC15] rounded-full"
              style={{ height: "6%" }}
            />
          </div>
        </div>
      </div>
    </section>
  );
}

function HeroCtaGroup({
  ctaShop,
  ctaApp,
}: {
  ctaShop: string;
  ctaApp: string;
  ctaWhatsapp?: string;
  whatsappUrl?: string;
}) {
  return (
    <div className="flex flex-col sm:flex-row items-center justify-center gap-3 sm:gap-4">
      <a
        href="/shop/"
        className="w-full sm:w-auto min-h-[48px] md:min-h-[56px] inline-flex items-center justify-center gap-2.5 rounded-full bg-ocean-yellow [@media(hover:hover)]:hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-base px-8 transition-[transform,background-color] duration-200 ease-[cubic-bezier(0.32,0.72,0,1)] active:scale-[0.97] cursor-pointer shadow-md"
      >
        <ShoppingBag className="w-5 h-5 shrink-0" strokeWidth={1.75} aria-hidden="true" />
        <span>{ctaShop}</span>
      </a>
      <a
        href="#categories"
        className="w-full sm:w-auto min-h-[48px] md:min-h-[56px] inline-flex items-center justify-center gap-2.5 rounded-full bg-white/18 [@media(hover:hover)]:hover:bg-white/28 border border-ocean-sunlit/50 text-white font-bold text-base px-7 transition-[transform,background-color] duration-200 ease-[cubic-bezier(0.32,0.72,0,1)] active:scale-[0.97] cursor-pointer"
      >
        <Smartphone className="w-5 h-5 shrink-0" strokeWidth={1.75} aria-hidden="true" />
        <span>{ctaApp}</span>
      </a>
    </div>
  );
}
