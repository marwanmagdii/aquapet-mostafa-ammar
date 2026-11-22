export interface VetContact {
  id: string;
  areaAr: string;
  areaEn: string;
  nameAr: string;
  nameEn: string;
  clinicAr: string;
  clinicEn: string;
  specialtyAr: string;
  specialtyEn: string;
  bioAr: string;
  bioEn: string;
  hoursAr: string;
  hoursEn: string;
  feeEgp: number;
  image: string;
  phoneHref: string;
  mapsUrl: string;
}

// TODO(owner): replace all 3 mock vet clinic records with real partner clinics
export const trustedVets: VetContact[] = [
  {
    id: "vet-1",
    areaAr: "المهندسين",
    areaEn: "Mohandessin",
    nameAr: "د. أحمد الشربيني",
    nameEn: "Dr. Ahmed Sherbiny",
    clinicAr: "مركز نيل أكوا البيطري",
    clinicEn: "Nile Aqua Vet Center",
    specialtyAr: "أمراض أسماك الزينة وجودة المياه",
    specialtyEn: "Ornamental Fish & Water Pathology",
    bioAr: "خبرة 12 عاماً في تشخيص أمراض أسماك المياه العذبة، علاج الطفيليات الخارجية، وضبط التوازن الحيوي للأحواض المزروعة.",
    bioEn: "12 years of clinical experience in freshwater ornamental fish pathology, external parasite eradication, and planted tank bio-balance.",
    hoursAr: "يومياً 12 ظ – 10 م",
    hoursEn: "Daily 12 PM – 10 PM",
    feeEgp: 150,
    image:
      "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&w=800&q=80",
    phoneHref: "tel:+201011112233",
    mapsUrl: "https://maps.google.com/?q=Mohandessin,Giza,Egypt",
  },
  {
    id: "vet-2",
    areaAr: "المعادي",
    areaEn: "Maadi",
    nameAr: "د. سلمى منصور",
    nameEn: "Dr. Salma Mansour",
    clinicAr: "عيادة السلاحف والأحياء المائية",
    clinicEn: "Aquatic Turtle & Reptile Clinic",
    specialtyAr: "طب السلاحف المائية والتغذية بالكالسيوم",
    specialtyEn: "Aquatic Turtles & Shell Care",
    bioAr: "متخصصة في رعاية السلاحف البرمائية، علاج ليونة الدرع ونقص فيتامين D3، وتصميم بيئة التشمس والإضاءة UVB.",
    bioEn: "Specialist in semi-aquatic turtle rehabilitation, shell density restoration, D3/Calcium nutrition, and UVB basking setups.",
    hoursAr: "يومياً 1 ظ – 9 م",
    hoursEn: "Daily 1 PM – 9 PM",
    feeEgp: 150,
    // Kept untouched per user instruction ("except dr salma mansour")
    image: "/images/vet-clinic-2.webp",
    phoneHref: "tel:+201022223344",
    mapsUrl: "https://maps.google.com/?q=Maadi,Cairo,Egypt",
  },
  {
    id: "vet-3",
    areaAr: "مدينة نصر",
    areaEn: "Nasr City",
    nameAr: "د. كريم عادل",
    nameEn: "Dr. Karim Adel",
    clinicAr: "عيادة بلو ريف التخصصية",
    clinicEn: "Blue Reef Specialty Clinic",
    specialtyAr: "علاج الطفيليات وتأسيس الأحواض الحيوية",
    specialtyEn: "Parasite Treatment & Bio-Cycling",
    bioAr: "أخصائي تغذية ومناعة الكائنات المائية، فحص ميكروسكوبي للمياه، وبرامج الحجر الصحي للأسماك الجديدة قبل إضافتها للحوض.",
    bioEn: "Aquatic nutrition and immunity specialist offering microscopic water testing and quarantine protocols for new livestock.",
    hoursAr: "يومياً 11 ص – 10 م",
    hoursEn: "Daily 11 AM – 10 PM",
    feeEgp: 150,
    image:
      "https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&w=800&q=80",
    phoneHref: "tel:+201033334455",
    mapsUrl: "https://maps.google.com/?q=Nasr+City,Cairo,Egypt",
  },
];
