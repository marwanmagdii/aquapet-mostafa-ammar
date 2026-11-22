import '../models/cart_order.dart';
import '../models/coupon.dart';
import '../models/loyalty.dart';
import '../models/product.dart';
import '../models/reminder_tank.dart';
import '../models/user_profile.dart';

/// Complete offline mock catalog:
/// - 30 products across all 6 categories (AR/EN, EGP, variants, stock)
/// - 6 coupons, 8 rewards, 3 past orders, 1 sample tank, initial reminders
abstract final class MockCatalogData {
  static const List<Product> products = [
    // ── FISH (6) ──────────────────────────────────────────────────────────
    Product(
      id: 'fish_betta_halfmoon',
      imageUrl: 'https://images.pexels.com/photos/17984109/pexels-photo-17984109/free-photo-of-photo-of-an-exotic-blue-fish-against-black-background.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Halfmoon Betta (Ocean Blue)',
      nameAr: 'سمكة بيتا هاف مون (أزرق محيطي)',
      descriptionEn:
          'Vibrant solitary freshwater fighter fish with full 180-degree caudal fin spread.',
      descriptionAr:
          'سمكة مياه عذبة زاهية بزعنفة ذيل كاملة ١٨٠ درجة، مثالية للأحواض الفردية.',
      careTipsEn:
          'Keep solo in 15L+ heated tank (25–27°C) with gentle filtration and resting leaves.',
      careTipsAr:
          'تُربى منفردة في حوض ١٥ لتر فأكثر بدرجة حرارة ٢٥-٢٧ مئوية وفلتر هادئ.',
      category: ProductCategory.fish,
      isBestSeller: true,
      isLiveFish: true,
      iconKey: 'fish',
      gradientHexes: [0xFF0D9488, 0xFF0891B2],
      variants: [
        ProductVariant(
          id: 'v_betta_m',
          labelEn: 'Male (1 fish)',
          labelAr: 'ذكر (سمكة واحدة)',
          priceEgp: 280,
          stock: 8,
        ),
        ProductVariant(
          id: 'v_betta_f',
          labelEn: 'Female (1 fish)',
          labelAr: 'أنثى (سمكة واحدة)',
          priceEgp: 220,
          stock: 5,
        ),
      ],
    ),
    Product(
      id: 'fish_neon_tetra',
      imageUrl: 'https://images.pexels.com/photos/36851956/pexels-photo-36851956/free-photo-of-vivid-aquarium-with-neon-tetras-in-natural-setup.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Neon Tetra School',
      nameAr: 'سرب نيون تترا',
      descriptionEn:
          'Peaceful iridescent schooling fish that bring calm movement to planted tanks.',
      descriptionAr:
          'أسماك مسالمة متألقة تعيش في أسراب وتضفي حركة هادئة على الأحواض المزروعة.',
      careTipsEn:
          'Keep in groups of 6+ in well-cycled 40L+ freshwater tanks (22–26°C).',
      careTipsAr:
          'تُربى في مجموعات من ٦ أسماك فأكثر داخل حوض ٤٠ لتر فأكثر.',
      category: ProductCategory.fish,
      isBestSeller: true,
      isLiveFish: true,
      iconKey: 'fish',
      gradientHexes: [0xFF0284C7, 0xFF0D9488],
      variants: [
        ProductVariant(
          id: 'v_tetra_6',
          labelEn: 'Pack of 6',
          labelAr: 'مجموعة ٦ أسماك',
          priceEgp: 240,
          stock: 14,
        ),
        ProductVariant(
          id: 'v_tetra_10',
          labelEn: 'Pack of 10',
          labelAr: 'مجموعة ١٠ أسماك',
          priceEgp: 370,
          stock: 9,
        ),
      ],
    ),
    Product(
      id: 'fish_guppy_tuxedo',
      imageUrl: 'https://images.pexels.com/photos/36426327/pexels-photo-36426327/free-photo-of-vibrant-aquarium-with-colorful-guppies-swimming.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Tuxedo Koi Guppy Pair',
      nameAr: 'زوج جوبي تاكسيدو كوي',
      descriptionEn:
          'Hardy, active livebearer with bright coral-orange tail accents.',
      descriptionAr:
          'أسماك نشيطة وسهلة التربية بألوان برتقالية مرجانية جذابة.',
      careTipsEn:
          'Ideal for beginners; thrives in 24–26°C hard freshwater.',
      careTipsAr:
          'مثالية للمبتدئين، تعيش بسهولة في حرارة ٢٤-٢٦ مئوية.',
      category: ProductCategory.fish,
      isNewArrival: true,
      isLiveFish: true,
      iconKey: 'fish',
      gradientHexes: [0xFFEA580C, 0xFF0D9488],
      variants: [
        ProductVariant(
          id: 'v_guppy_pair',
          labelEn: '1 Pair (M+F)',
          labelAr: 'زوج (ذكر وأنثى)',
          priceEgp: 160,
          stock: 12,
        ),
      ],
    ),
    Product(
      id: 'fish_corydoras',
      imageUrl: 'https://images.pexels.com/photos/32224426/pexels-photo-32224426/free-photo-of-close-up-of-corydoras-fish-in-aquarium-habitat.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Panda Corydoras Catfish',
      nameAr: 'باندا كوريدوراس (منظف القاع)',
      descriptionEn:
          'Gentle bottom-dwelling scavenger that keeps sand substrate clean.',
      descriptionAr:
          'سمكة قاع لطيفة تساعد على تنظيف الرمال وبقايا الطعام.',
      careTipsEn:
          'Use smooth sand substrate to protect barbels; keep 3+ together.',
      careTipsAr:
          'استخدم رمالاً ناعمة لحماية شواربها ويفضل تربية ٣ معاً.',
      category: ProductCategory.fish,
      isLiveFish: true,
      iconKey: 'fish',
      gradientHexes: [0xFF0F766E, 0xFF14B8A6],
      variants: [
        ProductVariant(
          id: 'v_cory_1',
          labelEn: 'Single',
          labelAr: 'سمكة واحدة',
          priceEgp: 145,
          stock: 10,
        ),
        ProductVariant(
          id: 'v_cory_3',
          labelEn: 'Trio (3 fish)',
          labelAr: '٣ أسماك',
          priceEgp: 390,
          stock: 6,
        ),
      ],
    ),
    Product(
      id: 'fish_angelfish',
      imageUrl: 'https://images.pexels.com/photos/25798734/pexels-photo-25798734/free-photo-of-freshwater-aquarium-with-angelfish-and-plants.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Koi Angelfish',
      nameAr: 'سمكة أنجل كوي',
      descriptionEn:
          'Graceful tall-bodied centerpiece fish with white, black, and amber marbling.',
      descriptionAr:
          'سمكة أنيقة مميزة للحوض الرئيسي بألوان الأبيض والأسود والعنبري.',
      careTipsEn:
          'Needs tall 80L+ tank; avoid fin-nippers and tiny fry.',
      careTipsAr:
          'تحتاج حوضاً مرتفعاً سعة ٨٠ لتر فأكثر بعيداً عن الأسماك المشاكسة.',
      category: ProductCategory.fish,
      isLiveFish: true,
      iconKey: 'fish',
      gradientHexes: [0xFFD97706, 0xFF0E7490],
      variants: [
        ProductVariant(
          id: 'v_angel_m',
          labelEn: 'Medium (6 cm)',
          labelAr: 'حجم وسط (٦ سم)',
          priceEgp: 210,
          stock: 7,
        ),
      ],
    ),
    Product(
      id: 'fish_clownfish',
      imageUrl: 'https://images.unsplash.com/photo-1535591273668-578e31182c4f?fm=jpg&q=80&w=600&auto=format&fit=crop',
      nameEn: 'Ocellaris Clownfish',
      nameAr: 'سمكة المهرج (نيمو)',
      descriptionEn:
          'Captive-bred saltwater reef favorite, hardy and peaceful.',
      descriptionAr:
          'سمكة مياه مالحة محبوبة ومولودة في الأحواض، هادئة وسهلة التكيف.',
      careTipsEn:
          'Requires cycled marine tank (SG 1.024–1.026, 25°C).',
      careTipsAr:
          'تحتاج حوض مياه مالحة مستقر بملوحة ١.٠٢٤-١.٠٢٦ وحرارة ٢٥ مئوية.',
      category: ProductCategory.fish,
      isNewArrival: true,
      isLiveFish: true,
      waterType: 'salt',
      iconKey: 'fish',
      gradientHexes: [0xFFF97316, 0xFF0284C7],
      variants: [
        ProductVariant(
          id: 'v_clown_1',
          labelEn: 'Captive-Bred (1 fish)',
          labelAr: 'سمكة واحدة',
          priceEgp: 650,
          stock: 4,
        ),
      ],
    ),

    // ── FISH FOOD (6, all with grams for smart reminders) ─────────────────
    Product(
      id: 'food_tetramin_flakes',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5b/Aquarium_-_dried_food.jpg',
      nameEn: 'TetraMin Tropical Flakes',
      nameAr: 'رقائق تترامين للأسماك الاستوائية',
      descriptionEn:
          'Complete daily nutrition flakes for all tropical community fish without clouding water.',
      descriptionAr:
          'تغذية يومية متكاملة لجميع أسماك الزينة الاستوائية دون تعكير المياه.',
      careTipsEn:
          'Feed 1–2 times daily only what fish finish within 2 minutes.',
      careTipsAr:
          'أطعم الأسماك مرة إلى مرتين يومياً بكمية تُنهى خلال دقيقتين.',
      category: ProductCategory.food,
      isBestSeller: true,
      iconKey: 'food',
      gradientHexes: [0xFF0D9488, 0xFFD97706],
      variants: [
        ProductVariant(
          id: 'v_tetra_100',
          labelEn: '100 g',
          labelAr: '١٠٠ جم',
          priceEgp: 140,
          grams: 100,
          stock: 22,
        ),
        ProductVariant(
          id: 'v_tetra_250',
          labelEn: '250 g',
          labelAr: '٢٥٠ جم',
          priceEgp: 260,
          grams: 250,
          stock: 15,
        ),
        ProductVariant(
          id: 'v_tetra_500',
          labelEn: '500 g',
          labelAr: '٥٠٠ جم',
          priceEgp: 440,
          grams: 500,
          stock: 10,
        ),
      ],
    ),
    Product(
      id: 'food_hikari_pellets',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/3-Colour_Fish_Food.jpg/600px-3-Colour_Fish_Food.jpg',
      nameEn: 'Hikari Tropical Micro Pellets',
      nameAr: 'حبيبات هيكاري ميكرو الاستوائية',
      descriptionEn:
          'Slow-sinking micro pellets rich in spirulina and krill for vivid natural colors.',
      descriptionAr:
          'حبيبات دقيقة بطيئة الغوص غنية بالسبيرولينا والكريل لإبراز الألوان.',
      careTipsEn:
          'Ideal for tetras, rasboras, and small livebearers.',
      careTipsAr:
          'مثالية لأسماك التترا والجوبي والأسماك الصغيرة.',
      category: ProductCategory.food,
      isBestSeller: true,
      iconKey: 'food',
      gradientHexes: [0xFF0891B2, 0xFFEA580C],
      variants: [
        ProductVariant(
          id: 'v_hikari_100',
          labelEn: '100 g',
          labelAr: '١٠٠ جم',
          priceEgp: 185,
          grams: 100,
          stock: 18,
        ),
        ProductVariant(
          id: 'v_hikari_500',
          labelEn: '500 g',
          labelAr: '٥٠٠ جم',
          priceEgp: 690,
          grams: 500,
          stock: 7,
        ),
        ProductVariant(
          id: 'v_hikari_1000',
          labelEn: '1 kg',
          labelAr: '١ كجم',
          priceEgp: 1180,
          grams: 1000,
          stock: 4,
        ),
      ],
    ),
    Product(
      id: 'food_betta_bio_gold',
      imageUrl: 'https://images.pexels.com/photos/2564496/pexels-photo-2564496.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Betta Bio-Gold Floating Pellets',
      nameAr: 'حبيبات بيو جولد لأسماك البيتا',
      descriptionEn:
          'High-protein floating pellets specially sized for Betta mouths.',
      descriptionAr:
          'حبيبات طافية عالية البروتين بحجم مناسب لفم سمكة البيتا.',
      careTipsEn:
          'Feed 3–4 pellets twice daily; skip one day per week for digestion.',
      careTipsAr:
          'أطعم ٣-٤ حبيبات مرتين يومياً مع يوم صيام أسبوعياً.',
      category: ProductCategory.food,
      iconKey: 'food',
      gradientHexes: [0xFF0F766E, 0xFF0284C7],
      variants: [
        ProductVariant(
          id: 'v_betta_50',
          labelEn: '50 g',
          labelAr: '٥٠ جم',
          priceEgp: 120,
          grams: 50,
          stock: 25,
        ),
        ProductVariant(
          id: 'v_betta_150',
          labelEn: '150 g',
          labelAr: '١٥٠ جم',
          priceEgp: 290,
          grams: 150,
          stock: 12,
        ),
      ],
    ),
    Product(
      id: 'food_spirulina_wafers',
      imageUrl: 'https://images.unsplash.com/photo-1754848128322-7f0980d9e914?fm=jpg&q=80&w=600&auto=format&fit=crop',
      nameEn: 'Algae & Spirulina Sinking Wafers',
      nameAr: 'أقراص السبيرولينا الغاطسة',
      descriptionEn:
          'Nutrient-dense sinking wafers for Corydoras, plecos, and shrimp.',
      descriptionAr:
          'أقراص غاطسة غنية بالطحالب لأسماك القاع والجمبري.',
      careTipsEn:
          'Drop 1 wafer per 3 bottom-dwellers after lights dim.',
      careTipsAr:
          'ضع قرصاً واحداً لكل ٣ أسماك قاع بعد خفوت الإضاءة.',
      category: ProductCategory.food,
      isNewArrival: true,
      iconKey: 'food',
      gradientHexes: [0xFF059669, 0xFF0D9488],
      variants: [
        ProductVariant(
          id: 'v_wafer_100',
          labelEn: '100 g',
          labelAr: '١٠٠ جم',
          priceEgp: 165,
          grams: 100,
          stock: 16,
        ),
        ProductVariant(
          id: 'v_wafer_250',
          labelEn: '250 g',
          labelAr: '٢٥٠ جم',
          priceEgp: 340,
          grams: 250,
          stock: 9,
        ),
      ],
    ),
    Product(
      id: 'food_freeze_dried_bloodworms',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5b/Aquarium_-_dried_food.jpg',
      nameEn: 'Freeze-Dried Bloodworms Treat',
      nameAr: 'ديدان مجففة بالتجميد (مكافأة)',
      descriptionEn:
          'Clean, parasite-free high-protein treat for picky eaters and conditioning.',
      descriptionAr:
          'وجبة مكافأة عالية البروتين خالية من الطفيليات للأسماك الانتقائية.',
      careTipsEn:
          'Offer 2–3 times weekly as a supplement alongside staple pellets.',
      careTipsAr:
          'تُقدم ٢-٣ مرات أسبوعياً كمكمل بجانب الطعام الأساسي.',
      category: ProductCategory.food,
      iconKey: 'food',
      gradientHexes: [0xFFDC2626, 0xFFF97316],
      variants: [
        ProductVariant(
          id: 'v_bw_50',
          labelEn: '50 g',
          labelAr: '٥٠ جم',
          priceEgp: 195,
          grams: 50,
          stock: 14,
        ),
        ProductVariant(
          id: 'v_bw_100',
          labelEn: '100 g',
          labelAr: '١٠٠ جم',
          priceEgp: 350,
          grams: 100,
          stock: 8,
        ),
      ],
    ),
    Product(
      id: 'food_marine_pellets',
      imageUrl: 'https://images.pexels.com/photos/12652728/pexels-photo-12652728.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Marine Reef Omega Pellets',
      nameAr: 'حبيبات أوميجا لأسماك الشعاب المالحة',
      descriptionEn:
          'Garlic-enriched marine formula supporting immune health for clownfish & tangs.',
      descriptionAr:
          'تركيبة بحرية غنية بالثوم والأوميجا لدعم مناعة أسماك المياه المالحة.',
      careTipsEn:
          'Feed small pinches twice daily; store sealed away from humidity.',
      careTipsAr:
          'أطعم كمية صغيرة مرتين يومياً واحفظ العبوة محكمة الغلق.',
      category: ProductCategory.food,
      waterType: 'salt',
      iconKey: 'food',
      gradientHexes: [0xFF0284C7, 0xFFF97316],
      variants: [
        ProductVariant(
          id: 'v_marine_120',
          labelEn: '120 g',
          labelAr: '١٢٠ جم',
          priceEgp: 320,
          grams: 120,
          stock: 11,
        ),
        ProductVariant(
          id: 'v_marine_300',
          labelEn: '300 g',
          labelAr: '٣٠٠ جم',
          priceEgp: 680,
          grams: 300,
          stock: 5,
        ),
      ],
    ),

    // ── TANKS & AQUARIUMS (5) ─────────────────────────────────────────────
    Product(
      id: 'tank_rimless_30',
      imageUrl: 'https://images.unsplash.com/photo-1691387896833-dba10ea7d614?fm=jpg&q=80&w=600&auto=format&fit=crop',
      nameEn: 'AquaClear Rimless Cube 30L',
      nameAr: 'حوض زجاجي بدون إطار ٣٠ لتر',
      descriptionEn:
          'Low-iron crystal clear glass cube with foam leveling mat.',
      descriptionAr:
          'حوض زجاجي فائق النقاء بدون إطار مع قاعدة فوم عازلة.',
      careTipsEn:
          'Place on a flat, level stand away from direct afternoon sunlight.',
      careTipsAr:
          'يوضع على سطح مستوٍ بعيداً عن أشعة الشمس المباشرة.',
      category: ProductCategory.tanks,
      isBestSeller: true,
      iconKey: 'tank',
      gradientHexes: [0xFF0891B2, 0xFF14B8A6],
      variants: [
        ProductVariant(
          id: 'v_cube_30',
          labelEn: '30 Liters (30x30x35 cm)',
          labelAr: '٣٠ لتر',
          priceEgp: 1450,
          stock: 6,
        ),
      ],
    ),
    Product(
      id: 'tank_starter_60',
      imageUrl: 'https://images.unsplash.com/photo-1784766029024-fe0adb02c313?fm=jpg&q=80&w=600&auto=format&fit=crop',
      nameEn: 'Community Panorama Kit 60L',
      nameAr: 'طقم حوض بانوراما متكامل ٦٠ لتر',
      descriptionEn:
          'Complete 60L glass aquarium with LED hood and built-in top filter.',
      descriptionAr:
          'حوض زجاجي متكامل ٦٠ لتر مع غطاء إضاءة LED وفلتر علوي مدمج.',
      careTipsEn:
          'Cycle with beneficial bacteria for 7–14 days before adding fish.',
      careTipsAr:
          'شغّل الدورة البيولوجية لمدة ٧-١٤ يوماً قبل إضافة الأسماك.',
      category: ProductCategory.tanks,
      isBestSeller: true,
      iconKey: 'tank',
      gradientHexes: [0xFF0D9488, 0xFF0284C7],
      variants: [
        ProductVariant(
          id: 'v_kit_60',
          labelEn: '60 Liters + LED',
          labelAr: '٦٠ لتر + إضاءة LED',
          priceEgp: 2850,
          stock: 4,
        ),
      ],
    ),
    Product(
      id: 'tank_betta_18',
      imageUrl: 'https://images.pexels.com/photos/26611976/pexels-photo-26611976/free-photo-of-aquarium-on-table.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Calm Desktop Betta Tank 18L',
      nameAr: 'حوض مكتب هادئ للبيتا ١٨ لتر',
      descriptionEn:
          'Compact curved-front desktop aquarium with soft daylight LED bar.',
      descriptionAr:
          'حوض مكتبي أنيق بواجهة منحنية وإضاءة نهارية هادئة.',
      careTipsEn:
          'Add a 25W preset heater for winter nights.',
      careTipsAr:
          'أضف سخاناً ٢٥ واط في ليالي الشتاء للحفاظ على دفء الماء.',
      category: ProductCategory.tanks,
      isNewArrival: true,
      iconKey: 'tank',
      gradientHexes: [0xFF14B8A6, 0xFF0E7490],
      variants: [
        ProductVariant(
          id: 'v_betta_18',
          labelEn: '18 Liters',
          labelAr: '١٨ لتر',
          priceEgp: 1150,
          stock: 8,
        ),
      ],
    ),
    Product(
      id: 'tank_pro_120',
      imageUrl: 'https://images.unsplash.com/photo-1764175760902-9cf284d444de?fm=jpg&q=80&w=600&auto=format&fit=crop',
      nameEn: 'OptiClear Aquascape Tank 120L',
      nameAr: 'حوض أكواسكيب احترافي ١٢٠ لتر',
      descriptionEn:
          '8mm rimless ultra-clear glass built for lush planted aquascapes.',
      descriptionAr:
          'زجاج نقي بسماكة ٨ مم مصمم خصيصاً لأحواض النباتات الاحترافية.',
      careTipsEn:
          'Pair with canister filtration and planted substrate.',
      careTipsAr:
          'ينصح باستخدام فلتر خارجي وتربة مغذية للنباتات.',
      category: ProductCategory.tanks,
      iconKey: 'tank',
      gradientHexes: [0xFF0F766E, 0xFF059669],
      variants: [
        ProductVariant(
          id: 'v_pro_120',
          labelEn: '120 Liters (90x40x35 cm)',
          labelAr: '١٢٠ لتر',
          priceEgp: 4600,
          stock: 3,
        ),
      ],
    ),
    Product(
      id: 'tank_led_light',
      imageUrl: 'https://images.unsplash.com/photo-1781695125669-b21426a2bdf3?fm=jpg&q=80&w=600&auto=format&fit=crop',
      nameEn: 'Full-Spectrum Plant LED Bar',
      nameAr: 'إضاءة LED طيف كامل للنباتات',
      descriptionEn:
          'Extendable aluminum LED fixture with sunrise/daylight modes.',
      descriptionAr:
          'كشاف إضاءة ألومنيوم قابل للتمديد لإبراز ألوان الأسماك ونمو النباتات.',
      careTipsEn:
          'Run 6–8 hours daily on a timer to prevent algae blooms.',
      careTipsAr:
          'شغّل الإضاءة ٦-٨ ساعات يومياً لتجنب نمو الطحالب.',
      category: ProductCategory.tanks,
      iconKey: 'tank',
      gradientHexes: [0xFF0284C7, 0xFFD97706],
      variants: [
        ProductVariant(
          id: 'v_led_30',
          labelEn: '30–45 cm',
          labelAr: '٣٠-٤٥ سم',
          priceEgp: 620,
          stock: 11,
        ),
        ProductVariant(
          id: 'v_led_60',
          labelEn: '60–80 cm',
          labelAr: '٦٠-٨٠ سم',
          priceEgp: 890,
          stock: 7,
        ),
      ],
    ),

    // ── FILTERS & PUMPS (5) ───────────────────────────────────────────────
    Product(
      id: 'filter_hob_quiet',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Aquarium_-_external_filter.jpg/600px-Aquarium_-_external_filter.jpg',
      nameEn: 'AquaFlow Hang-On Filter',
      nameAr: 'فلتر شلال هادئ أكوافلو',
      descriptionEn:
          'Whisper-quiet hang-on-back filter with adjustable flow for nano & medium tanks.',
      descriptionAr:
          'فلتر شلال فائق الهدوء مع تحكم في قوة التدفق للأحواض الصغيرة والمتوسطة.',
      careTipsEn:
          'Rinse sponge in old tank water monthly; never wash with tap water.',
      careTipsAr:
          'اشطف الإسفنجة في ماء الحوض القديم شهرياً وليس بماء الصنبور.',
      category: ProductCategory.filters,
      isBestSeller: true,
      iconKey: 'filter',
      gradientHexes: [0xFF0E7490, 0xFF0D9488],
      variants: [
        ProductVariant(
          id: 'v_hob_300',
          labelEn: '300 L/h (up to 50L)',
          labelAr: '٣٠٠ لتر/ساعة',
          priceEgp: 540,
          stock: 13,
        ),
        ProductVariant(
          id: 'v_hob_600',
          labelEn: '600 L/h (up to 120L)',
          labelAr: '٦٠٠ لتر/ساعة',
          priceEgp: 790,
          stock: 9,
        ),
      ],
    ),
    Product(
      id: 'filter_sponge_bio',
      imageUrl: 'https://images.pexels.com/photos/19202473/pexels-photo-19202473/free-photo-of-an-aquarium-illuminated-with-a-lamp.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Dual Bio-Sponge Air Filter',
      nameAr: 'فلتر إسفنجي بيولوجي مزدوج',
      descriptionEn:
          'Gentle shrimp- and fry-safe biological filtration powered by an air pump.',
      descriptionAr:
          'فلتر بيولوجي آمن تماماً للجمبري والزريعة يعمل بمضخة الهواء.',
      careTipsEn:
          'Ideal for Betta, breeding, and shrimp tanks.',
      careTipsAr:
          'مثالي لأحواض البيتا والتفريخ والجمبري.',
      category: ProductCategory.filters,
      iconKey: 'filter',
      gradientHexes: [0xFF0D9488, 0xFF475569],
      variants: [
        ProductVariant(
          id: 'v_sponge_s',
          labelEn: 'Small (up to 40L)',
          labelAr: 'صغير (حتى ٤٠ لتر)',
          priceEgp: 190,
          stock: 20,
        ),
        ProductVariant(
          id: 'v_sponge_l',
          labelEn: 'Large (up to 100L)',
          labelAr: 'كبير (حتى ١٠٠ لتر)',
          priceEgp: 260,
          stock: 14,
        ),
      ],
    ),
    Product(
      id: 'filter_air_pump',
      imageUrl: 'https://images.unsplash.com/photo-1691387747539-f681c5fa73d9?fm=jpg&q=80&w=600&auto=format&fit=crop',
      nameEn: 'SilentWave Dual Air Pump',
      nameAr: 'مضخة هواء صامتة مزدوجة',
      descriptionEn:
          'Rubber-footed ultra-quiet oxygen pump with check valve and airline tubing.',
      descriptionAr:
          'مضخة أكسجين صامتة بقاعدة مطاطية مع صمام أمان وخرطوم هواء.',
      careTipsEn:
          'Keep pump above water level or install included check valve.',
      careTipsAr:
          'ضع المضخة أعلى من مستوى الماء أو ركّب صمام عدم الرجوع.',
      category: ProductCategory.filters,
      iconKey: 'filter',
      gradientHexes: [0xFF0891B2, 0xFF0F766E],
      variants: [
        ProductVariant(
          id: 'v_pump_single',
          labelEn: 'Single Outlet (2W)',
          labelAr: 'مخرج واحد',
          priceEgp: 240,
          stock: 15,
        ),
        ProductVariant(
          id: 'v_pump_dual',
          labelEn: 'Dual Outlet (4W)',
          labelAr: 'مخرجان',
          priceEgp: 360,
          stock: 10,
        ),
      ],
    ),
    Product(
      id: 'filter_heater_quartz',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/82/Aquarium_heater1.jpg',
      nameEn: 'ThermoSafe Quartz Heater',
      nameAr: 'سخان كوارتز أوتوماتيكي',
      descriptionEn:
          'Explosion-resistant quartz glass heater with accurate thermostat dial.',
      descriptionAr:
          'سخان زجاج كوارتز مقاوم للكسر مع منظم حرارة دقيق.',
      careTipsEn:
          'Unplug 15 minutes before removing from water during water changes.',
      careTipsAr:
          'افصل الكهرباء قبل ١٥ دقيقة من إخراجه أثناء تغيير الماء.',
      category: ProductCategory.filters,
      isNewArrival: true,
      iconKey: 'filter',
      gradientHexes: [0xFFEA580C, 0xFF0E7490],
      variants: [
        ProductVariant(
          id: 'v_heat_50',
          labelEn: '50W (20–50L)',
          labelAr: '٥٠ واط',
          priceEgp: 290,
          stock: 12,
        ),
        ProductVariant(
          id: 'v_heat_100',
          labelEn: '100W (50–100L)',
          labelAr: '١٠٠ واط',
          priceEgp: 340,
          stock: 11,
        ),
      ],
    ),
    Product(
      id: 'filter_ceramic_media',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Ceramic_Pot_Filter.JPG',
      nameEn: 'Bio-Ceramic Filter Rings + Carbon',
      nameAr: 'حلقات سيراميك بيولوجية + كربون نشط',
      descriptionEn:
          'Porous ceramic bio-media pack in a reusable mesh bag for crystal water.',
      descriptionAr:
          'حلقات سيراميك مسامية في كيس شبكي لتنمية البكتيريا النافعة ونقاء الماء.',
      careTipsEn:
          'Replace activated carbon every 4–6 weeks; keep ceramic rings long-term.',
      careTipsAr:
          'غيّر الكربون النشط كل ٤-٦ أسابيع واحتفظ بحلقات السيراميك.',
      category: ProductCategory.filters,
      iconKey: 'filter',
      gradientHexes: [0xFF475569, 0xFF0D9488],
      variants: [
        ProductVariant(
          id: 'v_media_500',
          labelEn: '500 g Pack',
          labelAr: 'عبوة ٥٠٠ جم',
          priceEgp: 175,
          stock: 18,
        ),
      ],
    ),

    // ── WATER CARE & MEDICINE (4) ─────────────────────────────────────────
    Product(
      id: 'care_prime_conditioner',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/94/2_oz_-_60_ml_Amber_Glass_Boston_Round_Bottles_with_Gold_Metal_and_Glass_Droppers.jpg',
      nameEn: 'AquaSafe Water Conditioner',
      nameAr: 'مزيل الكلور ومعالج المياه أكواسيف',
      descriptionEn:
          'Instantly neutralizes chlorine, chloramines, and heavy metals in tap water.',
      descriptionAr:
          'يزيل الكلور والكلورامين والمعادن الثقيلة من ماء الصنبور فوراً.',
      careTipsEn:
          'Dose 5 ml per 40L whenever adding fresh tap water.',
      careTipsAr:
          'أضف ٥ مل لكل ٤٠ لتر عند كل تغيير للمياه.',
      category: ProductCategory.waterCare,
      isBestSeller: true,
      iconKey: 'waterCare',
      gradientHexes: [0xFF0284C7, 0xFF14B8A6],
      variants: [
        ProductVariant(
          id: 'v_cond_100',
          labelEn: '100 ml',
          labelAr: '١٠٠ مل',
          priceEgp: 160,
          stock: 25,
        ),
        ProductVariant(
          id: 'v_cond_250',
          labelEn: '250 ml',
          labelAr: '٢٥٠ مل',
          priceEgp: 310,
          stock: 14,
        ),
      ],
    ),
    Product(
      id: 'care_beneficial_bacteria',
      imageUrl: 'https://images.unsplash.com/photo-1578313097818-dfe8d38aa758?fm=jpg&q=80&w=600&auto=format&fit=crop',
      nameEn: 'BioStart Beneficial Bacteria',
      nameAr: 'بكتيريا نافعة لتدوير الحوض',
      descriptionEn:
          'Concentrated live nitrifying bacteria to cycle new tanks and reduce ammonia.',
      descriptionAr:
          'بكتيريا حية مركزة لتسريع الدورة البيولوجية وتقليل الأمونيا.',
      careTipsEn:
          'Shake well and dose after water changes or filter cleaning.',
      careTipsAr:
          'رجّ العبوة جيداً وأضفها بعد تغيير الماء أو تنظيف الفلتر.',
      category: ProductCategory.waterCare,
      iconKey: 'waterCare',
      gradientHexes: [0xFF059669, 0xFF0891B2],
      variants: [
        ProductVariant(
          id: 'v_bac_100',
          labelEn: '100 ml',
          labelAr: '١٠٠ مل',
          priceEgp: 210,
          stock: 16,
        ),
        ProductVariant(
          id: 'v_bac_250',
          labelEn: '250 ml',
          labelAr: '٢٥٠ مل',
          priceEgp: 420,
          stock: 8,
        ),
      ],
    ),
    Product(
      id: 'care_ich_remedy',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/94/2_oz_-_60_ml_Amber_Glass_Boston_Round_Bottles_with_Gold_Metal_and_Glass_Droppers.jpg',
      nameEn: 'Herbal Ich & Fin Care Remedy',
      nameAr: 'علاج النقط البيضاء وتعفن الزعانف',
      descriptionEn:
          'Plant-safe gentle treatment for white spot, fin stress, and external parasites.',
      descriptionAr:
          'علاج لطيف وآمن للنباتات ضد النقط البيضاء وإجهاد الزعانف.',
      careTipsEn:
          'Remove activated carbon from filter during 5-day treatment.',
      careTipsAr:
          'أزل الكربون النشط من الفلتر خلال فترة العلاج (٥ أيام).',
      category: ProductCategory.waterCare,
      iconKey: 'waterCare',
      gradientHexes: [0xFF0F766E, 0xFFD97706],
      variants: [
        ProductVariant(
          id: 'v_ich_100',
          labelEn: '100 ml',
          labelAr: '١٠٠ مل',
          priceEgp: 230,
          stock: 10,
        ),
      ],
    ),
    Product(
      id: 'care_test_strips',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/2022_container_of_6_in_1_water_testing_strips_by_Tetra_GmbH_Germany.jpg/600px-2022_container_of_6_in_1_water_testing_strips_by_Tetra_GmbH_Germany.jpg',
      nameEn: '6-in-1 Water Test Strips (50 pcs)',
      nameAr: 'شرائط فحص المياه ٦ في ١ (٥٠ شريط)',
      descriptionEn:
          'Fast 60-second check for pH, Nitrite, Nitrate, GH, KH, and Chlorine.',
      descriptionAr:
          'فحص سريع خلال ٦٠ ثانية للحموضة والنيتريت والنيترات والكلور.',
      careTipsEn:
          'Test weekly before water changes; keep tube tightly sealed.',
      careTipsAr:
          'افحص الماء أسبوعياً قبل التغيير واحفظ العلبة مغلقة بإحكام.',
      category: ProductCategory.waterCare,
      isNewArrival: true,
      iconKey: 'waterCare',
      gradientHexes: [0xFF0891B2, 0xFF059669],
      variants: [
        ProductVariant(
          id: 'v_strips_50',
          labelEn: '50 Strips',
          labelAr: '٥٠ شريط',
          priceEgp: 275,
          stock: 13,
        ),
      ],
    ),

    // ── DECOR & PLANTS (4) ────────────────────────────────────────────────
    Product(
      id: 'decor_anubias_driftwood',
      imageUrl: 'https://images.pexels.com/photos/34956144/pexels-photo-34956144/free-photo-of-close-up-of-green-aquatic-plant-on-driftwood.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Anubias Nana on Driftwood',
      nameAr: 'نبات أنوبياس نانا على خشب طبيعي',
      descriptionEn:
          'Hardy, low-light live aquatic plant already anchored to natural driftwood.',
      descriptionAr:
          'نبات مائي حي قليل المتطلبات مثبت مسبقاً على قطعة خشب طبيعية.',
      careTipsEn:
          'Keep rhizome above substrate; thrives in low-to-medium LED light.',
      careTipsAr:
          'لا تدفن الجذور الرئيسية في الرمل، ينمو جيداً في الإضاءة الهادئة.',
      category: ProductCategory.decor,
      isBestSeller: true,
      iconKey: 'decor',
      gradientHexes: [0xFF059669, 0xFF0F766E],
      variants: [
        ProductVariant(
          id: 'v_anubias_s',
          labelEn: 'Small Piece',
          labelAr: 'قطعة صغيرة',
          priceEgp: 240,
          stock: 9,
        ),
        ProductVariant(
          id: 'v_anubias_m',
          labelEn: 'Medium Piece',
          labelAr: 'قطعة متوسطة',
          priceEgp: 380,
          stock: 5,
        ),
      ],
    ),
    Product(
      id: 'decor_java_fern',
      imageUrl: 'https://images.unsplash.com/photo-1779436853149-2e7d501f71cf?fm=jpg&q=80&w=600&auto=format&fit=crop',
      nameEn: 'Java Fern Bundle (Live Plant)',
      nameAr: 'باقة نبات جافا فيرن الحي',
      descriptionEn:
          'Lush green beginner-friendly aquatic fern that oxygenates water naturally.',
      descriptionAr:
          'نبات أخضر كثيف سهل العناية ينقي الماء ويوفر مخبأً للأسماك.',
      careTipsEn:
          'Attach to rocks or wood with thread; no CO2 required.',
      careTipsAr:
          'يُربط على الصخور أو الأخشاب ولا يحتاج ثاني أكسيد كربون.',
      category: ProductCategory.decor,
      iconKey: 'decor',
      gradientHexes: [0xFF10B981, 0xFF0D9488],
      variants: [
        ProductVariant(
          id: 'v_java_1',
          labelEn: '1 Potted Bundle',
          labelAr: 'باقة واحدة',
          priceEgp: 130,
          stock: 17,
        ),
      ],
    ),
    Product(
      id: 'decor_river_sand',
      imageUrl: 'https://images.pexels.com/photos/35337861/pexels-photo-35337861/free-photo-of-colorful-aquarium-fish-and-snail-on-sandy-bed.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Natural River Quartz Sand',
      nameAr: 'رمال نهرية طبيعية ناعمة',
      descriptionEn:
          'Pre-washed smooth pale beige river sand safe for Corydoras and plants.',
      descriptionAr:
          'رمال نهرية مغسولة ناعمة بلون طبيعي آمنة لأسماك القاع والنباتات.',
      careTipsEn:
          'Give a quick rinse before pouring; 5 kg covers a 40–60L tank.',
      careTipsAr:
          'اشطفها سريعاً قبل الاستخدام؛ ٥ كجم تكفي حوض ٤٠-٦٠ لتر.',
      category: ProductCategory.decor,
      iconKey: 'decor',
      gradientHexes: [0xFFD97706, 0xFF0D9488],
      variants: [
        ProductVariant(
          id: 'v_sand_5',
          labelEn: '5 kg Bag',
          labelAr: 'كيس ٥ كجم',
          priceEgp: 150,
          stock: 20,
        ),
        ProductVariant(
          id: 'v_sand_10',
          labelEn: '10 kg Bag',
          labelAr: 'كيس ١٠ كجم',
          priceEgp: 270,
          stock: 11,
        ),
      ],
    ),
    Product(
      id: 'decor_ceramic_cave',
      imageUrl: 'https://images.pexels.com/photos/28905726/pexels-photo-28905726/free-photo-of-pile-of-smooth-gray-pebbles-for-landscaping.jpeg?cs=tinysrgb&dpr=1&w=500',
      nameEn: 'Smooth Granite Hideaway Cave',
      nameAr: 'كهف جرانيت أملس للاختباء',
      descriptionEn:
          'Fish-safe natural-look shelter cave that reduces stress for shy fish.',
      descriptionAr:
          'مخبأ آمن بمظهر صخري طبيعي يقلل التوتر لدى الأسماك الخجولة.',
      careTipsEn:
          'Smooth inner edges protect delicate Betta and Angelfish fins.',
      careTipsAr:
          'حواف داخلية ناعمة تحمي زعانف البيتا والأنجل.',
      category: ProductCategory.decor,
      isNewArrival: true,
      iconKey: 'decor',
      gradientHexes: [0xFF475569, 0xFF0E7490],
      variants: [
        ProductVariant(
          id: 'v_cave_1',
          labelEn: 'Medium Cave',
          labelAr: 'حجم وسط',
          priceEgp: 180,
          stock: 12,
        ),
      ],
    ),
  ];

  static List<CouponModel> initialCoupons(DateTime now) => [
        CouponModel(
          id: 'cpn_welcome10',
          code: 'WELCOME10',
          titleEn: '10% Off Your Order',
          titleAr: 'خصم ١٠٪ على طلبك',
          conditionEn: 'Min. order 150 EGP • Valid on all items',
          conditionAr: 'الحد الأدنى ١٥٠ ج.م • صالح لجميع المنتجات',
          type: CouponType.percent,
          value: 10,
          minOrderEgp: 150,
          expiresAt: now.add(const Duration(days: 45)),
          status: CouponStatus.available,
        ),
        CouponModel(
          id: 'cpn_fish20',
          code: 'FISH20',
          titleEn: '20% Off Aquarium Essentials',
          titleAr: 'خصم ٢٠٪ على مستلزمات الأحواض',
          conditionEn: 'Min. order 300 EGP • Food, plants & filters',
          conditionAr: 'الحد الأدنى ٣٠٠ ج.م • الطعام والنباتات والفلاتر',
          type: CouponType.percent,
          value: 20,
          minOrderEgp: 300,
          expiresAt: now.add(const Duration(days: 30)),
          status: CouponStatus.available,
        ),
        CouponModel(
          id: 'cpn_aqua50',
          code: 'AQUA50',
          titleEn: '50 EGP Instant Discount',
          titleAr: 'خصم فوري ٥٠ ج.م',
          conditionEn: 'Min. order 400 EGP',
          conditionAr: 'الحد الأدنى للطلب ٤٠٠ ج.م',
          type: CouponType.fixed,
          value: 50,
          minOrderEgp: 400,
          expiresAt: now.add(const Duration(days: 20)),
          status: CouponStatus.available,
        ),
        CouponModel(
          id: 'cpn_freefood',
          code: 'FREEFLAKES',
          titleEn: 'Free 100g TetraMin Flakes',
          titleAr: 'رقائق تترامين ١٠٠ جم مجاناً',
          conditionEn: 'Free item value 140 EGP on orders 500+ EGP',
          conditionAr: 'هدية بقيمة ١٤٠ ج.م للطلبات فوق ٥٠٠ ج.م',
          type: CouponType.freeItem,
          value: 140,
          minOrderEgp: 500,
          expiresAt: now.add(const Duration(days: 25)),
          status: CouponStatus.available,
        ),
        CouponModel(
          id: 'cpn_used1',
          code: 'FIRSTTANK',
          titleEn: '75 EGP Off First Tank',
          titleAr: 'خصم ٧٥ ج.م على أول حوض',
          conditionEn: 'Used on Order #AQ-1024',
          conditionAr: 'مستخدم في الطلب #AQ-1024',
          type: CouponType.fixed,
          value: 75,
          minOrderEgp: 500,
          expiresAt: now.add(const Duration(days: 10)),
          status: CouponStatus.used,
        ),
        CouponModel(
          id: 'cpn_expired1',
          code: 'SUMMER15',
          titleEn: '15% Summer Promo',
          titleAr: 'خصم الصيف ١٥٪',
          conditionEn: 'Expired last month',
          conditionAr: 'انتهت صلاحيته الشهر الماضي',
          type: CouponType.percent,
          value: 15,
          minOrderEgp: 200,
          expiresAt: now.subtract(const Duration(days: 14)),
          status: CouponStatus.expired,
        ),
      ];

  static const List<RewardItem> rewards = [
    RewardItem(
      id: 'rw_25egp',
      titleEn: '25 EGP Voucher',
      titleAr: 'قسيمة خصم ٢٥ ج.م',
      subtitleEn: 'Valid on any order 150+ EGP',
      subtitleAr: 'صالحة لأي طلب بقيمة ١٥٠ ج.م فأكثر',
      pointsCost: 250,
      discountEgp: 25,
      isFreeItem: false,
      imageAsset: 'assets/images/products/reward_voucher.jpg',
    ),
    RewardItem(
      id: 'rw_50egp',
      titleEn: '50 EGP Voucher',
      titleAr: 'قسيمة خصم ٥٠ ج.م',
      subtitleEn: 'Valid on any order 250+ EGP',
      subtitleAr: 'صالحة لأي طلب بقيمة ٢٥٠ ج.م فأكثر',
      pointsCost: 500,
      discountEgp: 50,
      isFreeItem: false,
      imageAsset: 'assets/images/products/reward_voucher.jpg',
    ),
    RewardItem(
      id: 'rw_100egp',
      titleEn: '100 EGP Voucher',
      titleAr: 'قسيمة خصم ١٠٠ ج.م',
      subtitleEn: 'Valid on any order 450+ EGP',
      subtitleAr: 'صالحة لأي طلب بقيمة ٤٥٠ ج.م فأكثر',
      pointsCost: 950,
      discountEgp: 100,
      isFreeItem: false,
      imageAsset: 'assets/images/products/reward_voucher.jpg',
    ),
    RewardItem(
      id: 'rw_free_betta_food',
      titleEn: 'Free Betta Bio-Gold (50g)',
      titleAr: 'طعام بيتا بيو جولد ٥٠ جم مجاناً',
      subtitleEn: 'Redeem as a free-item coupon',
      subtitleAr: 'استبدلها كقسيمة منتج مجاني',
      pointsCost: 400,
      discountEgp: 120,
      isFreeItem: true,
      imageAsset: 'assets/images/products/food_betta_bio_gold.svg',
      imageUrl:
          'https://images.pexels.com/photos/2564496/pexels-photo-2564496.jpeg?cs=tinysrgb&dpr=1&w=500',
    ),
    RewardItem(
      id: 'rw_free_flakes',
      titleEn: 'Free TetraMin Flakes (100g)',
      titleAr: 'رقائق تترامين ١٠٠ جم مجاناً',
      subtitleEn: 'Most popular community fish food',
      subtitleAr: 'الطعام الأكثر طلباً لأسماك الزينة',
      pointsCost: 480,
      discountEgp: 140,
      isFreeItem: true,
      imageAsset: 'assets/images/products/food_tetramin_flakes.svg',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/5/5b/Aquarium_-_dried_food.jpg',
    ),
    RewardItem(
      id: 'rw_free_cond',
      titleEn: 'Free Water Conditioner (100ml)',
      titleAr: 'مزيل كلور ١٠٠ مل مجاناً',
      subtitleEn: 'Essential for every water change',
      subtitleAr: 'أساسي مع كل تغيير لمياه الحوض',
      pointsCost: 550,
      discountEgp: 160,
      isFreeItem: true,
      imageAsset: 'assets/images/products/care_prime_conditioner.svg',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/9/94/2_oz_-_60_ml_Amber_Glass_Boston_Round_Bottles_with_Gold_Metal_and_Glass_Droppers.jpg',
    ),
    RewardItem(
      id: 'rw_free_java',
      titleEn: 'Free Java Fern Plant',
      titleAr: 'نبات جافا فيرن حي مجاناً',
      subtitleEn: 'Freshwater live plant bundle',
      subtitleAr: 'باقة نبات مائي طبيعي',
      pointsCost: 450,
      discountEgp: 130,
      isFreeItem: true,
      imageAsset: 'assets/images/products/decor_java_fern.svg',
      imageUrl:
          'https://images.unsplash.com/photo-1779436853149-2e7d501f71cf?fm=jpg&q=80&w=600&auto=format&fit=crop',
    ),
    RewardItem(
      id: 'rw_free_delivery',
      titleEn: 'Free Cairo Delivery Pass',
      titleAr: 'توصيل مجاني داخل القاهرة',
      subtitleEn: 'Covers up to 65 EGP shipping',
      subtitleAr: 'يغطي رسوم التوصيل حتى ٦٥ ج.م',
      pointsCost: 300,
      discountEgp: 65,
      isFreeItem: false,
      imageAsset: 'assets/images/products/reward_delivery.jpg',
    ),
  ];

  static List<OrderModel> initialOrders(DateTime now) => [
        OrderModel(
          id: 'AQ-1042',
          createdAt: now.subtract(const Duration(days: 4)),
          items: const [
            OrderLineItem(
              productId: 'food_tetramin_flakes',
              variantId: 'v_tetra_250',
              nameEn: 'TetraMin Tropical Flakes',
              nameAr: 'رقائق تترامين للأسماك الاستوائية',
              variantLabelEn: '250 g',
              variantLabelAr: '٢٥٠ جم',
              unitPriceEgp: 260,
              quantity: 1,
              grams: 250,
            ),
            OrderLineItem(
              productId: 'care_prime_conditioner',
              variantId: 'v_cond_100',
              nameEn: 'AquaSafe Water Conditioner',
              nameAr: 'مزيل الكلور ومعالج المياه أكواسيف',
              variantLabelEn: '100 ml',
              variantLabelAr: '١٠٠ مل',
              unitPriceEgp: 160,
              quantity: 1,
            ),
          ],
          subtotalEgp: 420,
          discountEgp: 0,
          deliveryFeeEgp: 35,
          totalEgp: 455,
          pointsEarned: 56,
          pointsUsed: 0,
          fulfillmentType: FulfillmentType.delivery,
          paymentMethod: PaymentMethod.instaPay,
          status: OrderStatus.delivered,
          addressSummary: 'Maadi, Street 9',
        ),
        OrderModel(
          id: 'AQ-1035',
          createdAt: now.subtract(const Duration(days: 19)),
          items: const [
            OrderLineItem(
              productId: 'fish_neon_tetra',
              variantId: 'v_tetra_6',
              nameEn: 'Neon Tetra School',
              nameAr: 'سرب نيون تترا',
              variantLabelEn: 'Pack of 6',
              variantLabelAr: 'مجموعة ٦ أسماك',
              unitPriceEgp: 240,
              quantity: 1,
            ),
            OrderLineItem(
              productId: 'decor_anubias_driftwood',
              variantId: 'v_anubias_s',
              nameEn: 'Anubias Nana on Driftwood',
              nameAr: 'نبات أنوبياس نانا على خشب طبيعي',
              variantLabelEn: 'Small Piece',
              variantLabelAr: 'قطعة صغيرة',
              unitPriceEgp: 240,
              quantity: 1,
            ),
          ],
          subtotalEgp: 480,
          discountEgp: 48,
          deliveryFeeEgp: 0,
          totalEgp: 432,
          pointsEarned: 54,
          pointsUsed: 0,
          fulfillmentType: FulfillmentType.pickup,
          paymentMethod: PaymentMethod.cod,
          status: OrderStatus.delivered,
          couponCode: 'WELCOME10',
        ),
        OrderModel(
          id: 'AQ-1024',
          createdAt: now.subtract(const Duration(days: 38)),
          items: const [
            OrderLineItem(
              productId: 'tank_starter_60',
              variantId: 'v_kit_60',
              nameEn: 'Community Panorama Kit 60L',
              nameAr: 'طقم حوض بانوراما متكامل ٦٠ لتر',
              variantLabelEn: '60 Liters + LED',
              variantLabelAr: '٦٠ لتر + إضاءة LED',
              unitPriceEgp: 2850,
              quantity: 1,
            ),
          ],
          subtotalEgp: 2850,
          discountEgp: 75,
          deliveryFeeEgp: 35,
          totalEgp: 2810,
          pointsEarned: 281,
          pointsUsed: 0,
          fulfillmentType: FulfillmentType.delivery,
          paymentMethod: PaymentMethod.card,
          status: OrderStatus.delivered,
          addressSummary: 'Maadi, Street 9',
          couponCode: 'FIRSTTANK',
        ),
      ];

  static const TankModel initialTank = TankModel(
    id: 'tank_living_60',
    name: 'Living Room 60L',
    sizeLiters: 60,
    waterType: 'fresh',
    fishSummary: '6 Neon Tetras, 1 Halfmoon Betta, 2 Panda Corys',
    fishCount: 9,
  );

  static List<ReminderModel> initialReminders(DateTime now) => [
        ReminderModel(
          id: 'rem_food_tetra',
          type: ReminderType.foodRunOut,
          titleEn: 'TetraMin Tropical Flakes (100g)',
          titleAr: 'رقائق تترامين الاستوائية (١٠٠ جم)',
          descriptionEn:
              'Main daily flakes stored on the shelf beside the 60L tank. Reorder before the bag finishes.',
          descriptionAr:
              'الرقائق اليومية الأساسية موجودة على الرف بجانب حوض ٦٠ لتر. يُفضل إعادة الطلب قبل النفاد.',
          isEnabled: true,
          createdAt: now.subtract(const Duration(days: 21)),
          tankId: 'tank_living_60',
          productId: 'food_tetramin_flakes',
          bagGrams: 100,
          dailyGrams: 4.0,
        ),
        ReminderModel(
          id: 'rem_feed_schedule',
          type: ReminderType.feedingSchedule,
          titleEn: 'Feed Living Room 60L',
          titleAr: 'إطعام حوض الصالة ٦٠ لتر',
          descriptionEn:
              'Give one small pinch of TetraMin flakes (2g). Do not overfeed — all flakes should be eaten within 2 minutes.',
          descriptionAr:
              'أعطِ رشة صغيرة من رقائق تترامين (٢ جم). لا تُكثر من الطعام بحيث ينتهي خلال دقيقتين.',
          isEnabled: true,
          createdAt: now,
          tankId: 'tank_living_60',
          feedHour: 15,
          feedMinute: 0,
          repeatMode: FeedingRepeatMode.daily,
          weekdays: const [1, 2, 3, 4, 5, 6, 7],
        ),
        ReminderModel(
          id: 'rem_water_weekly',
          type: ReminderType.waterChange,
          titleEn: '25% Water Change • Living Room 60L',
          titleAr: 'تغيير ٢٥٪ من الماء • حوض الصالة ٦٠ لتر',
          descriptionEn:
              'Siphon 15L from the bottom, add dechlorinated room-temperature water using AquaSafe conditioner.',
          descriptionAr:
              'اسحب ١٥ لتراً من قاع الحوض وأضف ماءً بدرجة حرارة الغرفة مع مزيل الكلور أكواسيف.',
          isEnabled: true,
          createdAt: now.subtract(const Duration(days: 5)),
          tankId: 'tank_living_60',
          intervalDays: 7,
          lastCompletedAt: now.subtract(const Duration(days: 5)),
        ),
        ReminderModel(
          id: 'rem_filter_monthly',
          type: ReminderType.filterMedia,
          titleEn: 'Rinse Sponge & Replace Carbon',
          titleAr: 'تنظيف الإسفنجة وتغيير الكربون',
          descriptionEn:
              'Rinse the filter sponge gently in old tank water (never tap water) to protect beneficial bacteria.',
          descriptionAr:
              'اشطف إسفنجة الفلتر برفق في ماء الحوض القديم (وليس ماء الصنبور) للحفاظ على البكتيريا النافعة.',
          isEnabled: true,
          createdAt: now.subtract(const Duration(days: 16)),
          tankId: 'tank_living_60',
          intervalDays: 30,
          lastCompletedAt: now.subtract(const Duration(days: 16)),
        ),
      ];

  static UserProfile initialUser() => const UserProfile(
        name: 'Omar',
        phone: '+201012345678',
        memberId: 'AQP-482910',
        referralCode: 'OMAR-AQUA',
        isOnboarded: false,
        isLoggedIn: false,
        addresses: [
          UserAddress(
            id: 'addr_1',
            label: 'Home',
            area: 'Maadi',
            street: 'Street 9, Building 14, Apt 4',
            isDefault: true,
          ),
        ],
      );

  static LoyaltyState initialLoyalty(DateTime now) => LoyaltyState(
        balancePoints: 1240,
        lifetimePoints: 1240,
        transactions: [
          PointsTransaction(
            id: 'pt_1',
            titleEn: 'Order #AQ-1042 (1.25x Silver)',
            titleAr: 'طلب #AQ-1042 (مضاعف الفئة الفضية ١.٢٥)',
            points: 56,
            createdAt: now.subtract(const Duration(days: 4)),
          ),
          PointsTransaction(
            id: 'pt_2',
            titleEn: 'First Tank Added Bonus',
            titleAr: 'مكافأة إضافة أول حوض',
            points: 100,
            createdAt: now.subtract(const Duration(days: 12)),
          ),
          PointsTransaction(
            id: 'pt_3',
            titleEn: 'Order #AQ-1024',
            titleAr: 'طلب #AQ-1024',
            points: 281,
            createdAt: now.subtract(const Duration(days: 38)),
          ),
          PointsTransaction(
            id: 'pt_4',
            titleEn: 'Welcome Bonus',
            titleAr: 'مكافأة الترحيب',
            points: 100,
            createdAt: now.subtract(const Duration(days: 45)),
          ),
        ],
      );
}
