import 'package:design_system_flutter/design_system/foundations/ds_brand.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:design_system_flutter/features/settings/domain/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  throw UnimplementedError(
    'settingsRepositoryProvider must be overridden in ProviderScope. '
    'See main() in lib/main.dart.',
  );
});

final initialSettingsProvider = Provider<AppSettings>((ref) {
  throw UnimplementedError(
    'initialSettingsProvider must be overridden in ProviderScope. '
    'See main() in lib/main.dart.',
  );
});

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

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

  void completeOnboarding() {
    _update(state.copyWith(hasCompletedOnboarding: true));
  }

  void replayOnboarding() {
    _update(state.copyWith(hasCompletedOnboarding: false));
  }

  Future<void> reset() async {
    final seenOnboarding = state.hasCompletedOnboarding;
    state = AppSettings.defaults.copyWith(
      hasCompletedOnboarding: seenOnboarding,
    );
    await ref.read(settingsRepositoryProvider).save(state);
  }

  void _update(AppSettings next) {
    if (next == state) return;

    state = next;
    ref.read(settingsRepositoryProvider).save(next);
  }
}
