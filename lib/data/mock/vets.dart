import '../models/vet.dart';

/// Local mock data for Trusted Vets.
/// Edit this list to update clinic details, numbers, or social links.
abstract final class MockVetsData {
  static const List<VetModel> vets = [
    VetModel(
      id: 'vet_1',
      nameEn: 'Dr. Karim El-Sayed',
      nameAr: 'د. كريم السيد',
      clinicEn: 'Nile Aqua & Exotic Vet Clinic',
      clinicAr: 'عيادة النيل للأسماك والحيوانات الأليفة',
      specialtyEn: 'Ornamental fish, water quality & aquatic pets',
      specialtyAr: 'أسماك الزينة، جودة المياه والحيوانات المائية',
      areaEn: 'Maadi, Cairo',
      areaAr: 'المعادي، القاهرة',
      imageAsset: 'assets/images/vets/vet_1.jpg',
      bioEn:
          '10+ years treating freshwater ornamental fish, water-chemistry imbalances, and bacterial fin issues in Cairo.',
      bioAr:
          'أكثر من ١٠ سنوات خبرة في علاج أسماك الزينة، توازن المياه، وأمراض الزعانف في القاهرة.',
      phone: '+201000001122',
      whatsapp: 'https://wa.me/201000001122',
      socialLinks: {
        'facebook': 'https://facebook.com/nileaquavet.demo',
        'instagram': 'https://instagram.com/nileaquavet.demo',
      },
      mapUrl: 'https://maps.google.com/?q=29.9602,31.2569',
    ),
    VetModel(
      id: 'vet_2',
      nameEn: 'Dr. Salma Mansour',
      nameAr: 'د. سلمى منصور',
      clinicEn: 'BlueFin Veterinary Care',
      clinicAr: 'مركز بلو فين للرعاية البيطرية',
      specialtyEn: 'Freshwater fish health, parasites & turtles',
      specialtyAr: 'صحة أسماك المياه العذبة، الطفيليات والسلاحف',
      areaEn: 'Zamalek, Cairo',
      areaAr: 'الزمالك، القاهرة',
      imageAsset: 'assets/images/vets/vet_2.jpg',
      bioEn:
          'Specializes in gentle parasite treatments, Betta recovery, and aquatic turtle nutrition.',
      bioAr:
          'متخصصة في علاج الطفيليات بلطف، تعافي أسماك البيتا، وتغذية السلاحف المائية.',
      phone: '+201100003344',
      whatsapp: 'https://wa.me/201100003344',
      socialLinks: {
        'instagram': 'https://instagram.com/bluefinvet.demo',
        'tiktok': 'https://tiktok.com/@bluefinvet.demo',
      },
      mapUrl: 'https://maps.google.com/?q=30.0609,31.2197',
    ),
    VetModel(
      id: 'vet_3',
      nameEn: 'Dr. Tarek Hassan',
      nameAr: 'د. طارق حسن',
      clinicEn: 'Heliopolis Aquatic & Pet Center',
      clinicAr: 'مركز هليوبوليس للأسماك والحيوانات الأليفة',
      specialtyEn: 'Marine reef fish, quarantine & tank diagnostics',
      specialtyAr: 'أسماك المياه المالحة، الحجر الصحي وتشخيص الأحواض',
      areaEn: 'Heliopolis, Cairo',
      areaAr: 'مصر الجديدة، القاهرة',
      imageAsset: 'assets/images/vets/vet_3.jpg',
      bioEn:
          'Experienced marine reef specialist helping hobbyists with quarantine protocols and full tank diagnostics.',
      bioAr:
          'خبير أسماك المياه المالحة والشعاب المرجانية وبروتوكولات الحجر الصحي وتشخيص الأحواض.',
      phone: '+201200005566',
      socialLinks: {
        'facebook': 'https://facebook.com/heliopolisaquavet.demo',
        'youtube': 'https://youtube.com/@heliopolisaquavetdemo',
      },
      mapUrl: 'https://maps.google.com/?q=30.0910,31.3220',
    ),
    VetModel(
      id: 'vet_4',
      nameEn: 'Dr. Nada Abdelrahman',
      nameAr: 'د. ندى عبد الرحمن',
      clinicEn: 'Coral Reef Mobile Vet',
      clinicAr: 'عيادة كورال ريف المتنقلة',
      specialtyEn: 'Home tank visits, Betta & koi care',
      specialtyAr: 'زيارات منزلية للأحواض، رعاية البيتا والكوي',
      areaEn: 'New Cairo',
      areaAr: 'القاهرة الجديدة',
      imageAsset: 'assets/images/vets/vet_4.jpg',
      bioEn:
          'Provides on-site aquarium checkups, filter setup reviews, and pond koi consultations.',
      bioAr:
          'تقدم فحوصات منزلية للأحواض، مراجعة الفلاتر، واستشارات رعاية أسماك الكوي والبيتا.',
      whatsapp: 'https://wa.me/201500007788',
      socialLinks: {
        'instagram': 'https://instagram.com/coralreefvet.demo',
        'x': 'https://x.com/coralreefvetdemo',
      },
    ),
  ];
}
