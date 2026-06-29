import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/components/animated_text_section.dart';
import '../../domain/entities/entry_city.dart';
import '../cubit/first_run_settings_cubit.dart';

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class OnboardingCityHighlightsPage extends StatefulWidget {
  const OnboardingCityHighlightsPage({super.key});

  @override
  State<OnboardingCityHighlightsPage> createState() =>
      _OnboardingCityHighlightsPageState();
}

class _OnboardingCityHighlightsPageState
    extends State<OnboardingCityHighlightsPage> {
  late PageController _pageController;
  int _currentPage = 0;
  List<_CityCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _onChipTap(String sectionName) {
    final idx = _sectionStartIndices[sectionName];
    if (idx != null && idx < _cards.length) {
      _pageController.animateToPage(
        idx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String get _currentSectionName {
    if (_cards.isEmpty || _currentPage >= _cards.length) return '';
    return _cards[_currentPage].sectionName;
  }

  Map<String, int> get _sectionStartIndices {
    final map = <String, int>{};
    for (int i = 0; i < _cards.length; i++) {
      final section = _cards[i].sectionName;
      if (!map.containsKey(section)) {
        map[section] = i;
      }
    }
    return map;
  }

  List<String> _sectionNames(AppLocalizations l10n) =>
      [l10n.highlightsMustSee, l10n.highlightsFood, l10n.highlightsCulture];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<FirstRunSettingsCubit, FirstRunSettingsState>(
      builder: (context, state) {
        final city = state.entryCity;
        String titleKey;
        switch (city) {
          case EntryCity.shanghai:
            titleKey = l10n.onboardingHighlightsShanghai;
          case EntryCity.beijing:
            titleKey = l10n.onboardingHighlightsBeijing;
          case EntryCity.guangzhou:
            titleKey = l10n.onboardingHighlightsGuangzhou;
          case EntryCity.other:
            titleKey = l10n.onboardingHighlightsDefault;
        }
        String tagKey;
        switch (city) {
          case EntryCity.shanghai:
            tagKey = l10n.onboardingHighlightsShanghaiTag;
          case EntryCity.beijing:
            tagKey = l10n.onboardingHighlightsBeijingTag;
          case EntryCity.guangzhou:
            tagKey = l10n.onboardingHighlightsGuangzhouTag;
          case EntryCity.other:
            tagKey = l10n.onboardingHighlightsDefaultTag;
        }

        _cards = _sectionsFor(city);
        final locale = Localizations.localeOf(context);

        return Column(
          children: [
            const _CityIllustrationHeader(),
            AnimatedTextSection(
              title: titleKey,
              subtitle: tagKey,
            ),
            const SizedBox(height: AppSpacing.s3),
            // Category filter chips
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _sectionNames(l10n).map((name) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s1),
                    child: _buildChip(name),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.s2),
            // PageView cards
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _cards.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s4,
                      vertical: AppSpacing.s1,
                    ),
                    child: _FullScreenHighlightCard(
                      card: _cards[index],
                      locale: locale,
                    ),
                  );
                },
              ),
            ),
            // Page indicator dots
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.s2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _cards.length,
                    (i) => _buildDot(i),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChip(String name) {
    final isSelected = name == _currentSectionName;
    return GestureDetector(
      onTap: () => _onChipTap(name),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s1 + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.warmPrimaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: isSelected
                ? AppColors.warmPrimary
                : AppColors.warmPrimary.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? AppColors.warmPrimary : AppColors.slate500,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 10.0 : 6.0,
      height: isActive ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color:
            isActive ? AppColors.warmPrimary : AppColors.warmPrimaryLight,
        shape: BoxShape.circle,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // City content data (flat list)
  // ---------------------------------------------------------------------------

  List<_CityCard> _sectionsFor(EntryCity city) {
    switch (city) {
      case EntryCity.shanghai:
        return const [
          // Must See
          _CityCard('The Bund', '外滩', 'Waterfront', '滨江景观',
              'Iconic skyline along Huangpu River, colonial-era architecture meets futuristic Pudong',
              '黄浦江畔标志性天际线，殖民时期建筑与未来感浦东交相辉映',
              'bund', 'Must See'),
          _CityCard('Yu Garden', '豫园', 'Classical Garden', '古典园林',
              'Exquisite Ming-dynasty garden with rockeries, pavilions, and koi ponds in the Old City',
              '精巧的明代园林，假山亭台与锦鲤池藏于老城厢',
              'yugarden', 'Must See'),
          _CityCard('Oriental Pearl', '东方明珠', 'TV Tower', '电视塔',
              'Distinctive 468m tower with spherical observation decks and glass-floor viewing',
              '468米高的独特球体电视塔，拥有透明玻璃观光走廊',
              'orientalpearl', 'Must See'),
          // Food
          _CityCard('Xiaolongbao', '小笼包', 'Soup Dumpling', '汤包',
              'Delicate steamed dumplings filled with hot savory broth and minced pork',
              '精致的蒸饺，内含滚烫鲜美的肉汁与猪肉馅',
              'xiaolongbao', 'Food'),
          _CityCard('Shengjian Mantou', '生煎馒头', 'Pan-fried Bun', '煎包',
              'Crispy-bottomed pork buns, golden-fried and sprinkled with sesame and scallions',
              '底部酥脆的猪肉包子，金黄煎制，撒满芝麻葱花',
              'shengjian', 'Food'),
          _CityCard('Hairy Crab', '大闸蟹', 'Seasonal Delicacy', '时令珍馐',
              'Autumn hairy crab from Yangcheng Lake, prized for its rich golden roe',
              '阳澄湖秋日大闸蟹，以浓郁金黄色的蟹黄著称',
              'hairycrab', 'Food'),
          // Culture
          _CityCard('Shikumen', '石库门', 'Lane Houses', '里弄建筑',
              'Unique Shanghai architectural style blending Western and Chinese courtyard elements',
              '独特的上海建筑风格，中西合璧的院落元素',
              'shikumen', 'Culture'),
          _CityCard('1930s Jazz Age', '爵士时代', 'Old Shanghai', '老上海',
              'The Paris of the East era — jazz clubs, Art Deco, and the legendary Peace Hotel',
              '东方巴黎时代 — 爵士俱乐部、装饰艺术与传奇的和平饭店',
              'jazz', 'Culture'),
          _CityCard('Tea Houses', '茶馆', 'Social Hubs', '社交中心',
              'Century-old tea houses where locals gather for gossip, business, and opera',
              '百年老茶馆，本地人聚会闲谈、谈生意、听戏曲的地方',
              'teahouse', 'Culture'),
        ];
      case EntryCity.beijing:
        return const [
          // Must See
          _CityCard('Forbidden City', '故宫', 'Imperial Palace', '皇家宫殿',
              'World\'s largest palace complex — 980 buildings across 72 hectares of Ming-Qing grandeur',
              '世界最大的宫殿建筑群 — 980座建筑横跨72公顷的明清皇家气派',
              'forbiddencity', 'Must See'),
          _CityCard('Great Wall', '长城', 'Ancient Wonder', '古代奇迹',
              'Mutianyu and Badaling sections snake across mountain ridges with watchtower views',
              '慕田峪与八达岭段蜿蜒山脊，烽火台一览众山',
              'greatwall', 'Must See'),
          _CityCard('Summer Palace', '颐和园', 'Royal Garden', '皇家园林',
              'Lakeside imperial retreat with the Long Corridor and Marble Boat on Kunming Lake',
              '湖畔皇家避暑胜地，长廊与石舫静卧昆明湖上',
              'summerpalace', 'Must See'),
          // Food
          _CityCard('Peking Duck', '北京烤鸭', 'Imperial Dish', '宫廷名菜',
              'Crispy lacquered skin, carved tableside, wrapped in thin pancakes with hoisin and scallions',
              '酥脆油亮的鸭皮，桌边现片，卷入薄饼配甜面酱与葱丝',
              'pekingduck', 'Food'),
          _CityCard('Zhajiangmian', '炸酱面', 'Noodle Classic', '经典面食',
              'Thick wheat noodles topped with savory fermented soybean paste and julienned vegetables',
              '粗麦面条浇上咸香黄酱与各色菜码',
              'zhajiangmian', 'Food'),
          _CityCard('Tanghulu', '糖葫芦', 'Street Sweet', '街头甜品',
              'Candied hawthorn berries on bamboo skewers — a crunchy winter street snack',
              '竹签串起的冰糖山楂 — 冬日酥脆的街头小吃',
              'tanghulu', 'Food'),
          // Culture
          _CityCard('Beijing Opera', '京剧', 'National Treasure', '国粹',
              'Elaborate costumes, painted faces, and acrobatic movements telling ancient stories',
              '华丽戏服、彩绘脸谱与武打身段演绎古老故事',
              'beijingopera', 'Culture'),
          _CityCard('Hutong Life', '胡同生活', 'Alley Culture', '巷子文化',
              'Winding grey-brick alleys with courtyard homes, neighborhood shops, and rickshaw rides',
              '蜿蜒的青砖胡同，四合院民居、街坊小店与人力车穿行其间',
              'hutong', 'Culture'),
          _CityCard('Temple Fairs', '庙会', 'Festival Tradition', '节庆传统',
              'Lunar New Year temple fairs with folk performances, crafts, and street food',
              '春节庙会，民间表演、手工艺品与街头美食荟萃',
              'templefair', 'Culture'),
        ];
      case EntryCity.guangzhou:
        return const [
          // Must See
          _CityCard('Canton Tower', '广州塔', 'Landmark', '地标',
              '600m hyperboloid tower — world\'s highest horizontal Ferris wheel with panoramic views',
              '600米双曲面高塔 — 世界最高的横向摩天轮，尽览全景',
              'cantontower', 'Must See'),
          _CityCard('Chen Clan Hall', '陈家祠', 'Ancestral Temple', '宗祠',
              'Exquisite 19th-century compound with intricate wood, stone, and ceramic carvings',
              '精巧的19世纪建筑群，木雕、石雕与陶塑工艺精湛',
              'chenclan', 'Must See'),
          _CityCard('Shamian Island', '沙面岛', 'Colonial Enclave', '殖民遗风',
              'Tree-lined lanes with 19th-century European buildings, cafés, and bronze statues',
              '林荫小道，19世纪欧式建筑、咖啡馆与青铜雕塑点缀其间',
              'shamian', 'Must See'),
          // Food
          _CityCard('Dim Sum', '早茶点心', 'Cantonese Classic', '粤式经典',
              'Steaming bamboo baskets of har gow, siu mai, and char siu bao — the original brunch',
              '热气腾腾的竹蒸笼，虾饺、烧卖、叉烧包 — 最原始的早午餐',
              'dimsum', 'Food'),
          _CityCard('Wonton Noodles', '云吞面', 'Comfort Food', '暖心美食',
              'Springy egg noodles in umami broth with plump shrimp wontons',
              '弹牙的鸡蛋面配鲜味高汤与饱满虾仁云吞',
              'wontonnoodles', 'Food'),
          _CityCard('Roast Goose', '烧鹅', 'Cantonese Roast', '粤式烧腊',
              'Glossy, mahogany-skinned goose roasted to crispy perfection, served with plum sauce',
              '油亮红褐色的烧鹅，外皮酥脆，配以酸梅酱',
              'roastgoose', 'Food'),
          // Culture
          _CityCard('Cantonese Opera', '粤剧', 'Performing Art', '表演艺术',
              'UNESCO-listed art form with elaborate makeup, silk costumes, and falsetto singing',
              '联合国非遗艺术，精致妆容、丝绸戏服与假声唱腔',
              'cantoneseopera', 'Culture'),
          _CityCard('Lion Dance', '舞狮', 'Festival Performance', '节庆表演',
              'Acrobatic lion dance troupes performing during Lunar New Year and business openings',
              '杂技舞狮队伍在春节与新店开张时的精彩表演',
              'liondance', 'Culture'),
          _CityCard('Lingnan Gardens', '岭南园林', 'Architectural Style', '建筑风格',
              'Distinctive grey-brick architecture with carved gables, ceramic murals, and shaded courtyards',
              '独特的青砖建筑，雕花山墙、陶塑壁画与荫凉庭院',
              'lingnan', 'Culture'),
        ];
      case EntryCity.other:
        return const [
          // Must See
          _CityCard('Explore', '探索', 'Landmarks', '地标',
              'Discover hidden gems and local favorites',
              '发现隐藏的宝藏与本地人最爱',
              'generic_landmark', 'Must See'),
          _CityCard('Parks & Nature', '公园与自然', 'Outdoors', '户外',
              'Find peace in urban parks and natural escapes',
              '在城市公园与自然风光中寻找宁静',
              'generic_garden', 'Must See'),
          _CityCard('Scenic Views', '风景', 'Panoramas', '全景',
              'Breathtaking viewpoints across the city skyline',
              '俯瞰城市天际线的壮丽景观',
              'generic_view', 'Must See'),
          // Food
          _CityCard('Local Cuisine', '本地美食', 'Must Try', '必尝',
              'Savor authentic regional specialties and street food',
              '品尝地道的地方特色与街头美食',
              'generic_food', 'Food'),
          _CityCard('Night Markets', '夜市', 'Street Eats', '街头美食',
              'Vibrant night markets with endless food stalls and local vibes',
              '热闹的夜市，无尽的小吃摊位与本地氛围',
              'generic_street', 'Food'),
          _CityCard('Tea & Snacks', '茶与点心', 'Local Bites', '本地小食',
              'Traditional tea houses and local snack culture',
              '传统茶馆与本地小吃文化',
              'generic_food', 'Food'),
          // Culture
          _CityCard('Traditions', '传统', 'Heritage', '文化遗产',
              'Immerse yourself in centuries of local traditions and customs',
              '沉浸于数百年的地方传统与习俗',
              'generic_culture', 'Culture'),
          _CityCard('Arts & Crafts', '工艺美术', 'Handicrafts', '手工艺',
              'Discover intricate local crafts and artistic heritage',
              '发现精巧的本地工艺与艺术遗产',
              'generic_culture', 'Culture'),
          _CityCard('Modern Life', '现代生活', 'Urban Vibe', '都市脉动',
              'Experience the vibrant pulse of contemporary urban culture',
              '感受当代都市文化的活力脉动',
              'generic_landmark', 'Culture'),
        ];
    }
  }
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

class _CityCard {
  final String titleEn;
  final String titleZh;
  final String tagEn;
  final String tagZh;
  final String descEn;
  final String descZh;
  final String illustrationKey;
  final String sectionName; // "Must See", "Food", or "Culture"

  const _CityCard(
    this.titleEn, this.titleZh,
    this.tagEn, this.tagZh,
    this.descEn, this.descZh,
    this.illustrationKey, this.sectionName,
  );

  String title(Locale locale) => locale.languageCode == 'zh' ? titleZh : titleEn;
  String tag(Locale locale) => locale.languageCode == 'zh' ? tagZh : tagEn;
  String description(Locale locale) => locale.languageCode == 'zh' ? descZh : descEn;
}

// ---------------------------------------------------------------------------
// Full-screen highlight card
// ---------------------------------------------------------------------------

class _FullScreenHighlightCard extends StatelessWidget {
  const _FullScreenHighlightCard({required this.card, required this.locale});
  final _CityCard card;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Column(
        children: [
          // Image area — top 55%
          Expanded(
            flex: 55,
            child: _buildImageArea(),
          ),
          // Content area — bottom 45%
          Expanded(
            flex: 45,
            child: Container(
              width: double.infinity,
              color: AppColors.ivory,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s5,
                AppSpacing.s4,
                AppSpacing.s5,
                AppSpacing.s3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title(locale),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.warmPrimaryDark,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s1),
                  Text(
                    card.tag(locale),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.warmSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s3),
                  Expanded(
                    child: Text(
                      card.description(locale),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.slate500,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s3),
                  // Decorative divider
                  Container(
                    width: 40,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.warmPrimaryLight,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageArea() {
    final imageUrl =
        'https://picsum.photos/seed/${card.illustrationKey}/600/500';
    return Stack(
      fit: StackFit.expand,
      children: [
        // Real photo from network
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const _ShimmerPlaceholder();
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.warmPrimaryLight,
                    AppColors.warmSurface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: _CardIllustration(
                  key: ValueKey(card.illustrationKey),
                ),
              ),
            );
          },
        ),
        // Gradient overlay — black to transparent, bottom 30%
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black54, Colors.transparent],
                stops: [0.0, 0.3],
              ),
            ),
          ),
        ),
        // Category badge overlaid on image bottom-left
        Positioned(
          left: AppSpacing.s4,
          bottom: AppSpacing.s3,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s1,
            ),
            decoration: BoxDecoration(
              color: AppColors.warmPrimary.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              card.sectionName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer placeholder while image loads
// ---------------------------------------------------------------------------

class _ShimmerPlaceholder extends StatefulWidget {
  const _ShimmerPlaceholder();

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _ctrl.value * 2, -0.5),
              end: Alignment(1.0 + _ctrl.value * 2, 0.5),
              colors: [
                AppColors.warmPrimaryLight,
                AppColors.warmSurface,
                AppColors.warmPrimaryLight,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Animated card illustration (fallback)
// ---------------------------------------------------------------------------

class _CardIllustration extends StatefulWidget {
  const _CardIllustration({super.key});
  @override
  State<_CardIllustration> createState() => _CardIllustrationState();
}

class _CardIllustrationState extends State<_CardIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return CustomPaint(
          size: const Size(60, 60),
          painter: _IllustrationPainter(
            key: (widget.key as ValueKey<String>).value,
            t: _ctrl.value,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Illustration painter (all cities)
// ---------------------------------------------------------------------------

class _IllustrationPainter extends CustomPainter {
  _IllustrationPainter({required this.key, required this.t});
  final String key;
  final double t;

  static const _p = AppColors.warmPrimary;
  static const _s = AppColors.warmSecondary;
  static const _a = AppColors.warmAccent;

  double _freq(double f) => sin(t * 2 * pi * f);

  @override
  void paint(Canvas canvas, Size size) {
    switch (key) {
      case 'bund':
        _drawBund(canvas, size);
      case 'yugarden':
        _drawYuGarden(canvas, size);
      case 'orientalpearl':
        _drawOrientalPearl(canvas, size);
      case 'xiaolongbao':
        _drawXiaolongbao(canvas, size);
      case 'shengjian':
        _drawShengjian(canvas, size);
      case 'hairycrab':
        _drawHairyCrab(canvas, size);
      case 'shikumen':
        _drawShikumen(canvas, size);
      case 'jazz':
        _drawJazz(canvas, size);
      case 'teahouse':
        _drawTeahouse(canvas, size);
      case 'forbiddencity':
        _drawForbiddenCity(canvas, size);
      case 'greatwall':
        _drawGreatWall(canvas, size);
      case 'summerpalace':
        _drawSummerPalace(canvas, size);
      case 'pekingduck':
        _drawPekingDuck(canvas, size);
      case 'zhajiangmian':
        _drawZhajiangmian(canvas, size);
      case 'tanghulu':
        _drawTanghulu(canvas, size);
      case 'beijingopera':
        _drawBeijingOpera(canvas, size);
      case 'hutong':
        _drawHutong(canvas, size);
      case 'templefair':
        _drawTempleFair(canvas, size);
      case 'cantontower':
        _drawCantonTower(canvas, size);
      case 'chenclan':
        _drawChenClan(canvas, size);
      case 'shamian':
        _drawShamian(canvas, size);
      case 'dimsum':
        _drawDimSum(canvas, size);
      case 'wontonnoodles':
        _drawWontonNoodles(canvas, size);
      case 'roastgoose':
        _drawRoastGoose(canvas, size);
      case 'cantoneseopera':
        _drawCantoneseOpera(canvas, size);
      case 'liondance':
        _drawLionDance(canvas, size);
      case 'lingnan':
        _drawLingnan(canvas, size);
      case 'generic_landmark':
        _drawGenericLandmark(canvas, size);
      case 'generic_garden':
        _drawGenericGarden(canvas, size);
      case 'generic_view':
        _drawGenericView(canvas, size);
      case 'generic_food':
        _drawGenericFood(canvas, size);
      case 'generic_street':
        _drawGenericStreet(canvas, size);
      case 'generic_culture':
        _drawGenericCulture(canvas, size);
    }
  }

  // -- Shanghai Must See --

  void _drawBund(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.5);
    c.drawRRect(
        RRect.fromLTRBR(12, 16, 22, 38, const Radius.circular(2)), p);
    c.drawRRect(
        RRect.fromLTRBR(24, 10, 34, 38, const Radius.circular(2)), p);
    c.drawRRect(
        RRect.fromLTRBR(36, 18, 48, 38, const Radius.circular(2)), p);
    p.color = _s.withValues(alpha: 0.45);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1.5;
    final ry = 44 + _freq(0.7) * 1.5;
    c.drawLine(Offset(8, ry), Offset(52, ry), p);
    c.drawLine(Offset(14, ry + 4), Offset(46, ry + 4), p);
  }

  void _drawYuGarden(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.5);
    final path = Path()
      ..moveTo(30, 14)
      ..lineTo(22, 28)
      ..lineTo(38, 28)
      ..close();
    c.drawPath(path, p);
    c.drawRect(Rect.fromLTWH(26, 28, 8, 14), p);
    // Bridge
    p.color = _s.withValues(alpha: 0.4);
    final bp = Path()
      ..moveTo(10, 44)
      ..quadraticBezierTo(20, 38, 30, 44)
      ..quadraticBezierTo(40, 38, 50, 44);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 2;
    c.drawPath(bp, p);
    // Ripple
    p.color = _a.withValues(alpha: 0.2);
    c.drawCircle(Offset(30, 50), 5 + _freq(0.5), p);
  }

  void _drawOrientalPearl(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.4);
    c.drawLine(Offset(30, 6), Offset(30, 54),
        p..strokeWidth = 2..style = PaintingStyle.stroke);
    p.style = PaintingStyle.fill;
    c.drawCircle(Offset(30, 42), 7, p);
    c.drawCircle(Offset(30, 22), 4.5, p);
  }

  // -- Shanghai Food --

  void _drawXiaolongbao(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _s.withValues(alpha: 0.35);
    c.drawRRect(
        RRect.fromLTRBR(12, 18, 48, 46, const Radius.circular(6)), p);
    p.color = _p.withValues(alpha: 0.55);
    c.drawCircle(Offset(24, 32), 5.5, p);
    c.drawCircle(Offset(36, 32), 5.5, p);
    c.drawCircle(Offset(30, 38), 5.5, p);
  }

  void _drawShengjian(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _s.withValues(alpha: 0.35);
    c.drawOval(Rect.fromLTWH(10, 20, 40, 28), p);
    p.color = _p.withValues(alpha: 0.5);
    c.drawCircle(Offset(20, 32), 5, p);
    c.drawCircle(Offset(30, 30), 5, p);
    c.drawCircle(Offset(40, 32), 5, p);
    c.drawCircle(Offset(30, 38), 5, p);
    // Sesame dots
    p.color = _a.withValues(alpha: 0.5);
    c.drawCircle(Offset(18, 36), 1.2, p);
    c.drawCircle(Offset(28, 42), 1.2, p);
    c.drawCircle(Offset(40, 38), 1.2, p);
  }

  void _drawHairyCrab(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.55);
    c.drawOval(Rect.fromLTWH(16, 22, 28, 22), p);
    // Legs
    p.strokeWidth = 1.5;
    p.style = PaintingStyle.stroke;
    for (var i = 0; i < 4; i++) {
      final ly = 28.0 + i * 4;
      c.drawLine(Offset(14 - i * 0.5, ly), Offset(8, ly - 2), p);
      c.drawLine(Offset(46 + i * 0.5, ly), Offset(52, ly - 2), p);
    }
    // Eyes
    p.style = PaintingStyle.fill;
    c.drawCircle(Offset(24, 26), 2, p);
    c.drawCircle(Offset(36, 26), 2, p);
  }

  // -- Shanghai Culture --

  void _drawShikumen(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.45);
    c.drawRect(Rect.fromLTWH(16, 20, 28, 34), p);
    p.color = _s.withValues(alpha: 0.4);
    final arch = Path()
      ..moveTo(16, 20)
      ..quadraticBezierTo(30, 6, 44, 20)
      ..close();
    c.drawPath(arch, p);
  }

  void _drawJazz(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.55);
    // Note head
    c.drawOval(Rect.fromLTWH(16, 36, 9, 7), p);
    // Stem
    p.strokeWidth = 2;
    p.style = PaintingStyle.stroke;
    c.drawLine(Offset(25, 38), Offset(25, 16), p);
    // Flag
    c.drawLine(Offset(25, 16), Offset(32, 20), p);
    c.drawLine(Offset(25, 20), Offset(32, 24), p);
    // Lines (staff)
    p.strokeWidth = 0.8;
    p.color = _a.withValues(alpha: 0.3);
    for (var i = 0; i < 3; i++) {
      c.drawLine(Offset(36, 40 + i * 5.0), Offset(50, 40 + i * 5.0), p);
    }
  }

  void _drawTeahouse(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.45);
    // Teapot body
    c.drawOval(Rect.fromLTWH(14, 18, 24, 22), p);
    // Spout
    final sp = Path()
      ..moveTo(14, 26)
      ..lineTo(6, 20)
      ..lineTo(10, 32)
      ..close();
    c.drawPath(sp, p);
    // Handle
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 2.5;
    c.drawArc(Rect.fromLTWH(32, 22, 10, 12), -1.2, 2.2, false, p);
    // Cup
    p.style = PaintingStyle.fill;
    c.drawRect(Rect.fromLTWH(40, 32, 10, 10), p);
  }

  // -- Beijing Must See --

  void _drawForbiddenCity(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.45);
    c.drawRect(Rect.fromLTWH(6, 20, 48, 30), p);
    // Columns
    p.color = _s.withValues(alpha: 0.4);
    c.drawRect(Rect.fromLTWH(12, 16, 3, 34), p);
    c.drawRect(Rect.fromLTWH(24, 16, 3, 34), p);
    c.drawRect(Rect.fromLTWH(36, 16, 3, 34), p);
    c.drawRect(Rect.fromLTWH(48, 16, 3, 34), p);
    // Roof
    p.color = _p.withValues(alpha: 0.55);
    final roof = Path()
      ..moveTo(4, 20)
      ..lineTo(30, 6)
      ..lineTo(56, 20)
      ..close();
    c.drawPath(roof, p);
  }

  void _drawGreatWall(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.stroke;
    p.strokeWidth = 3;
    p.color = _p.withValues(alpha: 0.5);
    final wall = Path()
      ..moveTo(4, 32)
      ..lineTo(16, 24)
      ..lineTo(28, 32)
      ..lineTo(40, 24)
      ..lineTo(52, 32);
    c.drawPath(wall, p);
    // Battlements
    p.style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.4);
    c.drawRect(Rect.fromLTWH(12, 18, 8, 6), p);
    c.drawRect(Rect.fromLTWH(24, 26, 8, 6), p);
    c.drawRect(Rect.fromLTWH(36, 18, 8, 6), p);
  }

  void _drawSummerPalace(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.45);
    // Pavilion roof
    final roof = Path()
      ..moveTo(18, 16)
      ..lineTo(30, 6)
      ..lineTo(42, 16)
      ..close();
    c.drawPath(roof, p);
    c.drawRect(Rect.fromLTWH(22, 16, 16, 10), p);
    // Water
    p.color = _s.withValues(alpha: 0.3);
    final water = Path()
      ..moveTo(4, 40)
      ..quadraticBezierTo(16, 36, 30, 40)
      ..quadraticBezierTo(44, 44, 56, 40);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 2;
    c.drawPath(water, p);
    // Boat
    p.style = PaintingStyle.fill;
    p.color = _a.withValues(alpha: 0.4);
    c.drawOval(Rect.fromLTWH(40, 32, 16, 6), p);
  }

  // -- Beijing Food --

  void _drawPekingDuck(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.5);
    c.drawOval(Rect.fromLTWH(10, 18, 40, 28), p);
    // Slices
    p.color = _a.withValues(alpha: 0.4);
    for (var i = 0; i < 4; i++) {
      c.drawRect(Rect.fromLTWH(16 + i * 8.0, 24, 5, 16), p);
    }
  }

  void _drawZhajiangmian(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.4);
    c.drawOval(Rect.fromLTWH(12, 34, 36, 18), p);
    // Noodles (wavy)
    p.color = _a.withValues(alpha: 0.45);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1.8;
    for (var i = 0; i < 4; i++) {
      final nx = 18 + i * 8.0;
      final path = Path()
        ..moveTo(nx, 38)
        ..quadraticBezierTo(nx + 4, 28, nx, 18)
        ..quadraticBezierTo(nx - 4, 28, nx, 38);
      c.drawPath(path, p);
    }
  }

  void _drawTanghulu(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.stroke;
    p.strokeWidth = 2;
    p.color = _p.withValues(alpha: 0.5);
    c.drawLine(Offset(30, 6), Offset(30, 48), p);
    p.style = PaintingStyle.fill;
    p.color = _s.withValues(alpha: 0.55);
    for (var i = 0; i < 5; i++) {
      c.drawCircle(Offset(30, 12.0 + i * 9), 4.5, p);
    }
  }

  // -- Beijing Culture --

  void _drawBeijingOpera(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.4);
    c.drawOval(Rect.fromLTWH(12, 10, 36, 40), p);
    // Eyes
    p.color = _s.withValues(alpha: 0.5);
    c.drawOval(Rect.fromLTWH(20, 24, 8, 5), p);
    c.drawOval(Rect.fromLTWH(32, 24, 8, 5), p);
    // Mouth
    p.color = _a.withValues(alpha: 0.45);
    c.drawOval(Rect.fromLTWH(24, 36, 12, 6), p);
  }

  void _drawHutong(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.35);
    // Walls
    c.drawRect(Rect.fromLTWH(4, 14, 14, 40), p);
    c.drawRect(Rect.fromLTWH(42, 14, 14, 40), p);
    // Doors
    p.color = _s.withValues(alpha: 0.4);
    c.drawRect(Rect.fromLTWH(8, 30, 6, 14), p);
    c.drawRect(Rect.fromLTWH(48, 30, 6, 14), p);
  }

  void _drawTempleFair(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.45);
    // Temple
    c.drawRect(Rect.fromLTWH(18, 20, 24, 18), p);
    final roof = Path()
      ..moveTo(14, 20)
      ..lineTo(30, 8)
      ..lineTo(46, 20)
      ..close();
    c.drawPath(roof, p);
    // Lanterns
    p.color = _a.withValues(alpha: 0.5);
    c.drawCircle(Offset(16, 30), 3, p);
    c.drawCircle(Offset(44, 30), 3, p);
  }

  // -- Guangzhou Must See --

  void _drawCantonTower(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.stroke;
    p.strokeWidth = 2.5;
    p.color = _p.withValues(alpha: 0.5);
    final curve = Path()
      ..moveTo(30, 6)
      ..quadraticBezierTo(24, 28, 30, 54);
    c.drawPath(curve, p);
    final curve2 = Path()
      ..moveTo(30, 6)
      ..quadraticBezierTo(36, 28, 30, 54);
    c.drawPath(curve2, p);
  }

  void _drawChenClan(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.45);
    c.drawRect(Rect.fromLTWH(10, 22, 40, 28), p);
    // Ornate roof
    p.color = _s.withValues(alpha: 0.4);
    final roof = Path()
      ..moveTo(6, 22)
      ..lineTo(18, 10)
      ..lineTo(30, 16)
      ..lineTo(42, 10)
      ..lineTo(54, 22)
      ..close();
    c.drawPath(roof, p);
  }

  void _drawShamian(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.4);
    c.drawRect(Rect.fromLTWH(8, 14, 44, 38), p);
    // Columns
    p.color = _s.withValues(alpha: 0.35);
    c.drawRect(Rect.fromLTWH(14, 10, 4, 42), p);
    c.drawRect(Rect.fromLTWH(28, 10, 4, 42), p);
    c.drawRect(Rect.fromLTWH(42, 10, 4, 42), p);
  }

  // -- Guangzhou Food --

  void _drawDimSum(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _s.withValues(alpha: 0.3);
    // 3 stacked steamers
    c.drawRRect(
        RRect.fromLTRBR(16, 8, 44, 18, const Radius.circular(3)), p);
    c.drawRRect(
        RRect.fromLTRBR(16, 20, 44, 30, const Radius.circular(3)), p);
    c.drawRRect(
        RRect.fromLTRBR(16, 32, 44, 42, const Radius.circular(3)), p);
    // Steam lines
    p.color = _a.withValues(alpha: 0.25);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1;
    c.drawLine(Offset(24 + _freq(0.6) * 2, 4), Offset(22, -2), p);
    c.drawLine(Offset(36 + _freq(0.8) * 2, 4), Offset(38, -2), p);
  }

  void _drawWontonNoodles(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.35);
    c.drawOval(Rect.fromLTWH(10, 32, 40, 18), p);
    // Noodles
    p.color = _a.withValues(alpha: 0.4);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1.5;
    for (var i = 0; i < 3; i++) {
      final path = Path()
        ..moveTo(16, 26 + i * 6.0)
        ..quadraticBezierTo(26, 18 + i * 4, 36, 26 + i * 6.0)
        ..quadraticBezierTo(44, 32 + i * 3, 48, 26 + i * 6.0);
      c.drawPath(path, p);
    }
    // Wontons
    p.style = PaintingStyle.fill;
    p.color = _s.withValues(alpha: 0.45);
    c.drawOval(Rect.fromLTWH(20, 22, 8, 6), p);
    c.drawOval(Rect.fromLTWH(34, 20, 8, 6), p);
  }

  void _drawRoastGoose(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.5);
    // Body
    c.drawOval(Rect.fromLTWH(18, 18, 24, 32), p);
    // Neck/head
    p.strokeWidth = 3;
    p.style = PaintingStyle.stroke;
    c.drawLine(Offset(30, 18), Offset(28, 8), p);
    p.style = PaintingStyle.fill;
    c.drawCircle(Offset(28, 8), 4, p);
  }

  // -- Guangzhou Culture --

  void _drawCantoneseOpera(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.4);
    c.drawOval(Rect.fromLTWH(12, 14, 36, 34), p);
    // Headpiece
    p.color = _s.withValues(alpha: 0.4);
    final hp = Path()
      ..moveTo(10, 16)
      ..lineTo(18, 6)
      ..lineTo(30, 8)
      ..lineTo(42, 6)
      ..lineTo(50, 16)
      ..close();
    c.drawPath(hp, p);
  }

  void _drawLionDance(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.5);
    c.drawOval(Rect.fromLTWH(10, 12, 40, 36), p);
    // Big eyes
    p.color = _s.withValues(alpha: 0.5);
    c.drawCircle(Offset(22, 24), 7, p);
    c.drawCircle(Offset(38, 24), 7, p);
    p.color = _a.withValues(alpha: 0.5);
    c.drawCircle(Offset(22, 24), 3.5, p);
    c.drawCircle(Offset(38, 24), 3.5, p);
    // Mouth
    p.color = _p.withValues(alpha: 0.4);
    c.drawOval(Rect.fromLTWH(20, 36, 20, 10), p);
  }

  void _drawLingnan(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.35);
    // Brick wall
    c.drawRect(Rect.fromLTWH(8, 14, 44, 38), p);
    // Brick lines
    p.color = _s.withValues(alpha: 0.2);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 0.8;
    for (var i = 0; i < 3; i++) {
      c.drawLine(Offset(8, 22 + i * 10.0), Offset(52, 22 + i * 10.0), p);
    }
    // Carved relief
    p.style = PaintingStyle.fill;
    p.color = _a.withValues(alpha: 0.35);
    c.drawRect(Rect.fromLTWH(22, 26, 16, 14), p);
  }

  // -- Generic (Other) --

  void _drawGenericLandmark(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.45);
    c.drawRect(Rect.fromLTWH(14, 16, 32, 36), p);
    p.color = _s.withValues(alpha: 0.4);
    final roof = Path()
      ..moveTo(10, 16)
      ..lineTo(30, 4)
      ..lineTo(50, 16)
      ..close();
    c.drawPath(roof, p);
  }

  void _drawGenericGarden(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.4);
    c.drawRect(Rect.fromLTWH(25, 24, 8, 28), p);
    // Tree top
    p.color = _s.withValues(alpha: 0.4);
    c.drawOval(Rect.fromLTWH(14, 10, 30, 20), p);
    // Flower
    p.color = _a.withValues(alpha: 0.45);
    c.drawCircle(Offset(44, 44), 5, p);
  }

  void _drawGenericView(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.4);
    // Mountains
    final mt = Path()
      ..moveTo(4, 40)
      ..lineTo(16, 18)
      ..lineTo(28, 40)
      ..close();
    c.drawPath(mt, p);
    final mt2 = Path()
      ..moveTo(24, 40)
      ..lineTo(38, 14)
      ..lineTo(52, 40)
      ..close();
    c.drawPath(mt2, p);
    // Sun/eye
    p.color = _a.withValues(alpha: 0.4);
    c.drawCircle(Offset(44, 16), 8, p);
  }

  void _drawGenericFood(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.35);
    c.drawOval(Rect.fromLTWH(12, 18, 36, 26), p);
    // Fork
    p.strokeWidth = 2;
    p.style = PaintingStyle.stroke;
    p.color = _s.withValues(alpha: 0.45);
    c.drawLine(Offset(22, 12), Offset(18, 36), p);
    c.drawLine(Offset(22, 12), Offset(24, 6), p);
    // Knife
    c.drawLine(Offset(42, 12), Offset(44, 36), p);
  }

  void _drawGenericStreet(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.4);
    c.drawRect(Rect.fromLTWH(25, 20, 6, 30), p);
    // Lamp
    p.color = _a.withValues(alpha: 0.45);
    c.drawOval(Rect.fromLTWH(22, 16, 12, 6), p);
  }

  void _drawGenericCulture(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = _p.withValues(alpha: 0.4);
    c.drawOval(Rect.fromLTWH(12, 12, 36, 36), p);
    // Eye holes
    p.color = _s.withValues(alpha: 0.4);
    c.drawOval(Rect.fromLTWH(20, 22, 8, 6), p);
    c.drawOval(Rect.fromLTWH(32, 22, 8, 6), p);
    // Mouth
    p.color = _a.withValues(alpha: 0.35);
    c.drawOval(Rect.fromLTWH(24, 34, 12, 8), p);
  }

  @override
  bool shouldRepaint(covariant _IllustrationPainter old) => old.t != t;
}

// ---------------------------------------------------------------------------
// City illustration header (animated banner)
// ---------------------------------------------------------------------------

class _CityIllustrationHeader extends StatefulWidget {
  const _CityIllustrationHeader();

  @override
  State<_CityIllustrationHeader> createState() =>
      _CityIllustrationHeaderState();
}

class _CityIllustrationHeaderState extends State<_CityIllustrationHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFE8D6),
            AppColors.warmPrimaryLight,
            AppColors.warmSurface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return CustomPaint(
            size: const Size(double.infinity, 200),
            painter: _CitySkylinePainter(t: _ctrl.value),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// City skyline painter
// ---------------------------------------------------------------------------

class _CitySkylinePainter extends CustomPainter {
  const _CitySkylinePainter({required this.t});

  final double t;

  static const _p = AppColors.warmPrimary;
  static const _s = AppColors.warmSecondary;
  static const _a = AppColors.warmAccent;
  static const _w = Colors.white;

  double _float(double freq, {double amp = 6}) => sin(t * 2 * pi * freq) * amp;
  double _pulse(double freq) => 1.0 + sin(t * 2 * pi * freq) * 0.05;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _drawClouds(canvas, w, h);
    _drawSun(canvas, w, h);
    _drawRiver(canvas, w, h);
    _drawSkyline(canvas, w, h);
    _drawFloatingElements(canvas, w, h);
  }

  void _drawSun(Canvas canvas, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Soft glowing sun
    final sunX = w * 0.78;
    final sunY = h * 0.25;
    final sunPulse = _pulse(0.4);

    paint.color = _a.withValues(alpha: 0.12);
    canvas.drawCircle(Offset(sunX, sunY), 48 * sunPulse, paint);
    paint.color = _a.withValues(alpha: 0.2);
    canvas.drawCircle(Offset(sunX, sunY), 36 * sunPulse, paint);
    paint.color = _a.withValues(alpha: 0.4);
    canvas.drawCircle(Offset(sunX, sunY), 22, paint);

    // Sun rays
    paint.color = _a.withValues(alpha: 0.15);
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    for (var i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi + t * pi * 0.2;
      final dx = sunX + cos(angle) * 30;
      final dy = sunY + sin(angle) * 30;
      canvas.drawLine(
        Offset(sunX + cos(angle) * 26, sunY + sin(angle) * 26),
        Offset(dx, dy),
        paint,
      );
    }
  }

  void _drawClouds(Canvas canvas, double w, double h) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = _w.withValues(alpha: 0.55);

    // Cloud 1
    final c1x = w * 0.12 + _float(0.15, amp: 15);
    final c1y = h * 0.18;
    _drawCloud(canvas, c1x, c1y, 0.9, paint);

    // Cloud 2
    final c2x = w * 0.5 + _float(0.12, amp: 12);
    final c2y = h * 0.1;
    _drawCloud(canvas, c2x, c2y, 0.7, paint);

    // Cloud 3
    final c3x = w * 0.65 + _float(0.18, amp: 10);
    final c3y = h * 0.22;
    _drawCloud(canvas, c3x, c3y, 0.6, paint);
  }

  void _drawCloud(
      Canvas canvas, double x, double y, double scale, Paint paint) {
    final s = scale;
    canvas.drawCircle(Offset(x, y), 14 * s, paint);
    canvas.drawCircle(Offset(x + 12 * s, y - 4 * s), 11 * s, paint);
    canvas.drawCircle(Offset(x + 24 * s, y), 13 * s, paint);
    canvas.drawCircle(Offset(x + 12 * s, y + 2 * s), 10 * s, paint);
  }

  void _drawRiver(Canvas canvas, double w, double h) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = _s.withValues(alpha: 0.18);

    final riverY = h * 0.82;
    final path = Path()
      ..moveTo(0, riverY)
      ..quadraticBezierTo(w * 0.3, riverY - 8, w * 0.5, riverY)
      ..quadraticBezierTo(w * 0.7, riverY + 8, w, riverY - 4)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(path, paint);

    // River shimmer lines
    paint.color = _a.withValues(alpha: 0.12);
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;
    for (var i = 0; i < 5; i++) {
      final lx = i * w * 0.22 + _float(0.3 + i * 0.1, amp: 6);
      final ly = riverY + 12 + i * 4.0;
      canvas.drawLine(
        Offset(lx - 15, ly),
        Offset(lx + 15, ly),
        paint,
      );
    }
  }

  void _drawSkyline(Canvas canvas, double w, double h) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = _p.withValues(alpha: 0.22);

    final baseY = h * 0.78;

    // Far buildings
    final farBuildings = [
      (w * 0.05, baseY - 30, 22.0),
      (w * 0.1, baseY - 50, 18.0),
      (w * 0.15, baseY - 38, 15.0),
      (w * 0.2, baseY - 65, 20.0),
      (w * 0.26, baseY - 28, 16.0),
      (w * 0.32, baseY - 55, 14.0),
    ];
    for (final (x, y, bw) in farBuildings) {
      canvas.drawRect(
        Rect.fromLTWH(x, y, bw, baseY - y),
        paint,
      );
    }

    // Near buildings
    paint.color = _p.withValues(alpha: 0.45);
    final buildings = [
      (w * 0.0, baseY - 35, 28.0),
      (w * 0.06, baseY - 60, 22.0),
      (w * 0.12, baseY - 45, 24.0),
      (w * 0.18, baseY - 85, 20.0),
      (w * 0.23, baseY - 50, 18.0),
      (w * 0.28, baseY - 70, 22.0),
      (w * 0.34, baseY - 40, 16.0),
    ];
    for (final (x, y, bw) in buildings) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          x,
          y,
          x + bw,
          baseY,
          const Radius.circular(3),
        ),
        paint,
      );
    }

    // Tall tower (TV tower / Canton Tower style)
    paint.color = _p.withValues(alpha: 0.5);
    final towerX = w * 0.38;
    final towerBase = baseY - 120;
    final towerPath = Path()
      ..moveTo(towerX + 8, baseY)
      ..lineTo(towerX + 6, towerBase + 30)
      ..lineTo(towerX + 2, towerBase + 10)
      ..lineTo(towerX - 2, towerBase + 10)
      ..lineTo(towerX - 6, towerBase + 30)
      ..lineTo(towerX - 8, baseY)
      ..close();
    canvas.drawPath(towerPath, paint);
    // Tower top sphere
    canvas.drawCircle(Offset(towerX, towerBase), 7, paint);
    paint.color = _a.withValues(alpha: 0.4);
    canvas.drawCircle(Offset(towerX, towerBase), 4, paint);

    // More buildings on the right of tower
    paint.color = _p.withValues(alpha: 0.4);
    final rightBuildings = [
      (w * 0.46, baseY - 40, 20.0),
      (w * 0.52, baseY - 55, 18.0),
      (w * 0.58, baseY - 70, 22.0),
      (w * 0.64, baseY - 48, 16.0),
      (w * 0.7, baseY - 80, 24.0),
      (w * 0.78, baseY - 30, 20.0),
      (w * 0.84, baseY - 42, 18.0),
      (w * 0.9, baseY - 60, 22.0),
      (w * 0.96, baseY - 35, 20.0),
    ];
    for (final (x, y, bw) in rightBuildings) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          x,
          y,
          x + bw,
          baseY,
          const Radius.circular(3),
        ),
        paint,
      );
    }

    // Distant buildings on the far right
    paint.color = _p.withValues(alpha: 0.18);
    final farRight = [
      (w * 0.75, baseY - 25, 16.0),
      (w * 0.81, baseY - 45, 14.0),
      (w * 0.86, baseY - 35, 12.0),
      (w * 0.92, baseY - 50, 14.0),
    ];
    for (final (x, y, bw) in farRight) {
      canvas.drawRect(
        Rect.fromLTWH(x, y, bw, baseY - y),
        paint,
      );
    }

    // Building windows (tiny dots)
    _drawBuildingWindows(canvas, w, baseY);
  }

  void _drawBuildingWindows(Canvas canvas, double w, double baseY) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = _a.withValues(alpha: 0.25);

    final rng = Random(42);
    final buildings = [
      (w * 0.06, baseY - 58, 22.0, 4, 5),
      (w * 0.18, baseY - 83, 20.0, 3, 7),
      (w * 0.33, baseY - 68, 22.0, 4, 5),
      (w * 0.52, baseY - 53, 18.0, 3, 4),
      (w * 0.58, baseY - 68, 22.0, 4, 6),
      (w * 0.7, baseY - 78, 24.0, 4, 6),
      (w * 0.84, baseY - 40, 18.0, 3, 4),
      (w * 0.9, baseY - 58, 22.0, 4, 5),
    ];

    for (final (bx, by, bw, cols, rows) in buildings) {
      final cellW = bw / cols;
      final cellH = (baseY - by) / (rows + 1);
      for (var r = 0; r < rows; r++) {
        for (var c = 0; c < cols; c++) {
          if (rng.nextDouble() > 0.35) {
            final alpha = (sin(t * 2 * pi * 0.2 + r + c) * 0.1 + 0.22)
                .clamp(0.0, 0.35);
            paint.color = _a.withValues(alpha: alpha);
            canvas.drawCircle(
              Offset(bx + (c + 0.5) * cellW, by + (r + 1) * cellH),
              1.8,
              paint,
            );
          }
        }
      }
    }
  }

  void _drawFloatingElements(Canvas canvas, double w, double h) {
    _drawPagoda(canvas, w * 0.7, h * 0.45);
    _drawTempleIcon(canvas, w * 0.15, h * 0.38);
  }

  void _drawPagoda(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = _a.withValues(alpha: 0.35);

    final px = x + _float(0.25, amp: 4);
    final py = y + _float(0.3, amp: 3);

    // Pagoda body (layered trapezoids)
    for (var i = 0; i < 3; i++) {
      final levelW = 18.0 - i * 3;
      final levelY = py + i * 12;
      final path = Path()
        ..moveTo(px - levelW, levelY + 10)
        ..lineTo(px - levelW - 2, levelY)
        ..lineTo(px + levelW + 2, levelY)
        ..lineTo(px + levelW, levelY + 10)
        ..close();
      canvas.drawPath(path, paint);
    }

    // Pagoda roof (pointed)
    final roofPath = Path()
      ..moveTo(px, py - 18)
      ..lineTo(px - 10, py)
      ..lineTo(px + 10, py)
      ..close();
    canvas.drawPath(roofPath, paint);

    // Pagoda spire
    paint.color = _a.withValues(alpha: 0.5);
    paint.strokeWidth = 1.5;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(px, py - 18),
      Offset(px, py - 28),
      paint,
    );
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(px, py - 28), 2, paint);
  }

  void _drawTempleIcon(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = _s.withValues(alpha: 0.35);

    final tx = x + _float(0.22, amp: 5);
    final ty = y + _float(0.28, amp: 3);

    // Temple base
    canvas.drawRect(
      Rect.fromCenter(center: Offset(tx, ty), width: 24, height: 18),
      paint,
    );

    // Temple roof (curved eaves)
    final roofPath = Path()
      ..moveTo(tx - 18, ty - 7)
      ..quadraticBezierTo(tx, ty - 22, tx + 18, ty - 7)
      ..lineTo(tx + 14, ty - 9)
      ..lineTo(tx, ty - 5)
      ..lineTo(tx - 14, ty - 9)
      ..close();
    canvas.drawPath(roofPath, paint);

    // Temple pillar lines
    paint.color = _w.withValues(alpha: 0.4);
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(Offset(tx - 8, ty - 9), Offset(tx - 8, ty + 9), paint);
    canvas.drawLine(Offset(tx + 8, ty - 9), Offset(tx + 8, ty + 9), paint);

    // Small steps
    paint.style = PaintingStyle.fill;
    paint.color = _s.withValues(alpha: 0.2);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(tx, ty + 12), width: 14, height: 3),
      paint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(tx, ty + 15), width: 18, height: 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CitySkylinePainter old) => old.t != t;
}