/// Chinese (zh) translations for the canned mock responses produced by
/// [MockData] / [MockInterceptor]. The interceptor switches the response
/// payload to these strings when [LocaleCubit] reports a `zh` locale.
///
/// Translations are organized so the interceptor can look them up by `id`:
///   * [policy]    — keyed by policy card id (e.g. `us-visa-free-30d`)
///   * [checklist] — keyed by checklist item id (e.g. `passport-validity`)
///   * [poi]       — keyed by POI id (e.g. `poi-bund`), replaces only `name`
///   * [discover]  — full replacement for `/discover/*` endpoints
///   * [consularByCity] — full replacement for the city suffix appended
///     to the consular card description
///   * [fallbackSource] — replaces the `source` of the fallback card
///
/// All collections are compile-time `const` so the interceptor does not
/// pay allocation cost per request.
library;

class MockDataZh {
  MockDataZh._();

  /// Policy card translations. Each entry replaces `title` and
  /// `description` of a policy card with the matching `id`. The English
  /// `source` and `country` fields are kept as-is.
  static const Map<String, Map<String, String>> policy =
      <String, Map<String, String>>{
    'us-visa-free-30d': {
      'title': '30 天免签入境',
      'description':
          '美国护照持有人可以免签入境中国，进行旅游 / 商务 / 探亲活动，'
          '最长停留 30 天。此类签证无法在中国境内延期。',
    },
    'us-customs-declare': {
      'title': '海关申报（红绿通道）',
      'description':
          '如携带现金折合 500 美元以下且无任何违禁品，可走绿色通道。'
          '携带现金 5,000 美元以上、动植物产品或超过 20 支香烟必须走红色通道申报。',
    },
    'us-consular-contact': {
      'title': '美国驻上海领事馆',
      'description':
          '美国驻上海总领事馆：淮海中路 1469 号。'
          '馆内电话 021-8011-2400（夜间紧急：001-202-501-4444）。',
    },
    'us-residence-register': {
      'title': '酒店住宿登记',
      'description':
          '酒店会在你入住时自动向当地派出所登记外国人住宿信息，'
          '你无需自行办理。',
    },
    'gb-visa-free-30d': {
      'title': '30 天免签入境',
      'description':
          '英国护照持有人可以免签入境中国，最长停留 30 天，'
          '仅限旅游 / 商务。无法在中国境内延期。',
    },
    'gb-customs-declare': {
      'title': '海关申报（红绿通道）',
      'description':
          '现金折合 500 英镑以下且无违禁品可走绿色通道。'
          '现金 5,000 英镑以上、动物制品或超过 20 支香烟 / 50 支雪茄必须走红色通道。',
    },
    'gb-consular-contact': {
      'title': '英国驻上海领事馆',
      'description':
          '英国驻上海总领事馆：南京西路 968 号花园广场 17 楼。'
          '电话 021-3279-2000。24 小时全球热线 +44 20 7008 1500。',
    },
    'gb-residence-register': {
      'title': '酒店自动登记',
      'description':
          '酒店会在 24 小时内将你的住宿信息登记到当地派出所，'
          '你无需自行办理。',
    },
    'jp-visa-free-30d': {
      'title': '30 天免签入境',
      'description':
          '日本护照持有人可以免签入境中国，进行旅游 / 商务 / 探亲活动，'
          '最长停留 30 天。',
    },
    'jp-customs-declare': {
      'title': '海关申报（红绿通道）',
      'description':
          '现金折合 5,000 美元以下且无违禁品可走绿色通道。'
          '现金 5,000 美元以上、动植物产品或超过 20 支香烟必须走红色通道申报。',
    },
    'jp-consular-contact': {
      'title': '日本驻上海总领事馆',
      'description':
          '日本驻上海总领事馆：延安西路 2299 号（上海世贸商城 8 楼）。'
          '代表 021-5257-4766。紧急 +81-3-6636-9590（日本国外务省）。',
    },
    'jp-residence-register': {
      'title': '酒店 24 小时内自动登记',
      'description':
          '根据中国法律，酒店前台会在 24 小时内将外国人的住宿信息登记至'
          '当地派出所。',
    },
    'kr-visa-free-30d': {
      'title': '免签 30 天入境',
      'description':
          '持有韩国护照的旅客可以免签证入境中国，进行旅游、商务或探亲活动，'
          '最长停留 30 天。',
    },
    'kr-customs-declare': {
      'title': '海关申报（红绿通道）',
      'description':
          '现金折合 500 美元以下且无违禁物品可走绿色通道。'
          '5,000 美元以上现金、动植物产品或超过 20 支香烟须走红色通道申报。',
    },
    'kr-consular-contact': {
      'title': '驻上海韩国总领事馆',
      'description':
          '驻上海韩国总领事馆：黄浦区南靖路 58 号。'
          '代表 021-6295-6000。紧急 +82-2-3210-0404（首尔领事呼叫中心）。',
    },
    'kr-residence-register': {
      'title': '酒店自动登记',
      'description':
          '入住时，酒店前台会在 24 小时内将外国人的住宿信息登记至'
          '辖区派出所。',
    },
    'de-visa-free-30d': {
      'title': '30 天免签入境',
      'description':
          '德国护照持有人可以免签入境中国，进行旅游 / 商务 / 探亲活动，'
          '最长停留 30 天。',
    },
    'de-customs-declare': {
      'title': '海关申报（红绿通道）',
      'description':
          '现金折合 5,000 欧元以下且无违禁品可走绿色通道。'
          '5,000 欧元以上、动植物产品或受管制商品须走红色通道。',
    },
    'de-consular-contact': {
      'title': '德国驻上海领事馆',
      'description':
          '德国驻上海总领事馆：永福路 181 号。'
          '电话 021-3401-0106。24 小时紧急 +49 30 5000 6000（柏林）。',
    },
    'de-residence-register': {
      'title': '酒店自动登记',
      'description':
          '酒店会在 24 小时内将外国住客的住宿信息登记至当地派出所，'
          '你无需亲自办理。',
    },
    'fr-visa-free-30d': {
      'title': '免签入境 30 天',
      'description':
          '法国护照持有人可以免签入境中国，进行旅游 / 商务 / 探亲活动，'
          '最长停留 30 天。',
    },
    'fr-customs-declare': {
      'title': '海关申报（红绿通道）',
      'description':
          '现金折合 5,000 欧元以下且无违禁品可走绿色通道。'
          '超过此金额或携带动植物产品须走红色通道。',
    },
    'fr-consular-contact': {
      'title': '法国驻上海领事馆',
      'description':
          '法国驻上海总领事馆：建国路 88 号 2 楼。'
          '电话 021-6010-2400。紧急 +33 1 43 17 53 53（巴黎）。',
    },
    'fr-residence-register': {
      'title': '酒店自动登记',
      'description':
          '酒店会在 24 小时内将你的住宿信息自动登记至当地派出所。',
    },
    'au-visa-free-30d': {
      'title': '30 天免签入境',
      'description':
          '澳大利亚护照持有人可以免签入境中国，进行旅游 / 商务 / 探亲活动，'
          '最长停留 30 天。',
    },
    'au-customs-declare': {
      'title': '海关申报',
      'description':
          '现金折合 700 澳元以下且无违禁品可走绿色通道。'
          '食品、植物或动物制品必须申报。',
    },
    'au-consular-contact': {
      'title': '澳大利亚驻上海领事馆',
      'description':
          '澳大利亚驻上海总领事馆：南京西路 1168 号中信泰富广场 22 楼。'
          '电话 021-2215-5200。24 小时 +61 2 6261 3305。',
    },
    'au-residence-register': {
      'title': '酒店自动登记',
      'description':
          '酒店会在入住时自动将外国人住宿信息登记至当地派出所，'
          '你无需亲自办理。',
    },
    'ca-visa-free-30d': {
      'title': '30 天免签入境',
      'description':
          '加拿大护照持有人可以免签入境中国，进行旅游 / 商务 / 探亲活动，'
          '最长停留 30 天。',
    },
    'ca-customs-declare': {
      'title': '海关申报',
      'description':
          '现金折合 700 加元以下且无违禁品可走绿色通道。'
          '枫糖浆、新鲜水果和乳制品必须申报。',
    },
    'ca-consular-contact': {
      'title': '加拿大驻上海领事馆',
      'description':
          '加拿大驻上海总领事馆：南京西路 1788 号国际中心 8 楼。'
          '电话 021-3279-2800。紧急 +1 613 996 8885。',
    },
    'ca-residence-register': {
      'title': '酒店自动登记',
      'description':
          '酒店会在入住后 24 小时内将外国住客的住宿信息登记至当地派出所。',
    },
    'it-visa-free-30d': {
      'title': '免签入境 30 天',
      'description':
          '意大利护照持有人可以免签入境中国，进行旅游 / 商务 / 探亲活动，'
          '最长停留 30 天。',
    },
    'it-customs-declare': {
      'title': '海关申报（红绿通道）',
      'description':
          '现金 5,000 欧元以下且无违禁品可走绿色通道。'
          '超过此金额或携带动植物产品须走红色通道。',
    },
    'it-consular-contact': {
      'title': '意大利驻上海领事馆',
      'description':
          '意大利驻上海总领事馆：长乐路 989 号 2 楼。'
          '电话 021-5407-5588。紧急 +39 06 36225（罗马）。',
    },
    'it-residence-register': {
      'title': '酒店自动登记',
      'description':
          '酒店会在 24 小时内将外国住客的住宿信息自动登记至当地派出所。',
    },
    'ru-visa-required': {
      'title': '需要办理旅游签证',
      'description':
          '俄罗斯护照持有人必须出发前在中国大使馆或领事馆办理中国旅游签证'
          '（L 签证）。部分边境口岸提供团体免签。',
    },
    'ru-customs-declare': {
      'title': '海关申报',
      'description':
          '现金折合 5,000 美元以下且无违禁品可走绿色通道。'
          '超过此金额须走红色通道。',
    },
    'ru-consular-contact': {
      'title': '俄罗斯驻上海领事馆',
      'description':
          '俄罗斯驻上海总领事馆：黄浦路 20 号。'
          '电话 021-6326-8383 / 6324-2682。紧急 +7 495 244 4577。',
    },
    'ru-residence-register': {
      'title': '住宿登记',
      'description':
          '外国公民必须在 24 小时内办理住宿登记（酒店会代为办理）。'
          '租住房屋须通过接待方办理。',
    },
    // Education / Work / Family overlays — same text for every country.
    'us-x1-visa': {
      'title': 'X1 / X2 学生签证',
      'description':
          '持大学录取通知（JW202 表）向中国大使馆 / 领事馆申请。'
          'X1 用于 180 天以上学习，X2 用于 180 天以下。'
          '入境后须在 30 天内向当地出入境管理局申请居留许可。',
    },
    'us-residence-permit-30d': {
      'title': '30 天内办理居留许可',
      'description':
          '留学生须在 30 天内到当地公安局出入境管理局（PSB）'
          '将 X1 签证转换为居留许可。所需材料：护照、JW202、JW201、'
          '录取通知书、健康证明、照片。',
    },
    'us-z-visa': {
      'title': 'Z 工作签证 + 居留许可',
      'description':
          '雇主须先获得《外国人工作许可通知》，然后你才能申请 Z 签证。'
          '入境后 30 天内需在 PSB 将其转换为居留许可。',
    },
    'us-q-visa': {
      'title': 'Q 探亲签证',
      'description':
          '用于探望中国公民或永久居民亲属。申请时需提供亲属的邀请函及'
          '关系证明。最长停留 180 天。',
    },
    'gb-x1-visa': {
      'title': 'X1 / X2 学生签证',
      'description':
          '持大学录取通知（JW202 表）向中国大使馆 / 领事馆申请。'
          'X1 用于 180 天以上学习，X2 用于 180 天以下。'
          '入境后须在 30 天内向当地出入境管理局申请居留许可。',
    },
    'gb-residence-permit-30d': {
      'title': '30 天内办理居留许可',
      'description':
          '留学生须在 30 天内到当地公安局出入境管理局（PSB）'
          '将 X1 签证转换为居留许可。所需材料：护照、JW202、JW201、'
          '录取通知书、健康证明、照片。',
    },
    'gb-z-visa': {
      'title': 'Z 工作签证 + 居留许可',
      'description':
          '雇主须先获得《外国人工作许可通知》，然后你才能申请 Z 签证。'
          '入境后 30 天内需在 PSB 将其转换为居留许可。',
    },
    'gb-q-visa': {
      'title': 'Q 探亲签证',
      'description':
          '用于探望中国公民或永久居民亲属。申请时需提供亲属的邀请函及'
          '关系证明。最长停留 180 天。',
    },
    'de-x1-visa': {
      'title': 'X1 / X2 学生签证',
      'description':
          '持大学录取通知（JW202 表）向中国大使馆 / 领事馆申请。'
          'X1 用于 180 天以上学习，X2 用于 180 天以下。'
          '入境后须在 30 天内向当地出入境管理局申请居留许可。',
    },
    'de-residence-permit-30d': {
      'title': '30 天内办理居留许可',
      'description':
          '留学生须在 30 天内到当地公安局出入境管理局（PSB）'
          '将 X1 签证转换为居留许可。所需材料：护照、JW202、JW201、'
          '录取通知书、健康证明、照片。',
    },
    'de-z-visa': {
      'title': 'Z 工作签证 + 居留许可',
      'description':
          '雇主须先获得《外国人工作许可通知》，然后你才能申请 Z 签证。'
          '入境后 30 天内需在 PSB 将其转换为居留许可。',
    },
    'de-q-visa': {
      'title': 'Q 探亲签证',
      'description':
          '用于探望中国公民或永久居民亲属。申请时需提供亲属的邀请函及'
          '关系证明。最长停留 180 天。',
    },
    'fr-x1-visa': {
      'title': 'X1 / X2 学生签证',
      'description':
          '持大学录取通知（JW202 表）向中国大使馆 / 领事馆申请。'
          'X1 用于 180 天以上学习，X2 用于 180 天以下。'
          '入境后须在 30 天内向当地出入境管理局申请居留许可。',
    },
    'fr-residence-permit-30d': {
      'title': '30 天内办理居留许可',
      'description':
          '留学生须在 30 天内到当地公安局出入境管理局（PSB）'
          '将 X1 签证转换为居留许可。所需材料：护照、JW202、JW201、'
          '录取通知书、健康证明、照片。',
    },
    'fr-z-visa': {
      'title': 'Z 工作签证 + 居留许可',
      'description':
          '雇主须先获得《外国人工作许可通知》，然后你才能申请 Z 签证。'
          '入境后 30 天内需在 PSB 将其转换为居留许可。',
    },
    'fr-q-visa': {
      'title': 'Q 探亲签证',
      'description':
          '用于探望中国公民或永久居民亲属。申请时需提供亲属的邀请函及'
          '关系证明。最长停留 180 天。',
    },
    'au-x1-visa': {
      'title': 'X1 / X2 学生签证',
      'description':
          '持大学录取通知（JW202 表）向中国大使馆 / 领事馆申请。'
          'X1 用于 180 天以上学习，X2 用于 180 天以下。'
          '入境后须在 30 天内向当地出入境管理局申请居留许可。',
    },
    'au-residence-permit-30d': {
      'title': '30 天内办理居留许可',
      'description':
          '留学生须在 30 天内到当地公安局出入境管理局（PSB）'
          '将 X1 签证转换为居留许可。所需材料：护照、JW202、JW201、'
          '录取通知书、健康证明、照片。',
    },
    'au-z-visa': {
      'title': 'Z 工作签证 + 居留许可',
      'description':
          '雇主须先获得《外国人工作许可通知》，然后你才能申请 Z 签证。'
          '入境后 30 天内需在 PSB 将其转换为居留许可。',
    },
    'au-q-visa': {
      'title': 'Q 探亲签证',
      'description':
          '用于探望中国公民或永久居民亲属。申请时需提供亲属的邀请函及'
          '关系证明。最长停留 180 天。',
    },
    'ca-x1-visa': {
      'title': 'X1 / X2 学生签证',
      'description':
          '持大学录取通知（JW202 表）向中国大使馆 / 领事馆申请。'
          'X1 用于 180 天以上学习，X2 用于 180 天以下。'
          '入境后须在 30 天内向当地出入境管理局申请居留许可。',
    },
    'ca-residence-permit-30d': {
      'title': '30 天内办理居留许可',
      'description':
          '留学生须在 30 天内到当地公安局出入境管理局（PSB）'
          '将 X1 签证转换为居留许可。所需材料：护照、JW202、JW201、'
          '录取通知书、健康证明、照片。',
    },
    'ca-z-visa': {
      'title': 'Z 工作签证 + 居留许可',
      'description':
          '雇主须先获得《外国人工作许可通知》，然后你才能申请 Z 签证。'
          '入境后 30 天内需在 PSB 将其转换为居留许可。',
    },
    'ca-q-visa': {
      'title': 'Q 探亲签证',
      'description':
          '用于探望中国公民或永久居民亲属。申请时需提供亲属的邀请函及'
          '关系证明。最长停留 180 天。',
    },
    'it-x1-visa': {
      'title': 'X1 / X2 学生签证',
      'description':
          '持大学录取通知（JW202 表）向中国大使馆 / 领事馆申请。'
          'X1 用于 180 天以上学习，X2 用于 180 天以下。'
          '入境后须在 30 天内向当地出入境管理局申请居留许可。',
    },
    'it-residence-permit-30d': {
      'title': '30 天内办理居留许可',
      'description':
          '留学生须在 30 天内到当地公安局出入境管理局（PSB）'
          '将 X1 签证转换为居留许可。所需材料：护照、JW202、JW201、'
          '录取通知书、健康证明、照片。',
    },
    'it-z-visa': {
      'title': 'Z 工作签证 + 居留许可',
      'description':
          '雇主须先获得《外国人工作许可通知》，然后你才能申请 Z 签证。'
          '入境后 30 天内需在 PSB 将其转换为居留许可。',
    },
    'it-q-visa': {
      'title': 'Q 探亲签证',
      'description':
          '用于探望中国公民或永久居民亲属。申请时需提供亲属的邀请函及'
          '关系证明。最长停留 180 天。',
    },
    'jp-x1-visa': {
      'title': 'X1 / X2 学生签证',
      'description':
          '持大学录取通知（JW202 表）向中国大使馆 / 领事馆申请。'
          'X1 用于 180 天以上学习，X2 用于 180 天以下。'
          '入境后须在 30 天内向当地出入境管理局申请居留许可。',
    },
    'jp-residence-permit-30d': {
      'title': '30 天内办理居留许可',
      'description':
          '留学生须在 30 天内到当地公安局出入境管理局（PSB）'
          '将 X1 签证转换为居留许可。所需材料：护照、JW202、JW201、'
          '录取通知书、健康证明、照片。',
    },
    'jp-z-visa': {
      'title': 'Z 工作签证 + 居留许可',
      'description':
          '雇主须先获得《外国人工作许可通知》，然后你才能申请 Z 签证。'
          '入境后 30 天内需在 PSB 将其转换为居留许可。',
    },
    'jp-q-visa': {
      'title': 'Q 探亲签证',
      'description':
          '用于探望中国公民或永久居民亲属。申请时需提供亲属的邀请函及'
          '关系证明。最长停留 180 天。',
    },
    'kr-x1-visa': {
      'title': 'X1 / X2 学生签证',
      'description':
          '持大学录取通知（JW202 表）向中国大使馆 / 领事馆申请。'
          'X1 用于 180 天以上学习，X2 用于 180 天以下。'
          '入境后须在 30 天内向当地出入境管理局申请居留许可。',
    },
    'kr-residence-permit-30d': {
      'title': '30 天内办理居留许可',
      'description':
          '留学生须在 30 天内到当地公安局出入境管理局（PSB）'
          '将 X1 签证转换为居留许可。所需材料：护照、JW202、JW201、'
          '录取通知书、健康证明、照片。',
    },
    'kr-z-visa': {
      'title': 'Z 工作签证 + 居留许可',
      'description':
          '雇主须先获得《外国人工作许可通知》，然后你才能申请 Z 签证。'
          '入境后 30 天内需在 PSB 将其转换为居留许可。',
    },
    'kr-q-visa': {
      'title': 'Q 探亲签证',
      'description':
          '用于探望中国公民或永久居民亲属。申请时需提供亲属的邀请函及'
          '关系证明。最长停留 180 天。',
    },
    'ru-x1-visa': {
      'title': 'X1 / X2 学生签证',
      'description':
          '持大学录取通知（JW202 表）向中国大使馆 / 领事馆申请。'
          'X1 用于 180 天以上学习，X2 用于 180 天以下。'
          '入境后须在 30 天内向当地出入境管理局申请居留许可。',
    },
    'ru-residence-permit-30d': {
      'title': '30 天内办理居留许可',
      'description':
          '留学生须在 30 天内到当地公安局出入境管理局（PSB）'
          '将 X1 签证转换为居留许可。所需材料：护照、JW202、JW201、'
          '录取通知书、健康证明、照片。',
    },
    'ru-z-visa': {
      'title': 'Z 工作签证 + 居留许可',
      'description':
          '雇主须先获得《外国人工作许可通知》，然后你才能申请 Z 签证。'
          '入境后 30 天内需在 PSB 将其转换为居留许可。',
    },
    'ru-q-visa': {
      'title': 'Q 探亲签证',
      'description':
          '用于探望中国公民或永久居民亲属。申请时需提供亲属的邀请函及'
          '关系证明。最长停留 180 天。',
    },
    'fallback-generic': {
      'title': '暂无该护照政策详情',
      'description':
          '大多数该地区的旅客需要办理旅游签证。'
          '请前往最近的中国大使馆或领事馆申请。',
    },
  };

  /// Checklist item translations, keyed by item id. Replaces only `title`;
  /// `done` and `id` are kept.
  static const Map<String, String> checklist = <String, String>{
    'passport-validity': '确认护照有效期超过入境日期 6 个月以上',
    'return-ticket': '准备好回程 / 离境机票（飞机、火车或汽车）',
    'hotel-booking': '保存酒店中文地址 — 可给出租车司机看',
    'travel-insurance': '购买涵盖医疗运送的旅行保险（推荐）',
    'offline-pack': '出发前下载首次入境城市的离线数据包',
    'cash-mix': '随身携带少量人民币现金（¥500–¥1000）以备前 24 小时使用',
    'phrases-saved': '在 工具 → 常用短语 中保存至少 10 条应急短语',
    'embassy-saved': '将你所在国家领事馆的紧急联系电话保存到手机主屏幕',
    '24h-registration': '到达后：确认酒店已在 24 小时内将你的住宿信息登记至当地派出所',
    'visa-application': '出发前至少 4 周申请中国旅游签证（L 签证）',
    'university-documents': '携带 JW202 + JW201 录取表格（由你的大学开具）',
    'health-checkup': '到达后 24 小时内在指定医院完成强制健康检查',
    'residence-permit-30d': '30 天内预约 PSB，将 X1 签证转换为居留许可',
    'work-permit-notification': '携带雇主开具的《外国人工作许可通知》',
    'invitation-letter': '携带国内亲属开具的 Q 签证邀请函',
    'bj-psb-address': '收藏北京出入境管理局地址（东城区安定门东大街 2 号）',
    'gz-psb-address': '收藏广州出入境管理局地址（天河区中山大道中 803 号）',
    'other-city-notice': '落地后查询首次入境城市的当地出入境管理局（PSB）地址',
  };

  /// POI `name` translations, keyed by POI id. Only the `name` field of the
  /// POI map is replaced; `category`, `distanceKm`, `avgScore` are kept.
  static const Map<String, String> poi = <String, String>{
    'poi-bund': '外滩',
    'poi-yu-garden': '豫园',
    'poi-oriental-pearl': '东方明珠塔',
    'poi-nanjing-road': '南京路步行街',
    'poi-xintiandi': '新天地',
    'poi-tianzifang': '田子坊',
    'poi-french-concession': '法租界漫步',
    'poi-jingan-temple': '静安寺',
    'poi-shanghai-museum': '上海博物馆',
    'poi-lost-heaven': '花马天堂',
    'poi-jia-jia-tang-bao': '佳家汤包',
    'poi-peninsula': '上海半岛酒店',
    'poi-amani': '养云安缦',
    'poi-global-harbor': '环球港购物中心',
    'poi-apple-pudong': '浦东苹果零售店',
    'poi-forbidden-city': '故宫',
    'poi-temple-of-heaven': '天坛',
    'poi-great-wall-mutianyu': '长城 · 慕田峪段',
    'poi-summer-palace': '颐和园',
    'poi-wangfujing': '王府井小吃街',
    'poi-peking-duck-da-dong': '大董烤鸭',
    'poi-sanlitun': '三里屯太古里',
    'poi-rosewood-bj': '北京瑰丽酒店',
    'poi-canton-tower': '广州塔',
    'poi-chen-clan': '陈家祠',
    'poi-shamian': '沙面岛',
    'poi-baiyun-mountain': '白云山',
    'poi-taotaoju': '陶陶居 早茶',
    'poi-beijing-road': '北京路步行街',
    'poi-mandarin-orchard-gz': '广州文华东方酒店',
    'poi-fallback': '该城市暂无离线 POI 数据',
  };

  /// Full replacement for `/discover/*` endpoints. Each list is wrapped
  /// exactly like the English version in `MockData._discoverCurated` etc.
  static const Map<String, List<Map<String, dynamic>>> discover =
      <String, List<Map<String, dynamic>>>{
    'curated': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'cur-1',
        'title': '上海编辑精选 Top 10',
        'subtitle': '本地编辑团队精选 · 每月更新',
        'score': 4.8,
      },
      <String, dynamic>{
        'id': 'cur-2',
        'title': '首次到访必看',
        'subtitle': '首访 72 小时内不可错过的精华',
        'score': 4.6,
      },
      <String, dynamic>{
        'id': 'cur-3',
        'title': '浦东与陆家嘴精华',
        'subtitle': '天际线与现代上海全景',
        'score': 4.5,
      },
      <String, dynamic>{
        'id': 'cur-4',
        'title': '亲子友好游上海',
        'subtitle': '推车友好路线、儿童菜单、林荫步道',
        'score': 4.4,
      },
    ],
    'authentic': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'auth-1',
        'title': '本地面馆（不在大众点评上）',
        'subtitle': '本地作家亲测 · 8 家精选小店',
        'score': 4.7,
      },
      <String, dynamic>{
        'id': 'auth-2',
        'title': '老城厢茶馆',
        'subtitle': '本地人真正爱去的安静去处',
        'score': 4.5,
      },
      <String, dynamic>{
        'id': 'auth-3',
        'title': '深夜食堂',
        'subtitle': '晚上 22 点之后城市的去处',
        'score': 4.6,
      },
    ],
    'heads-up': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'hu-1',
        'title': '日落时分的拥挤外滩',
        'subtitle': '提前 30 分钟到，否则人山人海',
        'score': 4.0,
      },
      <String, dynamic>{
        'id': 'hu-2',
        'title': '出租车计价器与宰客',
        'subtitle': '如何识别不打表的车及应对方法',
        'score': 4.3,
      },
      <String, dynamic>{
        'id': 'hu-3',
        'title': '支付宝 / 微信支付开通',
        'subtitle': '多数商家已不支持外卡，建议先开通',
        'score': 4.5,
      },
      <String, dynamic>{
        'id': 'hu-4',
        'title': '公共假日闭店',
        'subtitle': '黄金周、春节等期间哪些地方会停业',
        'score': 4.1,
      },
    ],
  };

  /// Per-city consular suffix (replaces the value appended to the consular
  /// card description). Keyed by upper-case city id.
  static const Map<String, String> consularByCity = <String, String>{
    'SH': '上海 · 美国总领事馆 · 淮海中路 1469 号 · 021-8011-2400',
    'BJ': '北京 · 美国大使馆 · 安家楼路 55 号 · 010-8531-3000',
    'GZ': '广州 · 美国总领事馆 · 珠江新城华就路 43 号 · 020-3814-5000',
    'OTHER': '',
  };

  /// Header text that separates the existing consular card description from
  /// the city-specific address. Used in place of the English `— Local
  /// presence —` label.
  static const String consularHeader = '— 当地机构 —';

  /// `source` for the fallback policy card when the country is unknown.
  static const String fallbackSource = '中国国家移民管理局（官方源）· 季度更新';
}
