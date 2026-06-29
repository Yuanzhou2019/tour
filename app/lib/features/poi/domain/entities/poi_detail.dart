class PoiDetailTag {
  final String tagKey;
  final String category; // positive | warning | risk
  final String labelZh;
  final String labelEn;

  const PoiDetailTag({
    required this.tagKey,
    required this.category,
    required this.labelZh,
    required this.labelEn,
  });

  factory PoiDetailTag.fromJson(Map<String, dynamic> json) => PoiDetailTag(
        tagKey: json['tagKey'] as String? ?? '',
        category: json['category'] as String? ?? 'positive',
        labelZh: json['labelZh'] as String? ?? '',
        labelEn: json['labelEn'] as String? ?? '',
      );
}

class PoiDetail {
  final String id;
  final String nameZh;
  final String nameEn;
  final String addressZh;
  final String addressEn;
  final double lat;
  final double lng;
  final String category;
  final String city;
  final String? contact;
  final String? openHours;
  final List<String> imageUrls;
  final String? descriptionZh;
  final String? descriptionEn;
  final List<PoiDetailTag> tags;
  final PoiDetailReputation? reputation;

  const PoiDetail({
    required this.id,
    required this.nameZh,
    required this.nameEn,
    required this.addressZh,
    required this.addressEn,
    required this.lat,
    required this.lng,
    required this.category,
    required this.city,
    this.contact,
    this.openHours,
    this.imageUrls = const [],
    this.descriptionZh,
    this.descriptionEn,
    this.tags = const [],
    this.reputation,
  });

  factory PoiDetail.fromJson(Map<String, dynamic> json) => PoiDetail(
        id: json['id'] as String,
        nameZh: json['nameZh'] as String? ?? json['name'] as String? ?? '',
        nameEn: json['nameEn'] as String? ?? json['name'] as String? ?? '',
        addressZh: json['addressZh'] as String? ?? json['address'] as String? ?? '',
        addressEn: json['addressEn'] as String? ?? json['address'] as String? ?? '',
        lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
        lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
        category: json['category'] as String? ?? 'attraction',
        city: json['city'] as String? ?? 'SH',
        contact: json['contact'] as String?,
        openHours: json['openHours'] as String?,
        imageUrls: (json['imageUrls'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        descriptionZh: json['descriptionZh'] as String?,
        descriptionEn: json['descriptionEn'] as String?,
        tags: (json['tags'] as List<dynamic>?)
                ?.map((e) =>
                    PoiDetailTag.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        reputation: json['reputation'] != null
            ? PoiDetailReputation.fromJson(
                json['reputation'] as Map<String, dynamic>)
            : null,
      );

  /// True when the response wraps the detail inside a `data` key.
  factory PoiDetail.fromResponse(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return PoiDetail.fromJson(data);
  }
}

class PoiDetailReputation {
  final String id;
  final double overallScore;
  final double foreignFriendly;
  final double languageSupport;
  final double paymentEase;
  final double authenticity;
  final double value;
  final bool officialVerified;
  final List<String> experienceTipsZh;
  final List<String> experienceTipsEn;
  final String? updatedAt;

  const PoiDetailReputation({
    required this.id,
    required this.overallScore,
    required this.foreignFriendly,
    required this.languageSupport,
    required this.paymentEase,
    required this.authenticity,
    required this.value,
    required this.officialVerified,
    this.experienceTipsZh = const [],
    this.experienceTipsEn = const [],
    this.updatedAt,
  });

  factory PoiDetailReputation.fromJson(Map<String, dynamic> json) =>
      PoiDetailReputation(
        id: json['id'] as String? ?? '',
        overallScore: (json['overallScore'] as num?)?.toDouble() ?? 0.0,
        foreignFriendly:
            (json['foreignFriendly'] as num?)?.toDouble() ?? 0.0,
        languageSupport:
            (json['languageSupport'] as num?)?.toDouble() ?? 0.0,
        paymentEase: (json['paymentEase'] as num?)?.toDouble() ?? 0.0,
        authenticity: (json['authenticity'] as num?)?.toDouble() ?? 0.0,
        value: (json['value'] as num?)?.toDouble() ?? 0.0,
        officialVerified: json['officialVerified'] as bool? ?? false,
        experienceTipsZh: (json['experienceTipsZh'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        experienceTipsEn: (json['experienceTipsEn'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        updatedAt: json['updatedAt'] as String?,
      );

  factory PoiDetailReputation.fromResponse(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return PoiDetailReputation.fromJson(data);
  }
}
