import 'package:design_system_flutter/features/settings/domain/app_settings.dart';

/// What the app needs from storage, described without saying how.
///
/// The domain layer only knows this contract; the real implementation lives in
/// the data layer, which makes it easy to swap for a fake one in tests.
abstract class SettingsRepository {
  /// Reads the saved settings, falling back to [AppSettings.defaults].
  Future<AppSettings> load();

  Future<void> save(AppSettings settings);

  /// Forgets everything that was saved.
  Future<void> clear();
}
