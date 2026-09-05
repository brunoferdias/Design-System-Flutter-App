import 'package:design_system_flutter/app/application/app_providers.dart';
import 'package:design_system_flutter/app/router/app_routes.dart';
import 'package:design_system_flutter/app/widgets/adaptive_shell.dart';
import 'package:design_system_flutter/features/catalog/domain/component_id.dart';
import 'package:design_system_flutter/features/catalog/presentation/component_detail_page.dart';
import 'package:design_system_flutter/features/catalog/presentation/components_page.dart';
import 'package:design_system_flutter/features/foundations/presentation/foundations_page.dart';
import 'package:design_system_flutter/features/onboarding/presentation/onboarding_page.dart';
import 'package:design_system_flutter/features/playground/presentation/playground_page.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/presentation/settings_page.dart';
import 'package:flutter/cupertino.dart' show CupertinoPage;
import 'package:flutter/material.dart' show MaterialPage;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The navigation map of the app.
///
/// There are two levels:
///  - `/onboarding` is on its own, with no bottom bar;
///  - the four tabs live inside a shell route, which keeps one navigation
///    stack per tab (so leaving and coming back does not lose your place).
final routerProvider = Provider<GoRouter>((ref) {
  /// Wraps a page so it animates like the current design language: an iOS
  /// slide on Cupertino, the Material transition otherwise.
  Page<void> adaptivePage(Widget child, GoRouterState state) {
    final language = ref.read(designLanguageProvider);

    if (language.isCupertino) {
      return CupertinoPage<void>(key: state.pageKey, child: child);
    }
    return MaterialPage<void>(key: state.pageKey, child: child);
  }

  bool hasCompletedOnboarding() {
    return ref.read(settingsProvider).hasCompletedOnboarding;
  }

  return GoRouter(
    initialLocation: hasCompletedOnboarding()
        ? AppRoute.foundations.path
        : AppRoute.onboarding.path,
    // Runs before every navigation. Returning null means "let it through".
    //
    // Note that changing `hasCompletedOnboarding` does not navigate by itself:
    // whoever changes it also calls `goNamed`. This guard is here to stop
    // someone reaching the wrong screen by URL.
    redirect: (context, state) {
      final isAtOnboarding = state.matchedLocation == AppRoute.onboarding.path;

      if (!hasCompletedOnboarding() && !isAtOnboarding) {
        return AppRoute.onboarding.path;
      }
      if (hasCompletedOnboarding() && isAtOnboarding) {
        return AppRoute.foundations.path;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.onboarding.path,
        name: AppRoute.onboarding.routeName,
        pageBuilder: (context, state) =>
            adaptivePage(const OnboardingPage(), state),
      ),

      // One branch per tab. The shell draws the bottom bar (or the side rail)
      // around whichever branch is selected.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdaptiveShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.foundations.path,
                name: AppRoute.foundations.routeName,
                pageBuilder: (context, state) =>
                    adaptivePage(const FoundationsPage(), state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.components.path,
                name: AppRoute.components.routeName,
                pageBuilder: (context, state) =>
                    adaptivePage(const ComponentsPage(), state),
                routes: [
                  // A child route, so opening a component pushes the detail
                  // page on top of the list and the back button appears.
                  GoRoute(
                    path: ':componentId',
                    name: AppRoute.componentDetail.routeName,
                    pageBuilder: (context, state) {
                      final slug = state.pathParameters['componentId'];
                      final componentId = ComponentId.fromSlug(slug);

                      // An unknown slug falls back to the list instead of
                      // crashing.
                      if (componentId == null) {
                        return adaptivePage(const ComponentsPage(), state);
                      }
                      return adaptivePage(
                        ComponentDetailPage(componentId: componentId),
                        state,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.playground.path,
                name: AppRoute.playground.routeName,
                pageBuilder: (context, state) =>
                    adaptivePage(const PlaygroundPage(), state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.settings.path,
                name: AppRoute.settings.routeName,
                pageBuilder: (context, state) =>
                    adaptivePage(const SettingsPage(), state),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
