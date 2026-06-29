/// Mock fixtures used by [MockInterceptor] when the real backend is not
/// available. The shapes mirror what `*_repository_impl.dart` parses from
/// the server JSON, so the repositories do not need to know whether the
/// data came from a wire or from disk.
///
/// Endpoints covered (all matched against `${method} ${path}`):
///
/// * `GET /policies?country=XX`        — visa, customs, consular, residence
/// * `GET /checklists?country=XX`      — pre-arrival & arrival tasks
/// * `GET /pois/search?q=&category=`   — sample POIs in Shanghai
/// * `GET /discover/curated`           — editor's curated list
/// * `GET /discover/authentic`         — local picks
/// * `GET /discover/heads-up`          — things to watch out for
/// * `GET /tools/fx-rates?from=&to=`   — cached FX rates
/// * `GET /me/preferences`             — current user's local preferences
/// * `POST /corrections`               — submission echo
///
/// When [LocaleCubit] reports a `zh` locale, the interceptor passes that
/// to [MockData.responseFor], which substitutes user-facing strings from
/// [MockDataZh]. Other locales (or empty / unknown) keep the default
/// English payloads.
library;

import 'mock_data_zh.dart';

/// Group of canned JSON payloads keyed by `${method} ${path}` (path only
/// when query string is irrelevant). The interceptor looks up the entry
/// and returns its `data` field; missing keys return [emptyData].
class MockData {
  MockData._();

  /// Default empty list response.
  static const Map<String, dynamic> emptyData = <String, dynamic>{
    'data': <dynamic>[],
    'meta': <String, dynamic>{
      'page': 1,
      'pageSize': 20,
      'total': 0,
    },
  };

  /// Current locale for response localization. Updated by
  /// [MockInterceptor] on every request via [setLocale] (which is in turn
  /// fed by [LocaleCubit]). Defaults to `en` (English) which means: no
  /// translation is applied.
  static String _currentLocale = 'en';

  /// Update [_currentLocale]. Called by [MockInterceptor] before each
  /// request so the helper methods that build the response payload can
  /// pick the right language.
  static void setLocale(String locale) {
    _currentLocale = locale;
  }

  /// True when [_currentLocale] is `zh` (with optional region tag such as
  /// `zh-CN` or `zh-Hans`). Used by the per-endpoint builders to decide
  /// whether to swap in [MockDataZh] strings.
  static bool get _isZh {
    final l = _currentLocale.toLowerCase();
    return l == 'zh' || l.startsWith('zh-') || l.startsWith('zh_');
  }

  // ---------------------------------------------------------------------------
  // Endpoint lookup
  // ---------------------------------------------------------------------------

  /// Look up a canned response by `method` + `path` + query params.
  ///
  /// `queryParameters` is a normalized `Map<String, dynamic>` as provided
  /// by Dio's [RequestOptions.queryParameters]. The interceptor matches on
  /// path first, then narrows by query string for endpoints that need
  /// country / currency / category context.
  ///
  /// Pass `locale` to localize the response payload (e.g. `zh` swaps in
  /// strings from [MockDataZh]). Defaults to `en` for backwards
  /// compatibility with the existing call sites.
  static Map<String, dynamic> responseFor(
    String method,
    String path,
    Map<String, dynamic>? queryParameters, {
    String locale = 'en',
  }) {
    _currentLocale = locale;
    final key = '$method $path';
    switch (key) {
      case 'GET /policies':
        return _policiesFor(
          countryIso: _queryString(queryParameters, 'country'),
          reasonId: _queryString(queryParameters, 'reason'),
          cityId: _queryString(queryParameters, 'city'),
        );
      case 'GET /checklists':
        return _checklistFor(
          countryIso: _queryString(queryParameters, 'country'),
          reasonId: _queryString(queryParameters, 'reason'),
          cityId: _queryString(queryParameters, 'city'),
        );
      case 'GET /pois/search':
        return _poisFor(
          q: _queryString(queryParameters, 'q'),
          category: _queryString(queryParameters, 'category'),
          cityId: _queryString(queryParameters, 'city'),
        );
      case 'GET /discover/curated':
        return _discoverCurated();
      case 'GET /discover/authentic':
        return _discoverAuthentic();
      case 'GET /discover/heads-up':
        return _discoverHeadsUp();
      case 'GET /tools/fx-rates':
        return _fxRateFor(
          from: _queryString(queryParameters, 'from'),
          to: _queryString(queryParameters, 'to'),
        );
      case 'GET /me/preferences':
        return _preferences();
      case 'POST /corrections':
        return _correctionEcho();
      default:
        return emptyData;
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static String _queryString(Map<String, dynamic>? q, String key) {
    if (q == null) return '';
    final v = q[key];
    return v is String ? v : (v == null ? '' : v.toString());
  }

  static Map<String, dynamic> _wrap(List<Map<String, dynamic>> data) =>
      <String, dynamic>{
        'data': data,
        'meta': <String, dynamic>{
          'page': 1,
          'pageSize': data.length,
          'total': data.length,
        },
      };

  static Map<String, dynamic> _wrapObject(Map<String, dynamic> data) =>
      <String, dynamic>{
        'data': data,
        'meta': <String, dynamic>{'updatedAt': DateTime.now().toIso8601String()},
      };

  // ---------------------------------------------------------------------------
  // /policies  — entry, customs, consular, residence per country
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> _policiesFor({
    required String countryIso,
    required String reasonId,
    required String cityId,
  }) {
    final base = _policyCatalog[countryIso.toUpperCase()];
    if (base == null || base.isEmpty) {
      // Unknown country: surface the official fallback instead of pretending
      // we have data. UI shows the Empty state with a CTA to the official source.
      if (_isZh) {
        return _wrap(<Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'fallback-generic',
            'title': MockDataZh.policy['fallback-generic']!['title']!,
            'description':
                MockDataZh.policy['fallback-generic']!['description']!,
            'source': MockDataZh.fallbackSource,
            'country': '',
          },
        ]);
      }
      return _wrap(const <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'fallback-generic',
          'title': 'No policy details for this passport yet',
          'description':
              'Most travellers from your region need a tourist visa. '
              'Apply at your nearest Chinese embassy or consulate.',
          'source': 'www.nia.gov.cn (官方源) · Updated quarterly',
          'country': '',
        },
      ]);
    }

    // Localize consular info for the chosen city when present.
    final cards = <Map<String, dynamic>>[
      for (final raw in base)
        _localizeConsularForCity(raw, cityId),
    ];

    // Append reason-specific overlays (X1 student visa, Z work visa, Q family
    // visa, etc.). Tourism and business do not append anything because they
    // are already covered by the 30-day visa-free card.
    final overlay = _reasonOverlay(
      reasonId: reasonId,
      countryIso: countryIso.toUpperCase(),
    );
    cards.addAll(overlay);

    if (_isZh) {
      return _wrap(_localizePolicyCards(cards));
    }
    return _wrap(cards);
  }

  /// Replace `title` / `description` of every card that has a matching
  /// entry in [MockDataZh.policy]. Cards without a translation are
  /// returned unchanged.
  static List<Map<String, dynamic>> _localizePolicyCards(
    List<Map<String, dynamic>> cards,
  ) {
    return <Map<String, dynamic>>[
      for (final c in cards)
        if (c['id'] is String &&
            MockDataZh.policy[c['id'] as String] != null)
          <String, dynamic>{
            ...c,
            'title': MockDataZh.policy[c['id'] as String]!['title']!,
            'description':
                MockDataZh.policy[c['id'] as String]!['description']!,
          }
        else
          c,
    ];
  }

  static Map<String, dynamic> _localizeConsularForCity(
    Map<String, dynamic> raw,
    String cityId,
  ) {
    if (!raw['id'].toString().endsWith('-consular-contact')) return raw;
    // Chinese translations replace both the city suffix and the
    // `— Local presence —` header so the text reads naturally.
    if (_isZh) {
      final byCity = MockDataZh.consularByCity[cityId.toUpperCase()];
      if (byCity == null) return raw;
      final merged = StringBuffer(raw['description'] as String);
      merged.write('\n\n');
      merged.write(MockDataZh.consularHeader);
      merged.write('\n');
      merged.write(byCity);
      return <String, dynamic>{
        ...raw,
        'description': merged.toString(),
      };
    }
    final byCity = _consularByCity[cityId.toUpperCase()];
    if (byCity == null) return raw;
    // Merge city-specific address/phone into the description.
    final merged = StringBuffer(raw['description'] as String);
    merged.write('\n\n— Local presence —\n');
    merged.write(byCity);
    return <String, dynamic>{
      ...raw,
      'description': merged.toString(),
    };
  }

  /// Returns a list of additional policy cards driven by the entry reason.
  /// Empty list for `tourism` and `business` (visa-free covers them).
  static List<Map<String, dynamic>> _reasonOverlay({
    required String reasonId,
    required String countryIso,
  }) {
    final isoLower = countryIso.toLowerCase();
    switch (reasonId) {
      case 'education':
        return <Map<String, dynamic>>[
          <String, dynamic>{
            'id': '$isoLower-x1-visa',
            'title': 'X1 / X2 student visa',
            'description':
                'Apply at a Chinese embassy / consulate with your university\'s '
                'JW202 admission notice. X1 is for programs >180 days; X2 for '
                '≤180 days. After arrival you must apply for a residence '
                'permit within 30 days.',
            'source':
                'Ministry of Public Security · Exit-Entry Administration Law Art. 16-17',
            'country': countryIso,
          },
          <String, dynamic>{
            'id': '$isoLower-residence-permit-30d',
            'title': 'Residence permit within 30 days',
            'description':
                'Foreign students must visit the local Public Security Bureau '
                '(PSB / 出入境管理局) within 30 days to convert the X1 visa '
                'into a residence permit. Required documents: passport, JW202, '
                'JW201, admission letter, health certificate, photo.',
            'source':
                'State Immigration Administration · 公安部出入境管理局',
            'country': countryIso,
          },
        ];
      case 'work':
        return <Map<String, dynamic>>[
          <String, dynamic>{
            'id': '$isoLower-z-visa',
            'title': 'Z work visa + residence permit',
            'description':
                'Employer must obtain a Notification of Foreigner\'s Work '
                'Permit (外国人工作许可通知) before you apply for the Z visa. '
                'After arrival, you have 30 days to convert it into a '
                'residence permit at the local PSB.',
            'source':
                'Ministry of Human Resources · Work Permit Regulation 2017',
            'country': countryIso,
          },
        ];
      case 'family_visit':
        return <Map<String, dynamic>>[
          <String, dynamic>{
            'id': '$isoLower-q-visa',
            'title': 'Q family-visit visa',
            'description':
                'For visiting relatives who are Chinese citizens or permanent '
                'residents. Apply with an invitation letter from your family '
                'member and proof of relationship. Standard stay up to 180 days.',
            'source': 'National Immigration Administration · 探亲签证 Q',
            'country': countryIso,
          },
        ];
      default:
        return const <Map<String, dynamic>>[];
    }
  }

  /// Per-city consular localization snippet appended to the consular card.
  /// Currently empty stubs — content ops will populate city-specific
  /// addresses / hours as the offline packs come online.
  static const Map<String, String> _consularByCity = {
    'SH': '上海 · United States Consulate General · 1469 Huai Hai Road Central · '
        '021-8011-2400',
    'BJ': '北京 · United States Embassy · 55 An Jia Lou Road · 010-8531-3000',
    'GZ': '广州 · United States Consulate General · 43 Hua Jiu Road, Zhujiang New Town · '
        '020-3814-5000',
    'OTHER': '',
  };

  /// Master policy catalog keyed by passport ISO 3166-1 alpha-2 code.
  ///
  /// Each list contains 3–5 entries covering: visa eligibility, customs
  /// declaration, consular contact, and residence registration. Order is
  /// important — the first 3 entries are shown as cards on Prepare Home.
  static const Map<String, List<Map<String, dynamic>>> _policyCatalog = {
    'US': [
      <String, dynamic>{
        'id': 'us-visa-free-30d',
        'title': '30-day visa-free entry',
        'description':
            'U.S. passport holders may enter China visa-free for tourism / '
            'business / family visits for up to 30 days. The stay cannot be '
            'extended inside China for this category.',
        'source': 'China National Immigration Administration · 2024-11',
        'country': 'US',
      },
      <String, dynamic>{
        'id': 'us-customs-declare',
        'title': 'Customs declaration (red/green channel)',
        'description':
            'Use the green channel if you carry less than USD 500 in cash / '
            'equivalent and no restricted goods. Red channel is required for '
            'cash over USD 5,000, plant / animal products, or >20 cigarettes.',
        'source': 'General Administration of Customs of China · PRC Order 236',
        'country': 'US',
      },
      <String, dynamic>{
        'id': 'us-consular-contact',
        'title': 'U.S. consular assistance in Shanghai',
        'description':
            'U.S. Consulate General Shanghai: 1469 Huai Hai Road Central. '
            'Emergency line from China: 021-8011-2400 (after hours: 001-202-501-4444).',
        'source': 'travel.state.gov · Updated 2026-03',
        'country': 'US',
      },
      <String, dynamic>{
        'id': 'us-residence-register',
        'title': 'Residence registration for hotel guests',
        'description':
            'Hotels register foreign guests automatically with the local '
            'police station on check-in. No action required from you.',
        'source': 'Exit-Entry Administration Law, Article 39',
        'country': 'US',
      },
    ],
    'GB': [
      <String, dynamic>{
        'id': 'gb-visa-free-30d',
        'title': '30-day visa-free entry',
        'description':
            'U.K. passport holders may enter China visa-free for up to '
            '30 days for tourism / business. Not extendable in-country.',
        'source': 'China NIA · 2024-11',
        'country': 'GB',
      },
      <String, dynamic>{
        'id': 'gb-customs-declare',
        'title': 'Customs declaration (red/green channel)',
        'description':
            'Green if under GBP 500 cash equivalent and no restricted goods. '
            'Red channel required for cash over GBP 5,000, animal products '
            'or >20 cigarettes / 50 cigars.',
        'source': 'General Administration of Customs of China',
        'country': 'GB',
      },
      <String, dynamic>{
        'id': 'gb-consular-contact',
        'title': 'British consular assistance',
        'description':
            'British Consulate General Shanghai: 17F Garden Square, 968 West '
            'Beijing Road. Tel 021-3279-2000. 24h global line +44 20 7008 1500.',
        'source': 'gov.uk/foreign-travel-advice/china · Updated 2026-04',
        'country': 'GB',
      },
      <String, dynamic>{
        'id': 'gb-residence-register',
        'title': 'Hotel auto-registration',
        'description':
            'Hotels register you with the local police within 24 hours. No '
            'action required from the guest.',
        'source': 'Exit-Entry Administration Law, Article 39',
        'country': 'GB',
      },
    ],
    'JP': [
      <String, dynamic>{
        'id': 'jp-visa-free-30d',
        'title': '30-day visa-free entry',
        'description':
            'Japanese passport holders may enter visa-free for up to 30 days '
            'for tourism / business / family visits.',
        'source': 'China NIA · 2024-11',
        'country': 'JP',
      },
      <String, dynamic>{
        'id': 'jp-customs-declare',
        'title': '海关申告（赤・緑チャンネル）',
        'description':
            '現金 5,000USD 相当未満・制限品目なしで緑チャンネル。'
            '5,000USD 超・動植物製品・たばこ 20 本超は赤申告が必要。',
        'source': '中国税関総署 · PRC Order 236',
        'country': 'JP',
      },
      <String, dynamic>{
        'id': 'jp-consular-contact',
        'title': '日本国総領事館（在上海）',
        'description':
            '在 Shanghai 日本国総領事館: 延安西路 2299 号 (上海世貿商城 8 階). '
            '代表 021-5257-4766。緊急 +81-3-6636-9590 (日本国外務省).',
        'source': 'www.cn.emb-japan.go.jp · 2026-04 更新',
        'country': 'JP',
      },
      <String, dynamic>{
        'id': 'jp-residence-register',
        'title': 'ホテルが 24 時間以内に登録',
        'description':
            '中国の法律により、宿泊施設のフロントが 24 時間以内に '
            '最寄りの派出所へ外国人の宿泊情報を届け出ます。',
        'source': '出境入境管理法第 39 条',
        'country': 'JP',
      },
    ],
    'KR': [
      <String, dynamic>{
        'id': 'kr-visa-free-30d',
        'title': '30일 무사증 입국 가능',
        'description':
            '한국 여권 소지자는 관광·상용·가족방문 목적으로 30일까지 '
            '무비자 입국 가능합니다.',
        'source': '중국 국가이민관리국 · 2024-11',
        'country': 'KR',
      },
      <String, dynamic>{
        'id': 'kr-customs-declare',
        'title': '세관 신고 (적색·녹색 채널)',
        'description':
            '현금 USD 500 이하·제한 물품 없을 경우 녹색 채널. '
            'USD 5,000 초과 현금, 동식물 제품, 담배 20개비 초과 시 적색 신고.',
        'source': '중국 세관총서',
        'country': 'KR',
      },
      <String, dynamic>{
        'id': 'kr-consular-contact',
        'title': '주 상하이 대한민국 총영사관',
        'description':
            '주 상하이 총영사관: 황포구 남정로 58 호. 대표 021-6295-6000. '
            '긴급 +82-2-3210-0404 (서울 영사콜센터).',
        'source': 'overseas.mofa.go.kr · 2026-04 갱신',
        'country': 'KR',
      },
      <String, dynamic>{
        'id': 'kr-residence-register',
        'title': '호텔 자동 등록',
        'description':
            '체크인 시 호텔 프론트가 24시간 내 관할 파출소에 외국인 '
            '숙박 정보를 등록합니다.',
        'source': '출입국관리법 제39조',
        'country': 'KR',
      },
    ],
    'DE': [
      <String, dynamic>{
        'id': 'de-visa-free-30d',
        'title': '30-day visa-free entry',
        'description':
            'German passport holders may enter China visa-free for up to '
            '30 days for tourism / business / family visits.',
        'source': 'China NIA · 2024-11',
        'country': 'DE',
      },
      <String, dynamic>{
        'id': 'de-customs-declare',
        'title': 'Zollanmeldung (roter / grüner Kanal)',
        'description':
            'Grüner Kanal bei weniger als 5.000 EUR Bargeld und keinen '
            'verbotenen Waren. Ab 10.000 EUR bzw. bei tierischen/pflanzlichen '
            'Produkten muss der rote Kanal genutzt werden.',
        'source': 'Allgemeine Zollverwaltung der VR China',
        'country': 'DE',
      },
      <String, dynamic>{
        'id': 'de-consular-contact',
        'title': 'Deutsches Konsulat Shanghai',
        'description':
            'Deutsches Generalkonsulat Shanghai: 181 Yongfu Road. '
            'Tel 021-3401-0106. 24h-Notruf +49 30 5000 6000 (Berlin).',
        'source': 'china.diplo.de · Aktualisiert 2026-04',
        'country': 'DE',
      },
      <String, dynamic>{
        'id': 'de-residence-register',
        'title': 'Hotel meldet automatisch',
        'description':
            'Das Hotel meldet ausländische Gäste innerhalb von 24 Stunden '
            'bei der örtlichen Polizei. Sie müssen nichts tun.',
        'source': 'Aus- und Einreisegesetz, Art. 39',
        'country': 'DE',
      },
    ],
    'FR': [
      <String, dynamic>{
        'id': 'fr-visa-free-30d',
        'title': 'Entrée sans visa 30 jours',
        'description':
            'Les titulaires d\'un passeport français peuvent entrer en Chine '
            'sans visa jusqu\'à 30 jours (tourisme / affaires / famille).',
        'source': 'Administration nationale de l\'immigration de Chine · 2024-11',
        'country': 'FR',
      },
      <String, dynamic>{
        'id': 'fr-customs-declare',
        'title': 'Déclaration douanière (voie rouge / verte)',
        'description':
            'Voie verte sous 5 000 EUR en liquide et sans marchandises '
            'restreintes. Au-delà ou avec produits animaux/végétaux : voie rouge.',
        'source': 'Administration générale des douanes de Chine',
        'country': 'FR',
      },
      <String, dynamic>{
        'id': 'fr-consular-contact',
        'title': 'Consulat de France à Shanghai',
        'description':
            'Consulat général de France à Shanghai : 2/F, 88 Jianguo Road. '
            'Tél 021-6010-2400. Urgence +33 1 43 17 53 53 (Paris).',
        'source': 'cn.ambafrance.org · Mise à jour 2026-04',
        'country': 'FR',
      },
      <String, dynamic>{
        'id': 'fr-residence-register',
        'title': 'Enregistrement par l\'hôtel',
        'description':
            'L\'hôtel enregistre automatiquement votre séjour auprès du '
            'commissariat local sous 24 heures.',
        'source': 'Loi sur l\'immigration, article 39',
        'country': 'FR',
      },
    ],
    'AU': [
      <String, dynamic>{
        'id': 'au-visa-free-30d',
        'title': '30-day visa-free entry',
        'description':
            'Australian passport holders may enter China visa-free for up '
            'to 30 days for tourism / business / family visits.',
        'source': 'China NIA · 2024-11',
        'country': 'AU',
      },
      <String, dynamic>{
        'id': 'au-customs-declare',
        'title': 'Customs declaration',
        'description':
            'Green channel if under AUD 700 cash equivalent and no restricted '
            'goods. Declare any food, plant material or animal products.',
        'source': 'General Administration of Customs of China',
        'country': 'AU',
      },
      <String, dynamic>{
        'id': 'au-consular-contact',
        'title': 'Australian Consulate Shanghai',
        'description':
            'Australian Consulate-General Shanghai: 22F CITIC Square, 1168 '
            'Nanjing Road West. Tel 021-2215-5200. 24h +61 2 6261 3305.',
        'source': 'smartraveller.gov.au · Updated 2026-04',
        'country': 'AU',
      },
      <String, dynamic>{
        'id': 'au-residence-register',
        'title': 'Hotel auto-registration',
        'description':
            'Hotels register foreign guests automatically with the local '
            'police station. No action required.',
        'source': 'Exit-Entry Administration Law, Article 39',
        'country': 'AU',
      },
    ],
    'CA': [
      <String, dynamic>{
        'id': 'ca-visa-free-30d',
        'title': '30-day visa-free entry',
        'description':
            'Canadian passport holders may enter China visa-free for up to '
            '30 days for tourism / business / family visits.',
        'source': 'China NIA · 2024-11',
        'country': 'CA',
      },
      <String, dynamic>{
        'id': 'ca-customs-declare',
        'title': 'Customs declaration',
        'description':
            'Green channel if under CAD 700 cash equivalent and no restricted '
            'goods. Maple syrup, fresh fruit and dairy products must be declared.',
        'source': 'General Administration of Customs of China',
        'country': 'CA',
      },
      <String, dynamic>{
        'id': 'ca-consular-contact',
        'title': 'Canadian Consulate Shanghai',
        'description':
            'Consulate General of Canada in Shanghai: 8/F ECO City Building, '
            '1788 West Nanjing Road. Tel 021-3279-2800. Emergency +1 613 996 8885.',
        'source': 'travel.gc.ca · Updated 2026-04',
        'country': 'CA',
      },
      <String, dynamic>{
        'id': 'ca-residence-register',
        'title': 'Hotel auto-registration',
        'description':
            'Hotels register foreign guests with the local police station '
            'within 24 hours of check-in.',
        'source': 'Exit-Entry Administration Law, Article 39',
        'country': 'CA',
      },
    ],
    'IT': [
      <String, dynamic>{
        'id': 'it-visa-free-30d',
        'title': 'Ingresso senza visto fino a 30 giorni',
        'description':
            'I titolari di passaporto italiano possono entrare in Cina senza '
            'visto fino a 30 giorni per turismo / affari / visita familiare.',
        'source': 'Amministrazione Nazionale Immigrazione Cina · 2024-11',
        'country': 'IT',
      },
      <String, dynamic>{
        'id': 'it-customs-declare',
        'title': 'Dichiarazione doganale (canale rosso / verde)',
        'description':
            'Canale verde sotto 5.000 EUR in contanti e senza merci '
            'sottoposte a restrizione. Oltre tale soglia o con prodotti '
            'animali/vegetali: canale rosso.',
        'source': 'Amministrazione Generale delle Dogane',
        'country': 'IT',
      },
      <String, dynamic>{
        'id': 'it-consular-contact',
        'title': 'Consolato d\'Italia a Shanghai',
        'description':
            'Consolato Generale d\'Italia: 2/F, 989 Changle Road. '
            'Tel 021-5407-5588. Emergenza +39 06 36225 (Roma).',
        'source': 'consshanghai.esteri.it · Aggiornato 2026-04',
        'country': 'IT',
      },
      <String, dynamic>{
        'id': 'it-residence-register',
        'title': 'Registrazione automatica hotel',
        'description':
            'L\'hotel registra automaticamente gli ospiti stranieri presso '
            'il commissariato locale entro 24 ore.',
        'source': 'Legge immigrazione, articolo 39',
        'country': 'IT',
      },
    ],
    'RU': [
      <String, dynamic>{
        'id': 'ru-visa-required',
        'title': 'Tourist visa required',
        'description':
            'Russian passport holders must obtain a Chinese tourist (L) visa '
            'from a Chinese embassy or consulate before departure. Visa-free '
            'groups are available for specific border crossings.',
        'source': 'China NIA · Consular Department of the MFA',
        'country': 'RU',
      },
      <String, dynamic>{
        'id': 'ru-customs-declare',
        'title': 'Таможенная декларация',
        'description':
            'Зелёный коридор при наличных до 5 000 USD в эквиваленте и '
            'отсутствии ограниченных товаров. Свыше — красный коридор.',
        'source': 'Главное таможенное управление КНР',
        'country': 'RU',
      },
      <String, dynamic>{
        'id': 'ru-consular-contact',
        'title': 'Консульство РФ в Шанхае',
        'description':
            'Генеральное консульство РФ в Шанхае: ул. Хуанпо, 20. '
            'Тел 021-6326-8383 / 6324-2682. Экстренная линия +7 495 244 4577.',
        'source': 'russia.shanghai.consular.mid.ru · Обновлено 2026-04',
        'country': 'RU',
      },
      <String, dynamic>{
        'id': 'ru-residence-register',
        'title': 'Регистрация в полиции',
        'description':
            'Иностранный гражданин обязан встать на миграционный учёт в '
            'течение 24 часов (отели оформляют самостоятельно). При '
            'съёмном жилье — через принимающую сторону.',
        'source': 'Закон КНР о въезде-выезде, статья 39',
        'country': 'RU',
      },
    ],
  };

  // ---------------------------------------------------------------------------
  // /checklists
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> _checklistFor({
    required String countryIso,
    required String reasonId,
    required String cityId,
  }) {
    // Universal base list shared by every country / reason / city.
    final list = <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'passport-validity',
        'title':
            'Check passport has at least 6 months validity beyond entry date',
        'done': false,
      },
      <String, dynamic>{
        'id': 'return-ticket',
        'title':
            'Have proof of onward/return ticket (flight, train or bus out of China)',
        'done': false,
      },
      <String, dynamic>{
        'id': 'hotel-booking',
        'title':
            'Save hotel address in Chinese characters — show it to taxi drivers',
        'done': false,
      },
      <String, dynamic>{
        'id': 'travel-insurance',
        'title':
            'Buy travel insurance covering medical evacuation (recommended)',
        'done': false,
      },
      <String, dynamic>{
        'id': 'offline-pack',
        'title': 'Download the offline pack for your first-arrival city before departure',
        'done': false,
      },
      <String, dynamic>{
        'id': 'cash-mix',
        'title':
            'Carry a small amount of CNY cash (¥500–¥1000) for the first 24h',
        'done': false,
      },
      <String, dynamic>{
        'id': 'phrases-saved',
        'title':
            'Save at least 10 emergency phrases in Tools → Phrase book',
        'done': false,
      },
      <String, dynamic>{
        'id': 'embassy-saved',
        'title':
            'Save your country\'s consular emergency number to your phone home screen',
        'done': false,
      },
      <String, dynamic>{
        'id': '24h-registration',
        'title':
            'On arrival: confirm the hotel has registered your stay with the local police station within 24h',
        'done': false,
      },
    ];

    final iso = countryIso.toUpperCase();

    // Country-specific extras: RU must apply for an L visa.
    if (iso == 'RU') {
      list.insert(
        2,
        const <String, dynamic>{
          'id': 'visa-application',
          'title':
              'Apply for Chinese tourist (L) visa at least 4 weeks before departure',
          'done': false,
        },
      );
    }

    // Reason-specific extras.
    switch (reasonId) {
      case 'education':
        list.insertAll(3, const <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'university-documents',
            'title':
                'Carry JW202 + JW201 admission forms (issued by your university)',
            'done': false,
          },
          <String, dynamic>{
            'id': 'health-checkup',
            'title':
                'Complete the mandatory health checkup at a designated hospital within 24h of arrival',
            'done': false,
          },
          <String, dynamic>{
            'id': 'residence-permit-30d',
            'title':
                'Book a PSB appointment within 30 days to convert X1 visa to residence permit',
            'done': false,
          },
        ]);
        break;
      case 'work':
        list.insertAll(3, const <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'work-permit-notification',
            'title':
                'Carry the Notification of Foreigner\'s Work Permit from your employer',
            'done': false,
          },
          <String, dynamic>{
            'id': 'residence-permit-30d',
            'title':
                'Book a PSB appointment within 30 days to convert Z visa to residence permit',
            'done': false,
          },
        ]);
        break;
      case 'family_visit':
        list.insert(
          3,
          const <String, dynamic>{
            'id': 'invitation-letter',
            'title':
                'Bring the Q-visa invitation letter from your family member in China',
            'done': false,
          },
        );
        break;
    }

    // City-specific extras (only Beijing / Shanghai / Guangzhou have rich data).
    if (cityId.toUpperCase() == 'BJ') {
      list.insert(
        list.length - 1,
        const <String, dynamic>{
          'id': 'bj-psb-address',
          'title':
              'Bookmark Beijing PSB Exit-Entry Administration (东城区安定门东大街2号)',
          'done': false,
        },
      );
    } else if (cityId.toUpperCase() == 'GZ') {
      list.insert(
        list.length - 1,
        const <String, dynamic>{
          'id': 'gz-psb-address',
          'title':
              'Bookmark Guangzhou PSB Exit-Entry Administration (天河区中山大道中803号)',
          'done': false,
        },
      );
    } else if (cityId.toUpperCase() == 'OTHER') {
      list.add(const <String, dynamic>{
        'id': 'other-city-notice',
        'title':
            'Find the local PSB (出入境管理局) address for your first-arrival city once you land',
        'done': false,
      });
    }

    if (_isZh) {
      return _wrap(_localizeChecklist(list));
    }
    return _wrap(list);
  }

  /// Replace `title` of every checklist item that has a matching entry
  /// in [MockDataZh.checklist]. Items without a translation are returned
  /// unchanged. `id` and `done` are preserved.
  static List<Map<String, dynamic>> _localizeChecklist(
    List<Map<String, dynamic>> list,
  ) {
    return <Map<String, dynamic>>[
      for (final c in list)
        if (c['id'] is String &&
            MockDataZh.checklist[c['id'] as String] != null)
          <String, dynamic>{
            ...c,
            'title': MockDataZh.checklist[c['id'] as String]!,
          }
        else
          c,
    ];
  }

  // ---------------------------------------------------------------------------
  // /pois/search
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> _poisFor({
    String q = '',
    String category = '',
    String cityId = '',
  }) {
    // Pick the city-specific POI pool. Unknown / OTHER falls back to Shanghai.
    final pool = _poiPools[cityId.toUpperCase()] ?? _poiPools['SH']!;
    final all = pool;
    final lowerQ = q.toLowerCase();
    Iterable<Map<String, dynamic>> filtered = all;
    if (category.isNotEmpty && category != 'all') {
      filtered = filtered.where((p) => p['category'] == category);
    }
    if (lowerQ.isNotEmpty) {
      filtered = filtered.where((p) {
        final name = (p['name'] as String).toLowerCase();
        return name.contains(lowerQ);
      });
    }
    final results = filtered.toList();
    if (_isZh) {
      return _wrap(_localizePois(results));
    }
    return _wrap(results);
  }

  /// Replace `name` of every POI that has a matching entry in
  /// [MockDataZh.poi]. `category`, `distanceKm`, `avgScore` are preserved.
  /// When a Chinese name is available, the search filter applied above
  /// is re-run so Chinese-character queries continue to match against
  /// the localized name.
  static List<Map<String, dynamic>> _localizePois(
    List<Map<String, dynamic>> pois,
  ) {
    return <Map<String, dynamic>>[
      for (final p in pois)
        if (p['id'] is String && MockDataZh.poi[p['id'] as String] != null)
          <String, dynamic>{
            ...p,
            'name': MockDataZh.poi[p['id'] as String]!,
          }
        else
          p,
    ];
  }

  /// City-keyed POI pools. Each entry is `List<Map>` of the same shape consumed
  /// by `Poi.fromJson`. Mock data only — production will pull from the offline
  /// pack manifest.
  static const Map<String, List<Map<String, dynamic>>> _poiPools = {
    'SH': [
      <String, dynamic>{
        'id': 'poi-bund',
        'name': 'The Bund (外滩)',
        'category': 'attraction',
        'distanceKm': 0.6,
        'avgScore': 4.7,
      },
      <String, dynamic>{
        'id': 'poi-yu-garden',
        'name': 'Yu Garden (豫园)',
        'category': 'attraction',
        'distanceKm': 1.1,
        'avgScore': 4.4,
      },
      <String, dynamic>{
        'id': 'poi-oriental-pearl',
        'name': 'Oriental Pearl Tower',
        'category': 'attraction',
        'distanceKm': 1.8,
        'avgScore': 4.1,
      },
      <String, dynamic>{
        'id': 'poi-nanjing-road',
        'name': 'Nanjing Road Pedestrian Street',
        'category': 'shopping',
        'distanceKm': 0.9,
        'avgScore': 4.2,
      },
      <String, dynamic>{
        'id': 'poi-xintiandi',
        'name': 'Xintiandi',
        'category': 'dining',
        'distanceKm': 2.3,
        'avgScore': 4.3,
      },
      <String, dynamic>{
        'id': 'poi-tianzifang',
        'name': 'Tianzifang',
        'category': 'attraction',
        'distanceKm': 2.8,
        'avgScore': 4.5,
      },
      <String, dynamic>{
        'id': 'poi-french-concession',
        'name': 'Former French Concession walk',
        'category': 'attraction',
        'distanceKm': 3.4,
        'avgScore': 4.6,
      },
      <String, dynamic>{
        'id': 'poi-jingan-temple',
        'name': "Jing'an Temple (静安寺)",
        'category': 'attraction',
        'distanceKm': 4.1,
        'avgScore': 4.4,
      },
      <String, dynamic>{
        'id': 'poi-shanghai-museum',
        'name': 'Shanghai Museum',
        'category': 'attraction',
        'distanceKm': 1.3,
        'avgScore': 4.6,
      },
      <String, dynamic>{
        'id': 'poi-lost-heaven',
        'name': 'Lost Heaven (花马天堂)',
        'category': 'dining',
        'distanceKm': 1.7,
        'avgScore': 4.5,
      },
      <String, dynamic>{
        'id': 'poi-jia-jia-tang-bao',
        'name': 'Jia Jia Tang Bao (佳家汤包)',
        'category': 'dining',
        'distanceKm': 2.0,
        'avgScore': 4.4,
      },
      <String, dynamic>{
        'id': 'poi-peninsula',
        'name': 'The Peninsula Shanghai',
        'category': 'lodging',
        'distanceKm': 0.8,
        'avgScore': 4.7,
      },
      <String, dynamic>{
        'id': 'poi-amani',
        'name': 'Aman Shanghai (养云安缦)',
        'category': 'lodging',
        'distanceKm': 17.5,
        'avgScore': 4.8,
      },
      <String, dynamic>{
        'id': 'poi-global-harbor',
        'name': 'Global Harbor mall',
        'category': 'shopping',
        'distanceKm': 6.2,
        'avgScore': 4.0,
      },
      <String, dynamic>{
        'id': 'poi-apple-pudong',
        'name': 'Apple Store Pudong',
        'category': 'shopping',
        'distanceKm': 4.5,
        'avgScore': 4.3,
      },
    ],
    'BJ': [
      <String, dynamic>{
        'id': 'poi-forbidden-city',
        'name': 'The Forbidden City (故宫)',
        'category': 'attraction',
        'distanceKm': 1.0,
        'avgScore': 4.8,
      },
      <String, dynamic>{
        'id': 'poi-temple-of-heaven',
        'name': 'Temple of Heaven (天坛)',
        'category': 'attraction',
        'distanceKm': 5.2,
        'avgScore': 4.7,
      },
      <String, dynamic>{
        'id': 'poi-great-wall-mutianyu',
        'name': 'Great Wall · Mutianyu section',
        'category': 'attraction',
        'distanceKm': 73.0,
        'avgScore': 4.9,
      },
      <String, dynamic>{
        'id': 'poi-summer-palace',
        'name': 'Summer Palace (颐和园)',
        'category': 'attraction',
        'distanceKm': 15.0,
        'avgScore': 4.7,
      },
      <String, dynamic>{
        'id': 'poi-wangfujing',
        'name': 'Wangfujing Snack Street',
        'category': 'dining',
        'distanceKm': 1.4,
        'avgScore': 4.2,
      },
      <String, dynamic>{
        'id': 'poi-peking-duck-da-dong',
        'name': 'Da Dong Roast Duck (大董)',
        'category': 'dining',
        'distanceKm': 2.6,
        'avgScore': 4.6,
      },
      <String, dynamic>{
        'id': 'poi-sanlitun',
        'name': 'Sanlitun Taikoo Li',
        'category': 'shopping',
        'distanceKm': 4.5,
        'avgScore': 4.5,
      },
      <String, dynamic>{
        'id': 'poi-rosewood-bj',
        'name': 'Rosewood Beijing',
        'category': 'lodging',
        'distanceKm': 4.7,
        'avgScore': 4.7,
      },
    ],
    'GZ': [
      <String, dynamic>{
        'id': 'poi-canton-tower',
        'name': 'Canton Tower (广州塔)',
        'category': 'attraction',
        'distanceKm': 4.8,
        'avgScore': 4.5,
      },
      <String, dynamic>{
        'id': 'poi-chen-clan',
        'name': 'Chen Clan Ancestral Hall (陈家祠)',
        'category': 'attraction',
        'distanceKm': 3.0,
        'avgScore': 4.4,
      },
      <String, dynamic>{
        'id': 'poi-shamian',
        'name': 'Shamian Island (沙面岛)',
        'category': 'attraction',
        'distanceKm': 5.3,
        'avgScore': 4.5,
      },
      <String, dynamic>{
        'id': 'poi-baiyun-mountain',
        'name': 'Baiyun Mountain (白云山)',
        'category': 'attraction',
        'distanceKm': 7.2,
        'avgScore': 4.6,
      },
      <String, dynamic>{
        'id': 'poi-taotaoju',
        'name': 'Tao Tao Ju (陶陶居) dim sum',
        'category': 'dining',
        'distanceKm': 2.7,
        'avgScore': 4.5,
      },
      <String, dynamic>{
        'id': 'poi-beijing-road',
        'name': 'Beijing Road Pedestrian Street',
        'category': 'shopping',
        'distanceKm': 2.4,
        'avgScore': 4.2,
      },
      <String, dynamic>{
        'id': 'poi-mandarin-orchard-gz',
        'name': 'Mandarin Oriental Guangzhou',
        'category': 'lodging',
        'distanceKm': 5.6,
        'avgScore': 4.7,
      },
    ],
    'OTHER': [
      <String, dynamic>{
        'id': 'poi-fallback',
        'name': 'No offline POIs for this city yet',
        'category': 'attraction',
        'distanceKm': 0.0,
        'avgScore': 0.0,
      },
    ],
  };

  // ---------------------------------------------------------------------------
  // /discover/*
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> _discoverCurated() {
    if (_isZh) {
      return _wrap(_cloneZhDiscoverList('curated'));
    }
    return _wrap(const <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'cur-1',
        'title': "Editor's Top 10 in Shanghai",
        'subtitle': 'Hand-picked by our local editors · updated monthly',
        'score': 4.8,
      },
      <String, dynamic>{
        'id': 'cur-2',
        'title': 'First-time visitor essentials',
        'subtitle': 'What every first-time visitor should see in 72 hours',
        'score': 4.6,
      },
      <String, dynamic>{
        'id': 'cur-3',
        'title': 'Best of Pudong & Lujiazui',
        'subtitle': 'Skyline views and modern Shanghai essentials',
        'score': 4.5,
      },
      <String, dynamic>{
        'id': 'cur-4',
        'title': 'Family-friendly in Shanghai',
        'subtitle': 'Stroller-friendly routes, kid menus, shaded walks',
        'score': 4.4,
      },
    ]);
  }

  static Map<String, dynamic> _discoverAuthentic() {
    if (_isZh) {
      return _wrap(_cloneZhDiscoverList('authentic'));
    }
    return _wrap(const <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'auth-1',
        'title': 'Local noodle spots (not on TripAdvisor)',
        'subtitle': 'Verified by local writers · 8 hand-picked shops',
        'score': 4.7,
      },
      <String, dynamic>{
        'id': 'auth-2',
        'title': 'Old town teahouses',
        'subtitle': 'Quiet spots that locals actually go to',
        'score': 4.5,
      },
      <String, dynamic>{
        'id': 'auth-3',
        'title': 'Late-night food streets',
        'subtitle': 'Where the city eats after 22:00',
        'score': 4.6,
      },
    ]);
  }

  static Map<String, dynamic> _discoverHeadsUp() {
    if (_isZh) {
      return _wrap(_cloneZhDiscoverList('heads-up'));
    }
    return _wrap(const <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'hu-1',
        'title': 'Bund crowds at sunset',
        'subtitle': 'Arrive 30 min before sunset or expect a wall of people',
        'score': 4.0,
      },
      <String, dynamic>{
        'id': 'hu-2',
        'title': 'Taxi meters & scams',
        'subtitle': 'How to spot an unmetered cab and what to do',
        'score': 4.3,
      },
      <String, dynamic>{
        'id': 'hu-3',
        'title': 'Alipay & WeChat Pay onboarding',
        'subtitle': 'Most vendors no longer take foreign cards — set this up first',
        'score': 4.5,
      },
      <String, dynamic>{
        'id': 'hu-4',
        'title': 'Public-holiday closures',
        'subtitle': 'What closes during Golden Week, Spring Festival, etc.',
        'score': 4.1,
      },
    ]);
  }

  /// Returns a mutable copy of the [MockDataZh.discover] list for the
  /// given key. The original `const` list cannot be passed back to
  /// `_wrap` (which expects `List<Map<String, dynamic>>` mutable for
  /// `.map(...)` consumers), so we shallow-copy each entry.
  static List<Map<String, dynamic>> _cloneZhDiscoverList(String key) {
    final src = MockDataZh.discover[key] ?? const <Map<String, dynamic>>[];
    return <Map<String, dynamic>>[for (final m in src) <String, dynamic>{...m}];
  }

  // ---------------------------------------------------------------------------
  // /tools/fx-rates
  // ---------------------------------------------------------------------------

  /// Baseline rates against CNY, expressed as `1 unit of from = X CNY`.
  /// `updatedAt` is intentionally fixed so tests stay deterministic; in
  /// production the backend would return the server timestamp.
  static const String _fxUpdatedAt = '2026-06-26T08:00:00Z';

  static Map<String, dynamic> _fxRateFor({String from = '', String to = ''}) {
    const rates = <String, double>{
      'USD_CNY': 7.18,
      'EUR_CNY': 7.84,
      'GBP_CNY': 9.12,
      'JPY_CNY': 0.045,
      'KRW_CNY': 0.0053,
      'AUD_CNY': 4.72,
      'CAD_CNY': 5.26,
      'CNY_CNY': 1.0,
    };
    final key = '${from.toUpperCase()}_${to.toUpperCase()}';
    final rate = rates[key] ?? _fallbackRate(from, to);
    return _wrapObject(<String, dynamic>{
      'from': from.toUpperCase(),
      'to': to.toUpperCase(),
      'rate': rate,
      'updatedAt': _fxUpdatedAt,
    });
  }

  static double _fallbackRate(String from, String to) {
    if (from.toUpperCase() == to.toUpperCase()) return 1.0;
    // Try inverted lookup before giving up.
    const rates = <String, double>{
      'USD_CNY': 7.18,
      'EUR_CNY': 7.84,
      'GBP_CNY': 9.12,
      'JPY_CNY': 0.045,
      'KRW_CNY': 0.0053,
      'AUD_CNY': 4.72,
      'CAD_CNY': 5.26,
    };
    final inverse = rates['${to.toUpperCase()}_${from.toUpperCase()}'];
    if (inverse != null && inverse != 0) return 1 / inverse;
    return 1.0;
  }

  // ---------------------------------------------------------------------------
  // /me/preferences
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> _preferences() => _wrapObject(<String, dynamic>{
        'locale': 'en',
        'themeMode': 'system',
        'country': 'US',
        'unitSystem': 'metric',
        'pushEnabled': false,
        'offlinePackVersion': 'shanghai-core-2026-06-20',
        'lastSyncAt': _fxUpdatedAt,
      });

  // ---------------------------------------------------------------------------
  // /corrections
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> _correctionEcho() => _wrapObject(<String, dynamic>{
        'id': 'corr-${DateTime.now().millisecondsSinceEpoch}',
        'status': 'queued',
        'reviewSlaHours': 48,
        'message':
            'Thanks — we\'ll review within 48 hours. 已收到，48 小时内审核。',
      });
}
