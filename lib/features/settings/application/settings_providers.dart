import 'package:design_system_flutter/design_system/foundations/ds_brand.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:design_system_flutter/features/settings/domain/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The repository the app writes to.
///
/// It throws on purpose: `main()` replaces it with the real one, and the tests
/// replace it with a fake, so nobody can forget to provide it.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  throw UnimplementedError(
    'settingsRepositoryProvider must be overridden in ProviderScope. '
    'See main() in lib/main.dart.',
  );
});

/// The settings that were read from storage before the app started.
final initialSettingsProvider = Provider<AppSettings>((ref) {
  throw UnimplementedError(
    'initialSettingsProvider must be overridden in ProviderScope. '
    'See main() in lib/main.dart.',
  );
});

/// The settings the app is running with right now.
final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

/// Changes the settings and saves them.
///
/// This is the application layer: it holds the state and calls the repository,
/// so the pages only have to call one method per user action.
class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(initialSettingsProvider);

  void setDesignLanguage(DesignLanguagePreference preference) {
    _update(state.copyWith(designLanguage: preference));
  }

  void setThemeMode(AppThemeMode mode) {
    _update(state.copyWith(themeMode: mode));
  }

  void setBrand(DSBrand brand) {
    _update(state.copyWith(brand: brand));
  }

  void setLanguage(AppLanguage language) {
    _update(state.copyWith(language: language));
  }

  /// Called when the introduction is finished or skipped.
  void completeOnboarding() {
    _update(state.copyWith(hasCompletedOnboarding: true));
  }

  /// Called from Settings when the user wants to see the introduction again.
  void replayOnboarding() {
    _update(state.copyWith(hasCompletedOnboarding: false));
  }

  /// Goes back to the defaults, but keeps the introduction marked as seen.
  Future<void> reset() async {
    final seenOnboarding = state.hasCompletedOnboarding;
    state = AppSettings.defaults.copyWith(
      hasCompletedOnboarding: seenOnboarding,
    );
    await ref.read(settingsRepositoryProvider).save(state);
  }

  /// Updates the state and saves in the background.
  ///
  /// The UI does not wait for the disk: the new value is on screen right away.
  void _update(AppSettings next) {
    if (next == state) return;

    state = next;
    ref.read(settingsRepositoryProvider).save(next);
  }
}
