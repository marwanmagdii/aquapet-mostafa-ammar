import { CategoryFilterProvider } from "@/components/CategoryFilterProvider";
import { Footer } from "@/components/Footer";
import { Header } from "@/components/Header";
import { HeroScrollScene } from "@/components/HeroScrollScene";
import { MobileActionBar } from "@/components/MobileActionBar";
import { CategoriesSection } from "@/components/sections/CategoriesSection";
import { ContactSection } from "@/components/sections/ContactSection";
import { LoyaltyAppSection } from "@/components/sections/LoyaltyAppSection";
import { ProductsSection } from "@/components/sections/ProductsSection";
import { VetsSection } from "@/components/sections/VetsSection";
import { WhyUsSection } from "@/components/sections/WhyUsSection";
import { BlogSection } from "@/components/sections/BlogSection";

export default function HomePage() {
  return (
    <CategoryFilterProvider>
      <div className="min-h-screen flex flex-col bg-ocean-ice text-ocean-navy">
        <Header />
        <main className="flex-1">
          <HeroScrollScene />
          <CategoriesSection />
          <ProductsSection />
          <WhyUsSection />
          <LoyaltyAppSection />
          <VetsSection />
          <BlogSection />
          <ContactSection />
        </main>
        <Footer />
        <MobileActionBar />
      </div>
    </CategoryFilterProvider>
  );
}
