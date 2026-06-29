/// First-arrival city. v1 supports Beijing / Shanghai / Guangzhou. Other cities
/// are reachable via the [EntryCity.other] placeholder which prompts the user
/// to check back later; the offline pack and POI list will only have rich
/// data for the three named cities.
enum EntryCity {
  beijing(
    'BJ',
    'Beijing',
    '北京',
    'BJ',
    'North',
    'Capital · visa-free transit hub · UNESCO sites',
  ),
  shanghai(
    'SH',
    'Shanghai',
    '上海',
    'SH',
    'East',
    'Financial centre · Bund · Pudong skyline',
  ),
  guangzhou(
    'GZ',
    'Guangzhou',
    '广州',
    'GZ',
    'South',
    'Canton trade hub · Pearl River delta · Cantonese food',
  ),
  other(
    'OTHER',
    'Other city (coming soon)',
    '其他城市（敬请期待）',
    null,
    null,
    null,
  );

  const EntryCity(
    this.id,
    this.nameEn,
    this.nameZh,
    this.codeIata,
    this.region,
    this.tagline,
  );
  final String id;
  final String nameEn;
  final String nameZh;

  /// IATA city code (or null for [EntryCity.other]).
  final String? codeIata;

  /// Region tag used by content ops for grouping offline packs.
  final String? region;

  /// Short marketing-style blurb shown next to the chip in onboarding.
  final String? tagline;

  /// True if this city has a full offline pack in v1.
  bool get isLaunchCity => this != other;
}
