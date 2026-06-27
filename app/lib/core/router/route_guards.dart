import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../storage/anonymous_id.dart';

/// 守卫：MVP 阶段所有路由对游客模式开放（按 MVP Plan Task 11.4）
/// 阶段一 / 阶段二无需鉴权；阶段三 UGC 时再启用 token 校验。
Future<String?> visitorGuard(BuildContext context, GoRouterState state) async {
  AnonymousId.get(); // 触发 anonymousId 生成
  return null;
}
