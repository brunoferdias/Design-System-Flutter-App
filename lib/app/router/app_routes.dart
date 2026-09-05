enum AppRoute {
  onboarding('/onboarding'),
  foundations('/foundations'),
  components('/components'),
  componentDetail('/components/:componentId'),
  playground('/playground'),
  settings('/settings');

  const AppRoute(this.path);
  final String path;

  String get routeName => name;
}

enum AppTab {
  foundations(AppRoute.foundations),
  components(AppRoute.components),
  playground(AppRoute.playground),
  settings(AppRoute.settings);

  const AppTab(this.route);
  final AppRoute route;
}
