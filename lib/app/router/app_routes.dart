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
