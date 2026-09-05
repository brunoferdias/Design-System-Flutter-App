import 'dart:async';

import 'package:design_system_flutter/design_system/foundations/ds_brand.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:design_system_flutter/features/settings/domain/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The storage the controller writes through.
///
/// Left unimplemented on purpose: `main()` overrides it with a repository built
/// on the opened platform store, and tests override it with an in-memory one.
/// A missing override is a loud startup error rather than a silent no-op.
final Provider<SettingsRepository> settingsRepositoryProvider =
    Provider<SettingsRepository>(
      (Ref ref) => throw UnimplementedError(
        'settingsRepositoryProvider must be overridden in ProviderScope. '
        'See bootstrap() in lib/bootstrap.dart.',
      ),
      name: 'settingsRepository',
    );

/// The settings read from disk before the first frame.
///
/// Loading synchronously-before-runApp keeps the widget tree free of loading
/// states and, more importantly, prevents the app from flashing the wrong theme
/// on launch.
final Provider<AppSettings> initialSettingsProvider = Provider<AppSettings>(
  (Ref ref) => throw UnimplementedError(
    'initialSettingsProvider must be overridden in ProviderScope. '
    'See bootstrap() in lib/bootstrap.dart.',
  ),
  name: 'initialSettings',
);

/// The single source of truth for user preferences.
final NotifierProvider<SettingsController, AppSettings> settingsProvider =
    NotifierProvider<SettingsController, AppSettings>(
      SettingsController.new,
      name: 'settings',
    );

/// Applies changes to [AppSettings] and writes them through to storage.
///
/// Optimistic by design: the state changes first so the UI reacts on the same
/// frame, and persistence happens in the background. Nothing here is allowed to
/// fail loudly — losing a preference must never take the app down.
final class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(initialSettingsProvider);

  void setDesignLanguage(DesignLanguagePreference preference) =>
      _update(state.copyWith(designLanguage: preference));

  void setThemeMode(AppThemeMode mode) =>
      _update(state.copyWith(themeMode: mode));

  void setBrand(DSBrand brand) => _update(state.copyWith(brand: brand));

  void setLanguage(AppLanguage language) =>
      _update(state.copyWith(language: language));

  /// Returns every value to [AppSettings.defaults] and forgets the stored keys.
  Future<void> reset() async {
    state = AppSettings.defaults;
    await ref.read(settingsRepositoryProvider).clear();
  }

  void _update(AppSettings next) {
    if (next == state) return;
    state = next;
    // Fire-and-forget: the UI has already moved on, and `save` is idempotent.
    unawaited(ref.read(settingsRepositoryProvider).save(next));
  }
}
