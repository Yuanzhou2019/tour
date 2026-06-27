import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/core/theme/app_colors.dart';

void main() {
  test('slate900 equals #1A2332', () {
    expect(AppColors.slate900.toARGB32(), 0xFF1A2332);
  });
  test('blue600 equals #2A4365', () {
    expect(AppColors.blue600.toARGB32(), 0xFF2A4365);
  });
  test('sand500 equals #D4A574', () {
    expect(AppColors.sand500.toARGB32(), 0xFFD4A574);
  });
  test('sage600 equals #5B8C5A', () {
    expect(AppColors.sage600.toARGB32(), 0xFF5B8C5A);
  });
  test('amber500 equals #D97706', () {
    expect(AppColors.amber500.toARGB32(), 0xFFD97706);
  });
  test('clay600 equals #C2410C', () {
    expect(AppColors.clay600.toARGB32(), 0xFFC2410C);
  });
  test('ivory equals #FAFAF7', () {
    expect(AppColors.ivory.toARGB32(), 0xFFFAFAF7);
  });
}
