import type { Metadata } from "next";
import { Cairo, Plus_Jakarta_Sans } from "next/font/google";
import { CartProvider } from "@/components/CartProvider";
import { LanguageProvider } from "@/components/LanguageProvider";
import { OrderDrawer } from "@/components/OrderDrawer";
import "./globals.css";

const cairo = Cairo({
  subsets: ["arabic", "latin"],
  weight: ["400", "500", "600", "700", "800"],
  variable: "--font-cairo",
  display: "swap",
});

const jakarta = Plus_Jakarta_Sans({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700", "800"],
  variable: "--font-jakarta",
  display: "swap",
});

export const metadata: Metadata = {
  // TODO(owner): replace with real production domain
  metadataBase: new URL("https://mostafa-ammar-aquatics.example"),
  title: "مصطفى عمار للأكواريوم | Mostafa Ammar Aquatics",
  description:
    "متجر مصطفى عمار لأسماك الزينة، السلاحف المائية، الأغذية، الأحواض، والفلاتر مع رعاية بيطرية موثوقة.",
  icons: {
    icon: "/logo.png",
  },
  openGraph: {
    title: "مصطفى عمار للأكواريوم | Mostafa Ammar Aquatics",
    description:
      "متجر مصطفى عمار لأسماك الزينة، السلاحف المائية، الأغذية، الأحواض، والفلاتر مع رعاية بيطرية موثوقة.",
    images: ["/frames/frame_192.webp"],
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ar" dir="rtl" className={`${cairo.variable} ${jakarta.variable}`}>
      <body className="antialiased">
        <LanguageProvider>
          <CartProvider>
            {children}
            <OrderDrawer />
          </CartProvider>
        </LanguageProvider>
      </body>
    </html>
  );
}
