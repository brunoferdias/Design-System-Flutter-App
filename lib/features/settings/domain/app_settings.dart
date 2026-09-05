import 'package:design_system_flutter/design_system/foundations/ds_brand.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:flutter/foundation.dart';

enum AppThemeMode { system, light, dark }

enum AppLanguage {
  system(null),
  english('en'),
  portuguese('pt'),
  german('de');

  const AppLanguage(this.languageCode);
  final String? languageCode;

  static AppLanguage fromCode(String? code) => values.firstWhere(
    (AppLanguage language) => language.languageCode == code,
    orElse: () => AppLanguage.system,
  );

  static const List<AppLanguage> supported = <AppLanguage>[
    AppLanguage.english,
    AppLanguage.portuguese,
    AppLanguage.german,
  ];
}

@immutable
final class AppSettings {
  const AppSettings({
    required this.designLanguage,
    required this.themeMode,
    required this.brand,
    required this.language,
    required this.hasCompletedOnboarding,
  });

  static const AppSettings defaults = AppSettings(
    designLanguage: DesignLanguagePreference.system,
    themeMode: AppThemeMode.system,
    brand: DSBrand.aurora,
    language: AppLanguage.system,
    hasCompletedOnboarding: false,
  );

  final DesignLanguagePreference designLanguage;
  final AppThemeMode themeMode;
  final DSBrand brand;
  final AppLanguage language;
  final bool hasCompletedOnboarding;

  AppSettings copyWith({
    DesignLanguagePreference? designLanguage,
    AppThemeMode? themeMode,
    DSBrand? brand,
    AppLanguage? language,
    bool? hasCompletedOnboarding,
  }) => AppSettings(
    designLanguage: designLanguage ?? this.designLanguage,
    themeMode: themeMode ?? this.themeMode,
    brand: brand ?? this.brand,
    language: language ?? this.language,
    hasCompletedOnboarding:
        hasCompletedOnboarding ?? this.hasCompletedOnboarding,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          other.designLanguage == designLanguage &&
          other.themeMode == themeMode &&
          other.brand == brand &&
          other.language == language &&
          other.hasCompletedOnboarding == hasCompletedOnboarding;

  @override
  int get hashCode => Object.hash(
    designLanguage,
    themeMode,
    brand,
    language,
    hasCompletedOnboarding,
  );

  @override
  String toString() =>
      'AppSettings(designLanguage: ${designLanguage.name}, '
      'themeMode: ${themeMode.name}, brand: ${brand.name}, '
      'language: ${language.name}, '
      'hasCompletedOnboarding: $hasCompletedOnboarding)';
}
