"use client";

import React, { useState } from "react";
import {
  ArrowLeft,
  ArrowRight,
  Banknote,
  CheckCircle2,
  CreditCard,
  Minus,
  Plus,
  ShieldCheck,
  ShoppingBag,
  Smartphone,
  Trash2,
  Truck,
  Wallet,
  X,
} from "lucide-react";
import {
  FREE_DELIVERY_THRESHOLD,
  type PaymentMethod,
  useCart,
} from "./CartProvider";
import { useLanguage } from "./LanguageProvider";

export function OrderDrawer() {
  const { locale, t } = useLanguage();
  const {
    items,
    drawerOpen,
    setDrawerOpen,
    checkoutStep,
    setCheckoutStep,
    lastOrder,
    updateQty,
    clearCart,
    placeOrder,
    totalCount,
    subtotal,
    shippingFee,
    totalPrice,
  } = useCart();

  const [customerName, setCustomerName] = useState("");
  const [phone, setPhone] = useState("");
  const [city, setCity] = useState(locale === "ar" ? "القاهرة" : "Cairo");
  const [address, setAddress] = useState("");
  const [paymentMethod, setPaymentMethod] = useState<PaymentMethod>("cod");
  const [errorMsg, setErrorMsg] = useState("");

  if (!drawerOpen) return null;

  const remaining = Math.max(0, FREE_DELIVERY_THRESHOLD - subtotal);
  const progressPct = Math.min(100, Math.round((subtotal / FREE_DELIVERY_THRESHOLD) * 100));

  const handleCheckoutSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!customerName.trim() || !phone.trim() || !address.trim()) {
      setErrorMsg(
        locale === "ar"
          ? "يرجى إدخال الاسم ورقم الموبايل والعنوان بالتفصيل"
          : "Please enter your name, phone number, and street address"
      );
      return;
    }
    setErrorMsg("");
    placeOrder({
      customerName: customerName.trim(),
      phone: phone.trim(),
      city,
      address: address.trim(),
      paymentMethod,
    });
  };

  const paymentOptions: Array<{
    id: PaymentMethod;
    titleAr: string;
    titleEn: string;
    subAr: string;
    subEn: string;
    icon: React.ComponentType<{ className?: string; strokeWidth?: number }>;
  }> = [
    {
      id: "cod",
      titleAr: "الدفع عند الاستلام",
      titleEn: "Cash on Delivery",
      subAr: "ادفع نقداً للمندوب عند استلام الطلب",
      subEn: "Pay cash upon oxygenated delivery",
      icon: Banknote,
    },
    {
      id: "instapay",
      titleAr: "إنستاباي (InstaPay)",
      titleEn: "InstaPay Transfer",
      subAr: "تحويل فوري لحساب المتجر",
      subEn: "Instant bank transfer via InstaPay",
      icon: Smartphone,
    },
    {
      id: "vodafone",
      titleAr: "فودافون كاش",
      titleEn: "Vodafone Cash",
      subAr: "الدفع عبر المحفظة الإلكترونية",
      subEn: "Mobile wallet payment",
      icon: Wallet,
    },
    {
      id: "card",
      titleAr: "بطاقة بنكية (فيزا / ماستركارد)",
      titleEn: "Credit / Debit Card",
      subAr: "دفع إلكتروني آمن",
      subEn: "Visa / Mastercard payment",
      icon: CreditCard,
    },
  ];

  return (
    <div
      className="fixed inset-0 z-50 flex justify-end bg-ocean-navy/65 backdrop-blur-sm"
      role="dialog"
      aria-modal="true"
      aria-label={locale === "ar" ? "سلة التسوق وإتمام الشراء" : "Shopping Cart & Checkout"}
    >
      <button
        type="button"
        onClick={() => setDrawerOpen(false)}
        className="flex-1 cursor-default"
        aria-label={locale === "ar" ? "إغلاق" : "Close"}
      />

      <div className="w-full max-w-lg bg-white h-full flex flex-col shadow-2xl border-s border-ocean-border">
        {/* Top Header */}
        <div className="px-6 py-4 border-b border-ocean-muted flex items-center justify-between gap-3 bg-ocean-ice/60">
          <div className="flex items-center gap-3">
            {checkoutStep === "checkout" ? (
              <button
                type="button"
                onClick={() => setCheckoutStep("cart")}
                className="w-10 h-10 rounded-full bg-white border border-ocean-border flex items-center justify-center text-ocean-navy cursor-pointer"
                aria-label={locale === "ar" ? "رجوع للسلة" : "Back to cart"}
              >
                <ArrowLeft className="w-5 h-5 rtl:rotate-180" strokeWidth={1.75} />
              </button>
            ) : (
              <div className="w-10 h-10 rounded-xl bg-ocean-primary text-white flex items-center justify-center">
                <ShoppingBag className="w-5 h-5" strokeWidth={1.75} aria-hidden="true" />
              </div>
            )}
            <div>
              <h2 className="text-lg font-extrabold text-ocean-navy">
                {checkoutStep === "cart"
                  ? locale === "ar"
                    ? `سلة التسوق (${totalCount})`
                    : `Shopping Cart (${totalCount})`
                  : checkoutStep === "checkout"
                  ? locale === "ar"
                    ? "إتمام الشراء والدفع"
                    : "Checkout & Payment"
                  : locale === "ar"
                  ? "فاتورة تأكيد الطلب"
                  : "Order Confirmation"}
              </h2>
            </div>
          </div>

          <button
            type="button"
            onClick={() => setDrawerOpen(false)}
            aria-label={locale === "ar" ? "إغلاق" : "Close"}
            className="w-11 h-11 rounded-full bg-white border border-ocean-border text-ocean-navy [@media(hover:hover)]:hover:bg-ocean-muted flex items-center justify-center cursor-pointer"
          >
            <X className="w-5 h-5" strokeWidth={1.75} aria-hidden="true" />
          </button>
        </div>

        {/* STAGE 1: SHOPPING CART */}
        {checkoutStep === "cart" && (
          <>
            <div className="px-6 py-3.5 bg-ocean-ice border-b border-ocean-border">
              <div className="flex items-center justify-between gap-2 text-sm font-bold text-ocean-navy mb-2">
                <span className="inline-flex items-center gap-1.5">
                  <Truck className="w-4 h-4 text-ocean-primary" strokeWidth={1.75} aria-hidden="true" />
                  {remaining === 0
                    ? locale === "ar"
                      ? "مبروك! حصلت على شحن مجاني مجهز بالأكسجين"
                      : "Free oxygenated shipping unlocked!"
                    : locale === "ar"
                    ? `أضف ${remaining} ج.م للحصول على شحن مجاني`
                    : `Add ${remaining} EGP for free shipping`}
                </span>
                <span className="tabular-nums text-ocean-primary">{progressPct}%</span>
              </div>
              <div className="h-2 rounded-full bg-ocean-border/60 overflow-hidden">
                <div
                  className="h-full rounded-full bg-ocean-primary transition-[width] duration-300"
                  style={{ width: `${progressPct}%` }}
                />
              </div>
            </div>

            <div className="flex-1 overflow-y-auto p-6 space-y-3">
              {items.length === 0 ? (
                <div className="h-full flex flex-col items-center justify-center text-center py-12 text-ocean-slate">
                  <ShoppingBag
                    className="w-14 h-14 text-ocean-border mb-3"
                    strokeWidth={1.5}
                    aria-hidden="true"
                  />
                  <p className="text-lg font-extrabold text-ocean-navy">
                    {locale === "ar" ? "سلة التسوق فارغة" : "Your shopping cart is empty"}
                  </p>
                  <p className="mt-1 text-sm text-ocean-slate">
                    {locale === "ar"
                      ? "اختر الأسماك أو المستلزمات واضغط أضف للسلة"
                      : "Browse fish, tanks, and gear to add items"}
                  </p>
                </div>
              ) : (
                items.map(({ product, qty }) => (
                  <div
                    key={product.id}
                    className="rounded-2xl bg-ocean-ice/70 border border-ocean-border p-3.5 flex items-center gap-3.5"
                  >
                    <img
                      src={product.image}
                      alt={locale === "ar" ? product.nameAr : product.nameEn}
                      width={72}
                      height={54}
                      className="w-18 h-14 rounded-xl object-cover shrink-0 bg-ocean-navy"
                    />
                    <div className="flex-1 min-w-0">
                      <p className="text-base font-extrabold text-ocean-navy truncate">
                        {locale === "ar" ? product.nameAr : product.nameEn}
                      </p>
                      <p className="text-sm font-bold text-ocean-primary tabular-nums mt-0.5">
                        {(product.priceEgp * qty).toLocaleString(
                          locale === "ar" ? "ar-EG" : "en-US"
                        )}{" "}
                        {t.products.currency}
                      </p>
                    </div>
                    <div className="flex items-center gap-1.5">
                      <button
                        type="button"
                        onClick={() => updateQty(product.id, -1)}
                        aria-label={locale === "ar" ? "تقليل" : "Decrease"}
                        className="w-9 h-9 rounded-full bg-white border border-ocean-border flex items-center justify-center text-ocean-navy cursor-pointer"
                      >
                        <Minus className="w-4 h-4" strokeWidth={1.75} aria-hidden="true" />
                      </button>
                      <span className="w-7 text-center text-base font-extrabold tabular-nums">
                        {qty}
                      </span>
                      <button
                        type="button"
                        onClick={() => updateQty(product.id, 1)}
                        aria-label={locale === "ar" ? "زيادة" : "Increase"}
                        className="w-9 h-9 rounded-full bg-white border border-ocean-border flex items-center justify-center text-ocean-navy cursor-pointer"
                      >
                        <Plus className="w-4 h-4" strokeWidth={1.75} aria-hidden="true" />
                      </button>
                    </div>
                  </div>
                ))
              )}
            </div>

            {items.length > 0 && (
              <div className="p-6 border-t border-ocean-muted bg-ocean-ice/60 space-y-3">
                <div className="space-y-1.5 text-sm">
                  <div className="flex justify-between text-ocean-slate font-semibold">
                    <span>{locale === "ar" ? "المجموع الفرعي" : "Subtotal"}</span>
                    <span className="tabular-nums">
                      {subtotal.toLocaleString(locale === "ar" ? "ar-EG" : "en-US")}{" "}
                      {t.products.currency}
                    </span>
                  </div>
                  <div className="flex justify-between text-ocean-slate font-semibold">
                    <span>{locale === "ar" ? "الشحن المجهز بالأكسجين" : "Oxygenated Shipping"}</span>
                    <span className="tabular-nums text-ocean-whatsapp font-bold">
                      {shippingFee === 0
                        ? locale === "ar"
                          ? "مجاني"
                          : "FREE"
                        : `${shippingFee} ${t.products.currency}`}
                    </span>
                  </div>
                  <div className="pt-2 border-t border-ocean-border flex justify-between text-lg font-extrabold text-ocean-navy">
                    <span>{locale === "ar" ? "الإجمالي" : "Total"}</span>
                    <span className="tabular-nums text-ocean-primary">
                      {totalPrice.toLocaleString(locale === "ar" ? "ar-EG" : "en-US")}{" "}
                      {t.products.currency}
                    </span>
                  </div>
                </div>

                <div className="flex items-center gap-2 pt-1">
                  <button
                    type="button"
                    onClick={() => setCheckoutStep("checkout")}
                    className="flex-1 min-h-[54px] inline-flex items-center justify-center gap-2 rounded-full bg-ocean-yellow [@media(hover:hover)]:hover:bg-ocean-yellow-hover text-ocean-navy font-extrabold text-base px-6 shadow-md transition-transform active:scale-[0.98] cursor-pointer"
                  >
                    <span>
                      {locale === "ar" ? "إتمام الشراء والدفع" : "Proceed to Checkout"}
                    </span>
                    <ArrowRight
                      className="w-5 h-5 rtl:rotate-180"
                      strokeWidth={2}
                      aria-hidden="true"
                    />
                  </button>
                  <button
                    type="button"
                    onClick={clearCart}
                    aria-label={locale === "ar" ? "إفراغ السلة" : "Clear cart"}
                    className="w-12 h-12 rounded-full bg-white border border-ocean-border text-ocean-slate [@media(hover:hover)]:hover:text-ocean-navy flex items-center justify-center cursor-pointer shrink-0"
                  >
                    <Trash2 className="w-5 h-5" strokeWidth={1.75} aria-hidden="true" />
                  </button>
                </div>
              </div>
            )}
          </>
        )}

        {/* STAGE 2: CHECKOUT FORM */}
        {checkoutStep === "checkout" && (
          <form onSubmit={handleCheckoutSubmit} className="flex-1 flex flex-col overflow-hidden">
            <div className="flex-1 overflow-y-auto p-6 space-y-5">
              {errorMsg && (
                <div className="rounded-xl bg-red-50 border border-red-200 p-3 text-sm font-bold text-red-700">
                  {errorMsg}
                </div>
              )}

              <div className="space-y-3.5">
                <h3 className="text-base font-extrabold text-ocean-navy">
                  {locale === "ar" ? "1. بيانات التوصيل" : "1. Delivery Details"}
                </h3>

                <div>
                  <label className="block text-sm font-bold text-ocean-navy mb-1">
                    {locale === "ar" ? "الاسم الكامل" : "Full Name"}
                  </label>
                  <input
                    type="text"
                    required
                    value={customerName}
                    onChange={(e) => setCustomerName(e.target.value)}
                    placeholder={locale === "ar" ? "مثال: أحمد محمد" : "e.g. Ahmed Mohamed"}
                    className="w-full min-h-[46px] rounded-xl bg-ocean-ice border border-ocean-border px-3.5 text-base text-ocean-navy"
                  />
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div>
                    <label className="block text-sm font-bold text-ocean-navy mb-1">
                      {locale === "ar" ? "رقم الموبايل" : "Mobile Number"}
                    </label>
                    <input
                      type="tel"
                      required
                      dir="ltr"
                      value={phone}
                      onChange={(e) => setPhone(e.target.value)}
                      placeholder="010 1234 5678"
                      className="w-full min-h-[46px] rounded-xl bg-ocean-ice border border-ocean-border px-3.5 text-base text-ocean-navy"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-bold text-ocean-navy mb-1">
                      {locale === "ar" ? "المحافظة" : "Governorate"}
                    </label>
                    <select
                      value={city}
                      onChange={(e) => setCity(e.target.value)}
                      className="w-full min-h-[46px] rounded-xl bg-ocean-ice border border-ocean-border px-3.5 text-base font-semibold text-ocean-navy"
                    >
                      <option value={locale === "ar" ? "القاهرة" : "Cairo"}>
                        {locale === "ar" ? "القاهرة" : "Cairo"}
                      </option>
                      <option value={locale === "ar" ? "الجيزة" : "Giza"}>
                        {locale === "ar" ? "الجيزة" : "Giza"}
                      </option>
                      <option value={locale === "ar" ? "الإسكندرية" : "Alexandria"}>
                        {locale === "ar" ? "الإسكندرية" : "Alexandria"}
                      </option>
                      <option value={locale === "ar" ? "أخرى" : "Other"}>
                        {locale === "ar" ? "محافظة أخرى" : "Other Governorate"}
                      </option>
                    </select>
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-bold text-ocean-navy mb-1">
                    {locale === "ar" ? "العنوان بالتفصيل" : "Street Address & Apartment"}
                  </label>
                  <input
                    type="text"
                    required
                    value={address}
                    onChange={(e) => setAddress(e.target.value)}
                    placeholder={
                      locale === "ar"
                        ? "الشارع، رقم العقار، الدور، علامة مميزة"
                        : "Street, building, floor, landmark"
                    }
                    className="w-full min-h-[46px] rounded-xl bg-ocean-ice border border-ocean-border px-3.5 text-base text-ocean-navy"
                  />
                </div>
              </div>

              <div className="space-y-3 pt-2">
                <h3 className="text-base font-extrabold text-ocean-navy">
                  {locale === "ar" ? "2. طريقة الدفع" : "2. Payment Method"}
                </h3>
                <div className="space-y-2.5">
                  {paymentOptions.map((opt) => {
                    const Icon = opt.icon;
                    const active = paymentMethod === opt.id;
                    return (
                      <button
                        key={opt.id}
                        type="button"
                        onClick={() => setPaymentMethod(opt.id)}
                        className={`w-full rounded-2xl p-3.5 text-start border flex items-center gap-3.5 transition-colors cursor-pointer ${
                          active
                            ? "bg-ocean-muted/70 border-ocean-primary"
                            : "bg-white border-ocean-border hover:bg-ocean-ice"
                        }`}
                      >
                        <div
                          className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 ${
                            active
                              ? "bg-ocean-primary text-white"
                              : "bg-ocean-ice text-ocean-primary"
                          }`}
                        >
                          <Icon className="w-5 h-5" strokeWidth={1.75} aria-hidden="true" />
                        </div>
                        <div className="flex-1 min-w-0">
                          <p className="text-base font-extrabold text-ocean-navy">
                            {locale === "ar" ? opt.titleAr : opt.titleEn}
                          </p>
                          <p className="text-xs font-semibold text-ocean-slate">
                            {locale === "ar" ? opt.subAr : opt.subEn}
                          </p>
                        </div>
                        <div
                          className={`w-5 h-5 rounded-full border-2 flex items-center justify-center ${
                            active ? "border-ocean-primary" : "border-ocean-border"
                          }`}
                        >
                          {active && <div className="w-2.5 h-2.5 rounded-full bg-ocean-primary" />}
                        </div>
                      </button>
                    );
                  })}
                </div>
              </div>
            </div>

            <div className="p-6 border-t border-ocean-muted bg-ocean-ice/60 space-y-3">
              <div className="flex justify-between text-lg font-extrabold text-ocean-navy">
                <span>{locale === "ar" ? "الإجمالي المطلوب" : "Total Due"}</span>
                <span className="tabular-nums text-ocean-primary">
                  {totalPrice.toLocaleString(locale === "ar" ? "ar-EG" : "en-US")}{" "}
                  {t.products.currency}
                </span>
              </div>
              <button
                type="submit"
                className="w-full min-h-[54px] inline-flex items-center justify-center gap-2 rounded-full bg-ocean-whatsapp [@media(hover:hover)]:hover:bg-ocean-whatsapp-hover text-white font-extrabold text-base px-6 shadow-md transition-transform active:scale-[0.98] cursor-pointer"
              >
                <ShieldCheck className="w-5 h-5" strokeWidth={2} aria-hidden="true" />
                <span>
                  {locale === "ar" ? "تأكيد الطلب الآن" : "Place Order Now"}
                </span>
              </button>
            </div>
          </form>
        )}

        {/* STAGE 3: ORDER CONFIRMATION RECEIPT */}
        {checkoutStep === "success" && lastOrder && (
          <div className="flex-1 overflow-y-auto p-6 space-y-6">
            <div className="rounded-3xl bg-ocean-ice border border-ocean-border p-6 text-center space-y-3">
              <div className="w-16 h-16 rounded-full bg-ocean-whatsapp text-white flex items-center justify-center mx-auto shadow-md">
                <CheckCircle2 className="w-9 h-9" strokeWidth={2} aria-hidden="true" />
              </div>
              <span className="inline-block rounded-full bg-ocean-yellow text-ocean-navy px-3.5 py-1 text-xs font-extrabold">
                {locale === "ar" ? `رقم الطلب #${lastOrder.orderId}` : `Order #${lastOrder.orderId}`}
              </span>
              <h3 className="text-2xl font-extrabold text-ocean-navy">
                {locale === "ar" ? "تم استلام طلبك بنجاح!" : "Thank you! Order Confirmed"}
              </h3>
              <p className="text-sm font-semibold text-ocean-slate">
                {locale === "ar"
                  ? "سيتم تجهيز الأسماك بالأكسجين والتواصل معك لتأكيد موعد التسليم."
                  : "Your aquatic order is being prepped with oxygenated packaging."}
              </p>
            </div>

            <div className="rounded-2xl bg-white border border-ocean-border p-4 space-y-2.5 text-sm">
              <div className="flex justify-between">
                <span className="text-ocean-slate font-semibold">
                  {locale === "ar" ? "العميل" : "Customer"}
                </span>
                <span className="font-extrabold text-ocean-navy">{lastOrder.customerName}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-ocean-slate font-semibold">
                  {locale === "ar" ? "الموبايل" : "Phone"}
                </span>
                <span className="font-extrabold text-ocean-navy" dir="ltr">
                  {lastOrder.phone}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-ocean-slate font-semibold">
                  {locale === "ar" ? "العنوان" : "Address"}
                </span>
                <span className="font-extrabold text-ocean-navy">
                  {lastOrder.city} — {lastOrder.address}
                </span>
              </div>
              <div className="flex justify-between pt-2 border-t border-ocean-muted text-base font-extrabold text-ocean-primary">
                <span>{locale === "ar" ? "الإجمالي" : "Total"}</span>
                <span className="tabular-nums">
                  {lastOrder.total.toLocaleString(locale === "ar" ? "ar-EG" : "en-US")}{" "}
                  {t.products.currency}
                </span>
              </div>
            </div>

            <button
              type="button"
              onClick={() => {
                setCheckoutStep("cart");
                setDrawerOpen(false);
              }}
              className="w-full min-h-[52px] rounded-full bg-ocean-primary text-white font-extrabold text-base cursor-pointer"
            >
              {locale === "ar" ? "متابعة التسوق" : "Continue Shopping"}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
