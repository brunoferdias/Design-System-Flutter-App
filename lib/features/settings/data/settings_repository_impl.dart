import 'package:design_system_flutter/design_system/foundations/ds_brand.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/settings/data/key_value_store.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:design_system_flutter/features/settings/domain/settings_repository.dart';

/// Stores [AppSettings] as four independent string keys.
///
/// Each value is decoded defensively: an unknown enum name — from a downgrade,
/// a corrupted store, or a renamed constant — degrades to the default instead of
/// throwing at startup. Persisted data is untrusted input, even when your own
/// app wrote it.
final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._store);

  static const String _designLanguageKey = 'settings.designLanguage';
  static const String _themeModeKey = 'settings.themeMode';
  static const String _brandKey = 'settings.brand';
  static const String _languageKey = 'settings.language';

  static const List<String> _allKeys = <String>[
    _designLanguageKey,
    _themeModeKey,
    _brandKey,
    _languageKey,
  ];

  final KeyValueStore _store;

  @override
  Future<AppSettings> load() async => AppSettings(
    designLanguage: _decode(
      _store.readString(_designLanguageKey),
      DesignLanguagePreference.values,
      AppSettings.defaults.designLanguage,
    ),
    themeMode: _decode(
      _store.readString(_themeModeKey),
      AppThemeMode.values,
      AppSettings.defaults.themeMode,
    ),
    brand: _decode(
      _store.readString(_brandKey),
      DSBrand.values,
      AppSettings.defaults.brand,
    ),
    language: _decode(
      _store.readString(_languageKey),
      AppLanguage.values,
      AppSettings.defaults.language,
    ),
  );

  @override
  Future<void> save(AppSettings settings) async {
    await Future.wait<void>(<Future<void>>[
      _store.writeString(_designLanguageKey, settings.designLanguage.name),
      _store.writeString(_themeModeKey, settings.themeMode.name),
      _store.writeString(_brandKey, settings.brand.name),
      _store.writeString(_languageKey, settings.language.name),
    ]);
  }

  @override
  Future<void> clear() async {
    await Future.wait<void>(_allKeys.map(_store.remove));
  }

  /// Resolves an enum by its `name`, falling back to [fallback].
  static T _decode<T extends Enum>(
    String? stored,
    List<T> values,
    T fallback,
  ) {
    if (stored == null) return fallback;
    for (final T value in values) {
      if (value.name == stored) return value;
    }
    return fallback;
  }
}
