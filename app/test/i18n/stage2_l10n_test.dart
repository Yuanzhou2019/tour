import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightour/l10n/generated/app_localizations.dart';

Future<AppLocalizations> _buildL10n(WidgetTester tester, Locale locale) async {
  late AppLocalizations l10n;
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (ctx) {
        l10n = AppLocalizations.of(ctx);
        return const SizedBox.shrink();
      }),
    ),
  );
  return l10n;
}

void main() {
  testWidgets('EN: 36 prepare/map/discover/tools keys', (tester) async {
    final l = await _buildL10n(tester, const Locale('en'));

    // Prepare (12)
    expect(l.prepareTitle('US'), contains('Prepare'));
    expect(l.prepareSectionPolicies, 'What you need to know');
    expect(l.prepareSectionChecklist, 'Pre-arrival checklist');
    expect(l.prepareSectionDownloads, 'Offline downloads');
    expect(l.prepareNoPolicies('US'), contains('No policy info'));
    expect(l.prepareDownloadToast, contains('Download'));
    expect(l.prepareOfflineShanghai, 'Shanghai core pack');
    expect(l.prepareOfflineShanghaiDesc, contains('maps'));
    expect(l.prepareChecklistPassport, contains('Passport'));
    expect(l.prepareChecklistCash, contains('Cash'));
    expect(l.prepareChecklistEmergency, contains('Emergency'));
    expect(l.prepareChecklistOffline, contains('Offline'));

    // Map (10)
    expect(l.mapTitle, 'Map');
    expect(l.mapSearchHint, contains('Search'));
    expect(l.mapCategoryAll, 'All');
    expect(l.mapCategoryAttraction, 'Sights');
    expect(l.mapCategoryDining, 'Eat');
    expect(l.mapCategoryLodging, 'Stay');
    expect(l.mapCategoryShopping, 'Shop');
    expect(l.mapEmpty, contains('No results'));
    expect(l.mapDistanceAway('1.2'), '1.2 km away');

    // Discover (5)
    expect(l.discoverTitle, 'Discover Shanghai');
    expect(l.discoverTabCurated, 'Curated');
    expect(l.discoverTabAuthentic, 'Authentic');
    expect(l.discoverTabHeadsUp, 'Heads-up');
    expect(l.discoverEmpty, contains('Nothing'));

    // Tools (12)
    expect(l.toolsTitle, 'Tools');
    expect(l.toolsFxTitle, 'Live currency');
    expect(l.toolsFxFrom, 'From');
    expect(l.toolsFxTo, 'To');
    expect(l.toolsFxAmount, 'Amount');
    expect(l.toolsFxRate('USD', '7.1', 'CNY'), contains('USD'));
    expect(l.toolsAllTools, 'All tools');
    expect(l.toolsComingSoon('Phrases'), contains('Phrases'));
    expect(l.toolsToolPhrases, 'Phrase book');
    expect(l.toolsToolEmergency, 'Emergency contacts');
    expect(l.toolsToolUnits, 'Unit converter');
    expect(l.toolsToolTimezone, 'Time zone');
    expect(l.toolsToolOffline, 'Offline pack');
    expect(l.toolsToolTranslate, 'Translate assistant');
  });

  testWidgets('ZH: 36 prepare/map/discover/tools keys', (tester) async {
    final l = await _buildL10n(tester, const Locale('zh'));

    // Prepare (12)
    expect(l.prepareTitle('US'), contains('行前'));
    expect(l.prepareSectionPolicies, '你需要知道');
    expect(l.prepareSectionChecklist, '行前清单');
    expect(l.prepareSectionDownloads, '离线下载');
    expect(l.prepareNoPolicies('US'), contains('政策'));
    expect(l.prepareDownloadToast, contains('下载'));
    expect(l.prepareOfflineShanghai, '上海核心包');
    expect(l.prepareOfflineShanghaiDesc, contains('地图'));
    expect(l.prepareChecklistPassport, contains('护照'));
    expect(l.prepareChecklistCash, contains('现金'));
    expect(l.prepareChecklistEmergency, contains('紧急'));
    expect(l.prepareChecklistOffline, contains('离线'));

    // Map (10)
    expect(l.mapTitle, '地图');
    expect(l.mapSearchHint, contains('搜索'));
    expect(l.mapCategoryAll, '全部');
    expect(l.mapCategoryAttraction, '景点');
    expect(l.mapCategoryDining, '美食');
    expect(l.mapCategoryLodging, '住宿');
    expect(l.mapCategoryShopping, '购物');
    expect(l.mapEmpty, contains('暂无'));
    expect(l.mapDistanceAway('1.2'), contains('1.2'));

    // Discover (5)
    expect(l.discoverTitle, '发现上海');
    expect(l.discoverTabCurated, '精选');
    expect(l.discoverTabAuthentic, '本地');
    expect(l.discoverTabHeadsUp, '提醒');
    expect(l.discoverEmpty, contains('暂无'));

    // Tools (12)
    expect(l.toolsTitle, '工具');
    expect(l.toolsFxTitle, '实时汇率');
    expect(l.toolsFxFrom, '从');
    expect(l.toolsFxTo, '到');
    expect(l.toolsFxAmount, '金额');
    expect(l.toolsFxRate('USD', '7.1', 'CNY'), contains('USD'));
    expect(l.toolsAllTools, '全部工具');
    expect(l.toolsComingSoon('常用短语'), contains('常用短语'));
    expect(l.toolsToolPhrases, '常用短语');
    expect(l.toolsToolEmergency, '紧急联系');
    expect(l.toolsToolUnits, '单位换算');
    expect(l.toolsToolTimezone, '时区');
    expect(l.toolsToolOffline, '离线包');
    expect(l.toolsToolTranslate, '翻译助手');
  });
}