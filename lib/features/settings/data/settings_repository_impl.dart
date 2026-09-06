import 'package:design_system_flutter/design_system/foundations/ds_brand.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/settings/data/key_value_store.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:design_system_flutter/features/settings/domain/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._store);

  static const String _designLanguageKey = 'settings.designLanguage';
  static const String _themeModeKey = 'settings.themeMode';
  static const String _brandKey = 'settings.brand';
  static const String _languageKey = 'settings.language';
  static const String _onboardingKey = 'settings.hasCompletedOnboarding';

  final KeyValueStore _store;

  @override
  Future<AppSettings> load() async {
    return AppSettings(
      designLanguage: _readEnum(
        _designLanguageKey,
        DesignLanguagePreference.values,
        AppSettings.defaults.designLanguage,
      ),
      themeMode: _readEnum(
        _themeModeKey,
        AppThemeMode.values,
        AppSettings.defaults.themeMode,
      ),
      brand: _readEnum(_brandKey, DSBrand.values, AppSettings.defaults.brand),
      language: _readEnum(
        _languageKey,
        AppLanguage.values,
        AppSettings.defaults.language,
      ),
      hasCompletedOnboarding: _store.readString(_onboardingKey) == 'true',
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _store.writeString(_designLanguageKey, settings.designLanguage.name);
    await _store.writeString(_themeModeKey, settings.themeMode.name);
    await _store.writeString(_brandKey, settings.brand.name);
    await _store.writeString(_languageKey, settings.language.name);
    await _store.writeString(
      _onboardingKey,
      settings.hasCompletedOnboarding ? 'true' : 'false',
    );
  }

  @override
  Future<void> clear() async {
    await _store.remove(_designLanguageKey);
    await _store.remove(_themeModeKey);
    await _store.remove(_brandKey);
    await _store.remove(_languageKey);
    await _store.remove(_onboardingKey);
  }

  T _readEnum<T extends Enum>(String key, List<T> values, T fallback) {
    final stored = _store.readString(key);
    if (stored == null) return fallback;

    for (final value in values) {
      if (value.name == stored) return value;
    }
    return fallback;
  }
}
