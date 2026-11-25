"use client";

import React, { createContext, useContext, useEffect, useState } from "react";
import { DEFAULT_LOCALE, dictionaries, type Dictionary, type Locale } from "@/lib/i18n";

interface LanguageContextValue {
  locale: Locale;
  dir: "rtl" | "ltr";
  t: Dictionary;
  setLocale: (locale: Locale) => void;
  toggleLocale: () => void;
}

const LanguageContext = createContext<LanguageContextValue | null>(null);

export function LanguageProvider({ children }: { children: React.ReactNode }) {
  const [locale, setLocaleState] = useState<Locale>(DEFAULT_LOCALE);

  useEffect(() => {
    try {
      const saved = window.localStorage.getItem("fishshop-locale");
      if (saved === "ar" || saved === "en") {
        setLocaleState(saved);
      }
      if ("serviceWorker" in navigator) {
        navigator.serviceWorker.getRegistrations().then((regs) => {
          regs.forEach((reg) => reg.unregister());
        });
      }
    } catch {
      // Ignore storage access errors in restricted contexts
    }
  }, []);

  useEffect(() => {
    const dir = locale === "ar" ? "rtl" : "ltr";
    document.documentElement.lang = locale;
    document.documentElement.dir = dir;
    document.title = dictionaries[locale].meta.title;
    document.body.style.fontFamily =
      locale === "ar"
        ? "var(--font-cairo), system-ui, sans-serif"
        : "var(--font-jakarta), system-ui, sans-serif";
    try {
      window.localStorage.setItem("fishshop-locale", locale);
    } catch {
      // Ignore storage write errors
    }
  }, [locale]);

  const setLocale = (next: Locale) => {
    setLocaleState(next);
  };

  const toggleLocale = () => {
    setLocaleState((prev) => (prev === "ar" ? "en" : "ar"));
  };

  const value: LanguageContextValue = {
    locale,
    dir: locale === "ar" ? "rtl" : "ltr",
    t: dictionaries[locale],
    setLocale,
    toggleLocale,
  };

  return <LanguageContext.Provider value={value}>{children}</LanguageContext.Provider>;
}

export function useLanguage(): LanguageContextValue {
  const ctx = useContext(LanguageContext);
  if (!ctx) {
    throw new Error("useLanguage must be used within a LanguageProvider");
  }
  return ctx;
}
