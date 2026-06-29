class EmergencyContact {
  final String id;
  final String country;
  final String type; // police | medical | fire | consulate | tourist_hotline
  final String nameZh;
  final String nameEn;
  final String phone;
  final String? addressZh;
  final String? addressEn;

  const EmergencyContact({
    required this.id,
    required this.country,
    required this.type,
    required this.nameZh,
    required this.nameEn,
    required this.phone,
    this.addressZh,
    this.addressEn,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      EmergencyContact(
        id: json['id'] as String? ?? '',
        country: json['country'] as String? ?? '*',
        type: json['type'] as String? ?? 'police',
        nameZh: json['nameZh'] as String? ?? '',
        nameEn: json['nameEn'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        addressZh: json['addressZh'] as String?,
        addressEn: json['addressEn'] as String?,
      );

  factory EmergencyContact.fromResponse(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is List) {
      return EmergencyContact.fromJson(data.first as Map<String, dynamic>);
    }
    return EmergencyContact.fromJson(data as Map<String, dynamic>? ?? json);
  }
}
