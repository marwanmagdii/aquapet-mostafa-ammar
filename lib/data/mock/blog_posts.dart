import '../models/blog_post.dart';

/// Local mock articles for the Care Blog & Guides feature.
abstract final class MockBlogData {
  static final List<BlogPost> posts = [
    BlogPost(
      id: 'blog_cycle_tank',
      titleEn: 'Cycling Your First Freshwater Tank',
      titleAr: 'تجهيز الدورة البيولوجية لأول حوض مياه عذبة',
      summaryEn:
          'Why waiting 7–14 days with beneficial bacteria keeps your new fish healthy and stress-free.',
      summaryAr:
          'لماذا يساعد الانتظار ٧-١٤ يوماً مع البكتيريا النافعة على حماية أسماكك الجديدة من الإجهاد.',
      bodyEn:
          'Before adding fish to a brand-new aquarium, beneficial nitrifying bacteria need time to colonize your filter media. Start by filling the tank with dechlorinated water using AquaSafe Water Conditioner, turn on your filter and heater, and dose BioStart Beneficial Bacteria.\n\nTest the water with 6-in-1 strips every few days until ammonia and nitrite read zero. Once parameters stabilize, introduce hardy fish gradually—just 2 to 3 fish at first—so the biological filter adapts smoothly.',
      bodyAr:
          'قبل إضافة الأسماك إلى حوض جديد، تحتاج البكتيريا النافعة إلى وقت لتستقر داخل الفلتر. ابدأ بملء الحوض بماء معالج بمزيل الكلور، وشغّل الفلتر والسخان، ثم أضف البكتيريا النافعة.\n\nافحص الماء بشرائط الفحص كل بضعة أيام حتى تصل نسبة الأمونيا والنيتريت إلى الصفر. عند استقرار القراءات، أضف الأسماك تدريجياً (٢ إلى ٣ أسماك في البداية) ليعتاد الفلتر على الحمل الحيوي.',
      categoryEn: 'Beginner Guide',
      categoryAr: 'دليل المبتدئين',
      readMinutes: 4,
      publishedAt: DateTime(2026, 11, 10),
      imageUrl:
          'https://images.unsplash.com/photo-1691387896833-dba10ea7d614?fm=jpg&q=80&w=600&auto=format&fit=crop',
      authorName: 'Dr. Karim El-Sayed',
      relatedProductIds: const [
        'care_prime_conditioner',
        'care_beneficial_bacteria',
        'care_test_strips',
      ],
    ),
    BlogPost(
      id: 'blog_betta_feeding',
      titleEn: 'How to Feed Betta Fish Without Overfeeding',
      titleAr: 'كيف تطعم سمكة البيتا بدون إفراط',
      summaryEn:
          'A Betta stomach is roughly the size of its eye—here is the daily portion routine.',
      summaryAr:
          'حجم معدة سمكة البيتا يعادل تقريباً حجم عينها—إليك الروتين اليومي المثالي للكمية.',
      bodyEn:
          'Overfeeding is the #1 cause of cloudy water and swim bladder stress in Betta tanks. Offer 3 to 4 high-protein floating pellets twice a day, and remove any uneaten food after 2 minutes.\n\nOnce a week, give your Betta a gentle fasting day to support healthy digestion, and offer freeze-dried bloodworms as an occasional treat.',
      bodyAr:
          'الإفراط في الطعام هو السبب الأول لتعكر المياه ومشاكل العوم لدى سمكة البيتا. قدّم ٣ إلى ٤ حبيبات طافية عالية البروتين مرتين يومياً، وأزل أي بقايا بعد دقيقتين.\n\nخصص يوماً واحداً أسبوعياً للراحة الهضمية، وقدّم الديدان المجففة كمكافأة أسبوعية.',
      categoryEn: 'Feeding',
      categoryAr: 'التغذية',
      readMinutes: 3,
      publishedAt: DateTime(2026, 11, 8),
      imageUrl:
          'https://images.pexels.com/photos/17984109/pexels-photo-17984109/free-photo-of-photo-of-an-exotic-blue-fish-against-black-background.jpeg?cs=tinysrgb&dpr=1&w=500',
      authorName: 'AquaPet Care Team',
      relatedProductIds: const [
        'food_betta_bio_gold',
        'food_freeze_dried_bloodworms',
        'fish_betta_halfmoon',
      ],
    ),
    BlogPost(
      id: 'blog_water_change',
      titleEn: 'Weekly 25% Water Change Checklist',
      titleAr: 'قائمة التغيير الأسبوعي لـ ٢٥٪ من ماء الحوض',
      summaryEn:
          'Keep crystal-clear water and thriving fish in 10 minutes every week.',
      summaryAr:
          'حافظ على صفاء المياه وصحة الأسماك خلال ١٠ دقائق فقط كل أسبوع.',
      bodyEn:
          'Regular partial water changes remove nitrates and replenish essential minerals without disturbing your beneficial bacteria:\n\n1. Unplug your heater and filter.\n2. Siphon 25% of tank water while lightly vacuuming substrate debris.\n3. Match the replacement tap water temperature to the tank.\n4. Dose Water Conditioner before pouring into the aquarium.\n5. Rinse filter sponges in the removed old tank water—never under tap water.',
      bodyAr:
          'يساعد التغيير الجزئي المنتظم على إزالة النترات وتجديد المعادن دون الإضرار بالبكتيريا النافعة:\n\n١. افصل السخان والفلتر.\n٢. اسحب ٢٥٪ من ماء الحوض مع تنظيف القاع بلطف.\n٣. طابق درجة حرارة الماء الجديد مع ماء الحوض.\n٤. أضف مزيل الكلور قبل صب الماء.\n٥. اشطف إسفنجة الفلتر في ماء الحوض القديم وليس بماء الصنبور.',
      categoryEn: 'Water Care',
      categoryAr: 'عناية المياه',
      readMinutes: 5,
      publishedAt: DateTime(2026, 11, 5),
      imageUrl:
          'https://images.unsplash.com/photo-1784766029024-fe0adb02c313?fm=jpg&q=80&w=600&auto=format&fit=crop',
      authorName: 'Dr. Salma Mansour',
      relatedProductIds: const [
        'care_prime_conditioner',
        'filter_hob_quiet',
        'care_test_strips',
      ],
    ),
    BlogPost(
      id: 'blog_neon_tetra_mates',
      titleEn: 'Peaceful Tankmates for Neon Tetras',
      titleAr: 'أفضل الأسماك المسالمة للعيش مع النيون تترا',
      summaryEn:
          'Build a calm, colorful community aquarium with compatible freshwater species.',
      summaryAr:
          'كوّن حوضاً جماعياً هادئاً ومتناغماً بأنواع متوافقة من أسماك المياه العذبة.',
      bodyEn:
          'Neon Tetras shine brightest in groups of 6 or more inside planted aquariums. Pair them with peaceful bottom-dwellers like Panda Corydoras Catfish and active Tuxedo Koi Guppies.\n\nAvoid large aggressive cichlids or fin-nippers, and provide driftwood and live Anubias plants for natural shade.',
      bodyAr:
          'تتألق أسماك النيون تترا عند تربيتها في أسراب من ٦ أسماك فأكثر داخل الأحواض المزروعة. يمكنك دمجها مع أسماك القاع المسالمة مثل الباندا كوريدوراس والجوبي.\n\nتجنب الأسماك العدوانية، ووفر قطع خشب ونبات الأنوبياس كأماكن للاختباء.',
      categoryEn: 'Fish Health',
      categoryAr: 'صحة الأسماك',
      readMinutes: 3,
      publishedAt: DateTime(2026, 11, 2),
      imageUrl:
          'https://images.pexels.com/photos/36851956/pexels-photo-36851956/free-photo-of-vivid-aquarium-with-neon-tetras-in-natural-setup.jpeg?cs=tinysrgb&dpr=1&w=500',
      authorName: 'AquaPet Care Team',
      relatedProductIds: const [
        'fish_neon_tetra',
        'fish_corydoras',
        'food_tetramin_flakes',
      ],
    ),
    BlogPost(
      id: 'blog_low_tech_plants',
      titleEn: 'Easy Live Plants Without CO2 Injection',
      titleAr: 'نباتات مائية سهلة بدون ثاني أكسيد كربون',
      summaryEn:
          'Anubias and Java Fern thrive under standard LED lighting and help absorb nitrates.',
      summaryAr:
          'ينمو الأنوبياس والجافا فيرن بسهولة تحت إضاءة LED العادية ويساعدان على تنقية الماء.',
      bodyEn:
          'You do not need expensive CO2 cylinders to enjoy a lush green aquarium. Both Anubias Nana and Java Fern absorb nutrients directly from the water column.\n\nSimply attach them to driftwood or smooth rocks—never bury their rhizomes in sand—and run your LED bar 6 to 8 hours per day.',
      bodyAr:
          'لا تحتاج إلى أسطوانات ثاني أكسيد كربون مكلفة للاستمتاع بحوض أخضر طبيعي. يمتص نبات الأنوبياس والجافا فيرن العناصر الغذائية مباشرة من الماء.\n\nثبّتهما على الخشب الطبيعي أو الصخور دون دفن الجذور الرئيسية في الرمل، وشغّل إضاءة LED من ٦ إلى ٨ ساعات يومياً.',
      categoryEn: 'Plants',
      categoryAr: 'النباتات',
      readMinutes: 4,
      publishedAt: DateTime(2026, 10, 28),
      imageUrl:
          'https://images.pexels.com/photos/34956144/pexels-photo-34956144/free-photo-of-close-up-of-green-aquatic-plant-on-driftwood.jpeg?cs=tinysrgb&dpr=1&w=500',
      authorName: 'Dr. Nada Abdelrahman',
      relatedProductIds: const [
        'decor_anubias_driftwood',
        'decor_java_fern',
        'tank_led_light',
      ],
    ),
  ];
}
