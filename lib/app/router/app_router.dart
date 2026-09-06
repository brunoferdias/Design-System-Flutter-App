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

final routerProvider = Provider<GoRouter>((ref) {
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
                  GoRoute(
                    path: ':componentId',
                    name: AppRoute.componentDetail.routeName,
                    pageBuilder: (context, state) {
                      final slug = state.pathParameters['componentId'];
                      final componentId = ComponentId.fromSlug(slug);

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
