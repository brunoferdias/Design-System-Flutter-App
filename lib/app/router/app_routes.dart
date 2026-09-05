/// Every screen the app can navigate to.
///
/// The path is the URL and the name is what the code uses, so pages call
/// `context.goNamed(AppRoute.settings.routeName)` and never type a path.
enum AppRoute {
  onboarding('/onboarding'),
  foundations('/foundations'),
  components('/components'),

  /// `:componentId` is filled in with a ComponentId slug, like "text-field".
  componentDetail('/components/:componentId'),

  playground('/playground'),
  settings('/settings');

  const AppRoute(this.path);

  final String path;

  String get routeName => name;
}
