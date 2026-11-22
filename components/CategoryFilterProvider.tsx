"use client";

import React, { createContext, useContext, useState } from "react";
import type { ProductCategory } from "@/lib/products";

interface CategoryFilterContextValue {
  selectedCategory: ProductCategory | null;
  setSelectedCategory: (cat: ProductCategory | null) => void;
  selectAndScrollToProducts: (cat: ProductCategory) => void;
}

const CategoryFilterContext = createContext<CategoryFilterContextValue | null>(null);

export function CategoryFilterProvider({ children }: { children: React.ReactNode }) {
  const [selectedCategory, setSelectedCategory] = useState<ProductCategory | null>(null);

  const selectAndScrollToProducts = (cat: ProductCategory) => {
    setSelectedCategory(cat);
    const el = document.getElementById("products");
    if (el) {
      el.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  };

  return (
    <CategoryFilterContext.Provider
      value={{ selectedCategory, setSelectedCategory, selectAndScrollToProducts }}
    >
      {children}
    </CategoryFilterContext.Provider>
  );
}

export function useCategoryFilter(): CategoryFilterContextValue {
  const ctx = useContext(CategoryFilterContext);
  if (!ctx) {
    throw new Error("useCategoryFilter must be used within a CategoryFilterProvider");
  }
  return ctx;
}
