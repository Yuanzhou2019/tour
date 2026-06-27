enum UnitSystem {
  metric('Metric (km, °C)', '公制'),
  imperial('Imperial (mi, °F)', '英制');

  const UnitSystem(this.labelEn, this.labelZh);
  final String labelEn;
  final String labelZh;
}
