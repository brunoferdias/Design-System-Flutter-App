import 'package:design_system_flutter/design_system/foundations/ds_brand.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:flutter/foundation.dart';

/// How the app resolves light and dark.
///
/// Deliberately *not* Flutter's `ThemeMode`: the domain layer stays free of the
/// UI framework, and the mapping happens once, at the presentation boundary.
enum AppThemeMode { system, light, dark }

/// The languages the app ships with.
///
/// A closed enum rather than a free-form `Locale` — a locale the app has no
/// translations for should be unrepresentable.
enum AppLanguage {
  /// Follow the operating system, falling back to English.
  system(null),
  english('en'),
  portuguese('pt'),
  german('de');

  const AppLanguage(this.languageCode);

  /// `null` for [AppLanguage.system].
  final String? languageCode;

  static AppLanguage fromCode(String? code) => values.firstWhere(
    (AppLanguage language) => language.languageCode == code,
    orElse: () => AppLanguage.system,
  );

  /// Every language the app can actually render, in menu order.
  static const List<AppLanguage> supported = <AppLanguage>[
    AppLanguage.english,
    AppLanguage.portuguese,
    AppLanguage.german,
  ];
}

/// Everything the user can change about how the app looks and speaks.
///
/// An immutable value object: the controller replaces it wholesale, which makes
/// state transitions trivially testable and impossible to mutate by accident.
@immutable
final class AppSettings {
  const AppSettings({
    required this.designLanguage,
    required this.themeMode,
    required this.brand,
    required this.language,
  });

  /// What a fresh install looks like: everything follows the platform.
  static const AppSettings defaults = AppSettings(
    designLanguage: DesignLanguagePreference.system,
    themeMode: AppThemeMode.system,
    brand: DSBrand.aurora,
    language: AppLanguage.system,
  );

  final DesignLanguagePreference designLanguage;
  final AppThemeMode themeMode;
  final DSBrand brand;
  final AppLanguage language;

  AppSettings copyWith({
    DesignLanguagePreference? designLanguage,
    AppThemeMode? themeMode,
    DSBrand? brand,
    AppLanguage? language,
  }) => AppSettings(
    designLanguage: designLanguage ?? this.designLanguage,
    themeMode: themeMode ?? this.themeMode,
    brand: brand ?? this.brand,
    language: language ?? this.language,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          other.designLanguage == designLanguage &&
          other.themeMode == themeMode &&
          other.brand == brand &&
          other.language == language;

  @override
  int get hashCode => Object.hash(designLanguage, themeMode, brand, language);

  @override
  String toString() =>
      'AppSettings(designLanguage: ${designLanguage.name}, '
      'themeMode: ${themeMode.name}, brand: ${brand.name}, '
      'language: ${language.name})';
}
