/// Every destination in the app, in one place.
///
/// Paths are written once here instead of being sprinkled through the widget
/// tree as string literals, so a typo becomes a compile error and deep links
/// stay documented.
enum AppRoute {
  foundations('/foundations'),
  components('/components'),
  componentDetail('/components/:componentId'),
  playground('/playground'),
  settings('/settings');

  const AppRoute(this.path);

  /// The `go_router` path pattern.
  final String path;

  /// The name used with `context.goNamed`, derived from the enum constant.
  String get routeName => name;
}

/// The top-level destinations shown in the navigation bar, in order.
///
/// Kept next to [AppRoute] so adding a tab is a single, obvious edit.
enum AppTab {
  foundations(AppRoute.foundations),
  components(AppRoute.components),
  playground(AppRoute.playground),
  settings(AppRoute.settings);

  const AppTab(this.route);

  final AppRoute route;
}
