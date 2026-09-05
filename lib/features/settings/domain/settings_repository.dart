import 'package:design_system_flutter/features/settings/domain/app_settings.dart';

/// The contract the application layer depends on.
///
/// Declared in the domain and implemented in `data/` — the dependency-inversion
/// half of clean architecture. Swapping `shared_preferences` for a backend sync
/// service touches exactly one file and no tests.
abstract interface class SettingsRepository {
  /// Reads the stored settings, falling back to [AppSettings.defaults] for any
  /// value that is missing or no longer recognised.
  Future<AppSettings> load();

  /// Persists [settings]. Implementations must be safe to call on every change.
  Future<void> save(AppSettings settings);

  /// Forgets everything, returning the app to [AppSettings.defaults].
  Future<void> clear();
}
