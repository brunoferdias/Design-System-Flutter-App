/// Build-time facts about the app.
///
/// Kept as constants rather than read from `package_info_plus`: the version is
/// already in `pubspec.yaml`, and one dependency fewer is one platform channel
/// fewer to mock in tests.
abstract final class AppInfo {
  /// Must match `version` in `pubspec.yaml`.
  static const String version = '1.0.0';

  /// Where the source lives. Shown, not opened — this app deliberately ships
  /// without a URL-launcher dependency.
  static const String repositoryUrl =
      'https://github.com/brunodias/design_system_flutter';
}
