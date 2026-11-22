"use client";

import React, { createContext, useContext, useEffect, useMemo, useState } from "react";
import { products, type Product } from "@/lib/products";

export interface CartItem {
  product: Product;
  qty: number;
}

export type PaymentMethod = "cod" | "instapay" | "card" | "vodafone";

export interface OrderRecord {
  orderId: string;
  customerName: string;
  phone: string;
  city: string;
  address: string;
  paymentMethod: PaymentMethod;
  items: CartItem[];
  subtotal: number;
  shippingFee: number;
  total: number;
  createdAt: string;
}

interface CartContextValue {
  items: CartItem[];
  drawerOpen: boolean;
  setDrawerOpen: (open: boolean) => void;
  checkoutStep: "cart" | "checkout" | "success";
  setCheckoutStep: (step: "cart" | "checkout" | "success") => void;
  lastOrder: OrderRecord | null;
  addItem: (product: Product, openDrawer?: boolean) => void;
  buyNow: (product: Product, qty?: number) => void;
  updateQty: (productId: string, delta: number) => void;
  clearCart: () => void;
  placeOrder: (info: {
    customerName: string;
    phone: string;
    city: string;
    address: string;
    paymentMethod: PaymentMethod;
  }) => void;
  totalCount: number;
  subtotal: number;
  shippingFee: number;
  totalPrice: number;
}

const CartContext = createContext<CartContextValue | null>(null);

export const FREE_DELIVERY_THRESHOLD = 500;
export const STANDARD_SHIPPING_FEE = 45;

export function CartProvider({ children }: { children: React.ReactNode }) {
  const [quantities, setQuantities] = useState<Record<string, number>>({});
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [checkoutStep, setCheckoutStep] = useState<"cart" | "checkout" | "success">("cart");
  const [lastOrder, setLastOrder] = useState<OrderRecord | null>(null);

  useEffect(() => {
    try {
      const saved = window.localStorage.getItem("fishshop-cart");
      if (saved) {
        setQuantities(JSON.parse(saved));
      }
    } catch {
      // Ignore storage access errors
    }
  }, []);

  useEffect(() => {
    try {
      window.localStorage.setItem("fishshop-cart", JSON.stringify(quantities));
    } catch {
      // Ignore storage write errors
    }
  }, [quantities]);

  const addItem = (product: Product, openDrawer = false) => {
    setQuantities((prev) => ({
      ...prev,
      [product.id]: (prev[product.id] || 0) + 1,
    }));
    if (openDrawer) {
      setCheckoutStep("cart");
      setDrawerOpen(true);
    }
  };

  const buyNow = (product: Product, qty = 1) => {
    setQuantities((prev) => ({
      ...prev,
      [product.id]: Math.max(qty, (prev[product.id] || 0) + qty),
    }));
    setCheckoutStep("checkout");
    setDrawerOpen(true);
  };

  const updateQty = (productId: string, delta: number) => {
    setQuantities((prev) => {
      const next = (prev[productId] || 0) + delta;
      if (next <= 0) {
        const copy = { ...prev };
        delete copy[productId];
        return copy;
      }
      return { ...prev, [productId]: next };
    });
  };

  const clearCart = () => setQuantities({});

  const items = useMemo<CartItem[]>(() => {
    return Object.entries(quantities)
      .map(([id, qty]) => {
        const product = products.find((p) => p.id === id);
        return product ? { product, qty } : null;
      })
      .filter((x): x is CartItem => Boolean(x));
  }, [quantities]);

  const totalCount = useMemo(() => items.reduce((sum, i) => sum + i.qty, 0), [items]);
  const subtotal = useMemo(
    () => items.reduce((sum, i) => sum + i.product.priceEgp * i.qty, 0),
    [items]
  );
  const shippingFee = subtotal === 0 || subtotal >= FREE_DELIVERY_THRESHOLD ? 0 : STANDARD_SHIPPING_FEE;
  const totalPrice = subtotal + shippingFee;

  const placeOrder = (info: {
    customerName: string;
    phone: string;
    city: string;
    address: string;
    paymentMethod: PaymentMethod;
  }) => {
    const orderId = `MA-${Math.floor(1000 + Math.random() * 9000)}`;
    const record: OrderRecord = {
      orderId,
      ...info,
      items: [...items],
      subtotal,
      shippingFee,
      total: totalPrice,
      createdAt: new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
    };
    setLastOrder(record);
    setQuantities({});
    setCheckoutStep("success");
  };

  return (
    <CartContext.Provider
      value={{
        items,
        drawerOpen,
        setDrawerOpen,
        checkoutStep,
        setCheckoutStep,
        lastOrder,
        addItem,
        buyNow,
        updateQty,
        clearCart,
        placeOrder,
        totalCount,
        subtotal,
        shippingFee,
        totalPrice,
      }}
    >
      {children}
    </CartContext.Provider>
  );
}

export function useCart(): CartContextValue {
  const ctx = useContext(CartContext);
  if (!ctx) {
    throw new Error("useCart must be used within a CartProvider");
  }
  return ctx;
}
