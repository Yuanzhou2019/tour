import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/discover/presentation/pages/discover_page.dart';
import '../../features/feedback/presentation/pages/feedback_form_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/presentation/pages/onboarding_flow_page.dart';
import '../../features/onboarding/presentation/pages/privacy_consent_page.dart';
import '../../features/prepare/presentation/pages/prepare_page.dart';
import '../../features/tools/presentation/pages/tools_page.dart';
import '../../features/you/presentation/pages/you_page.dart';
import '../../shared/pages/coming_soon_page.dart';
import '../../shared/pages/not_found_page.dart';
import '../di/injection.dart';
import 'main_shell.dart';
import 'route_guards.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: '/prepare',
  debugLogDiagnostics: true,
  redirect: (ctx, state) => onboardingRedirect(ctx, state),
  routes: <RouteBase>[
    GoRoute(
      path: '/onboarding',
      name: RouteNames.onboarding,
      builder: (_, __) => const OnboardingFlowPage(),
      routes: [
        GoRoute(
          path: 'privacy',
          name: RouteNames.privacyConsent,
          builder: (_, __) => const PrivacyConsentPage(),
        ),
        GoRoute(
          path: 'complete',
          name: RouteNames.onboardingComplete,
          builder: (_, state) {
            // Side effect: mark completed
            final repo = getIt<OnboardingRepository>();
            repo.markCompleted();
            return const _OnboardingCompletePage();
          },
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: <RouteBase>[
        GoRoute(
          path: '/prepare',
          name: RouteNames.prepare,
          builder: (_, __) => const PreparePage(),
          routes: <RouteBase>[
            GoRoute(
              path: 'policy/:id',
              name: RouteNames.policyDetail,
              builder: (_, state) => ComingSoonPage(
                title: 'Policy · ${state.pathParameters['id']}',
              ),
            ),
            GoRoute(
              path: 'checklist',
              name: RouteNames.checklist,
              builder: (_, __) => const ComingSoonPage(title: 'Checklist'),
            ),
            GoRoute(
              path: 'offline',
              name: RouteNames.offlineDownloads,
              builder: (_, __) =>
                  const ComingSoonPage(title: 'Offline downloads'),
            ),
          ],
        ),
        GoRoute(
          path: '/map',
          name: RouteNames.map,
          builder: (_, __) => const MapPage(),
          routes: <RouteBase>[
            GoRoute(
              path: 'poi/:id',
              name: RouteNames.poiDetail,
              builder: (_, state) => ComingSoonPage(
                title: 'POI · ${state.pathParameters['id']}',
              ),
              routes: <RouteBase>[
                GoRoute(
                  path: 'reputation',
                  name: RouteNames.poiReputation,
                  builder: (_, state) => ComingSoonPage(
                    title: 'Reputation · ${state.pathParameters['id']}',
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/discover',
          name: RouteNames.discover,
          builder: (_, __) => const DiscoverPage(),
          routes: <RouteBase>[
            GoRoute(
              path: ':category',
              name: RouteNames.rankCategory,
              builder: (_, state) => ComingSoonPage(
                title: 'Rank · ${state.pathParameters['category']}',
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/tools',
          name: RouteNames.tools,
          builder: (_, __) => const ToolsPage(),
          routes: <RouteBase>[
            GoRoute(
              path: 'fx',
              name: RouteNames.fxConverter,
              builder: (_, __) => const ComingSoonPage(title: 'FX converter'),
            ),
            GoRoute(
              path: 'phrases',
              name: RouteNames.phrasesIndex,
              builder: (_, __) => const ComingSoonPage(title: 'Phrases'),
              routes: <RouteBase>[
                GoRoute(
                  path: ':category',
                  name: RouteNames.phrasesCategory,
                  builder: (_, state) => ComingSoonPage(
                    title: 'Phrases · ${state.pathParameters['category']}',
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'emergency',
              name: RouteNames.emergency,
              builder: (_, __) => const ComingSoonPage(title: 'Emergency'),
            ),
          ],
        ),
        GoRoute(
          path: '/you',
          name: RouteNames.you,
          builder: (_, __) => const YouPage(),
          routes: <RouteBase>[
            GoRoute(
              path: 'feedback',
              name: RouteNames.feedback,
              pageBuilder: (_, __) => const MaterialPage(
                fullscreenDialog: true,
                child: FeedbackFormPage(),
              ),
            ),
          ],
        ),
      ],
    ),

    // Modal
    GoRoute(
      path: '/modal/correction',
      name: RouteNames.modalCorrection,
      pageBuilder: (_, state) => MaterialPage(
        fullscreenDialog: true,
        child: ComingSoonPage(
          title: 'Correction${state.uri.queryParameters['poiId'] != null ? ' · ${state.uri.queryParameters['poiId']}' : ''}',
        ),
      ),
    ),
    GoRoute(
      path: '/modal/filter',
      name: RouteNames.modalFilter,
      pageBuilder: (_, __) => const MaterialPage(
        fullscreenDialog: true,
        child: ComingSoonPage(title: 'Filter'),
      ),
    ),
    GoRoute(
      path: '/modal/country',
      name: RouteNames.modalCountry,
      pageBuilder: (_, __) => const MaterialPage(
        fullscreenDialog: true,
        child: ComingSoonPage(title: 'Country'),
      ),
    ),
    GoRoute(
      path: '/modal/language',
      name: RouteNames.modalLanguage,
      pageBuilder: (_, __) => const MaterialPage(
        fullscreenDialog: true,
        child: ComingSoonPage(title: 'Language'),
      ),
    ),

    // Full
    GoRoute(
      path: '/full/privacy',
      name: RouteNames.privacy,
      builder: (_, __) => const ComingSoonPage(title: 'Privacy policy'),
    ),
    GoRoute(
      path: '/full/about',
      name: RouteNames.about,
      builder: (_, __) => const ComingSoonPage(title: 'About'),
    ),
    GoRoute(
      path: '/full/maintenance',
      name: RouteNames.maintenance,
      builder: (_, __) => const ComingSoonPage(title: 'Maintenance'),
    ),
    GoRoute(
      path: '/full/not-found',
      name: RouteNames.notFound,
      builder: (_, __) => const NotFoundPage(),
    ),
  ],
  errorBuilder: (_, state) => NotFoundPage(error: state.error),
);

class _OnboardingCompletePage extends StatelessWidget {
  const _OnboardingCompletePage();

  @override
  Widget build(BuildContext context) {
    // 短暂展示后跳到 /prepare
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/prepare');
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
