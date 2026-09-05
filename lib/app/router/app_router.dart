import 'package:design_system_flutter/app/application/app_providers.dart';
import 'package:design_system_flutter/app/router/app_routes.dart';
import 'package:design_system_flutter/app/widgets/adaptive_shell.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/catalog/domain/component_id.dart';
import 'package:design_system_flutter/features/catalog/presentation/component_detail_page.dart';
import 'package:design_system_flutter/features/catalog/presentation/components_page.dart';
import 'package:design_system_flutter/features/foundations/presentation/foundations_page.dart';
import 'package:design_system_flutter/features/playground/presentation/playground_page.dart';
import 'package:design_system_flutter/features/settings/presentation/settings_page.dart';
import 'package:flutter/cupertino.dart' show CupertinoPage;
import 'package:flutter/material.dart' show MaterialPage;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The app's single [GoRouter].
///
/// Built once and never rebuilt: the router is infrastructure, not state.
/// Anything that *does* change — the design language used for page transitions
/// — is read lazily, per navigation, rather than baked in at construction.
final Provider<GoRouter> routerProvider = Provider<GoRouter>((Ref ref) {
  Page<void> adaptivePage(Widget child, GoRouterState state) {
    // iOS users expect a horizontal push with an interactive back-swipe;
    // Android users expect a vertical fade-through. Same route, right feel.
    return switch (ref.read(designLanguageProvider)) {
      DesignLanguage.cupertino => CupertinoPage<void>(
        key: state.pageKey,
        child: child,
      ),
      DesignLanguage.material => MaterialPage<void>(
        key: state.pageKey,
        child: child,
      ),
    };
  }

  return GoRouter(
    initialLocation: AppRoute.foundations.path,
    debugLogDiagnostics: false,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell shell,
            ) => AdaptiveShell(navigationShell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.foundations.path,
                name: AppRoute.foundations.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    adaptivePage(const FoundationsPage(), state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.components.path,
                name: AppRoute.components.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    adaptivePage(const ComponentsPage(), state),
                routes: <RouteBase>[
                  GoRoute(
                    // Relative to the parent, which is what makes the detail
                    // screen deep-linkable at /components/button.
                    path: ':componentId',
                    name: AppRoute.componentDetail.routeName,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final ComponentId? id = ComponentId.fromSlug(
                        state.pathParameters['componentId'],
                      );
                      // An unknown slug falls back to the list instead of
                      // crashing: deep links are user input.
                      if (id == null) {
                        return adaptivePage(const ComponentsPage(), state);
                      }
                      return adaptivePage(
                        ComponentDetailPage(componentId: id),
                        state,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.playground.path,
                name: AppRoute.playground.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    adaptivePage(const PlaygroundPage(), state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.settings.path,
                name: AppRoute.settings.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    adaptivePage(const SettingsPage(), state),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}, name: 'router');
