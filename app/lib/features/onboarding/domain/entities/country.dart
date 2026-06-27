enum Country {
  us('US', 'United States', '美国', '🇺🇸'),
  uk('GB', 'United Kingdom', '英国', '🇬🇧'),
  jp('JP', 'Japan', '日本', '🇯🇵'),
  kr('KR', 'South Korea', '韩国', '🇰🇷'),
  de('DE', 'Germany', '德国', '🇩🇪'),
  fr('FR', 'France', '法国', '🇫🇷'),
  au('AU', 'Australia', '澳大利亚', '🇦🇺'),
  ca('CA', 'Canada', '加拿大', '🇨🇦'),
  it('IT', 'Italy', '意大利', '🇮🇹'),
  ru('RU', 'Russia', '俄罗斯', '🇷🇺');

  const Country(this.iso2, this.nameEn, this.nameZh, this.flag);
  final String iso2;
  final String nameEn;
  final String nameZh;
  final String flag;
}
