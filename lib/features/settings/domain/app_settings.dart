import 'package:design_system_flutter/design_system/foundations/ds_brand.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';

/// Light, dark, or whatever the phone is set to.
enum AppThemeMode { system, light, dark }

/// The languages the app is translated into.
///
/// `system` has no code because it means "follow the phone".
enum AppLanguage {
  system(null),
  english('en'),
  portuguese('pt'),
  german('de');

  const AppLanguage(this.languageCode);

  final String? languageCode;

  /// The languages the user can pick explicitly (everything except `system`).
  static const List<AppLanguage> supported = [
    AppLanguage.english,
    AppLanguage.portuguese,
    AppLanguage.german,
  ];
}

/// Everything the user can configure, kept in one immutable object.
///
/// This is the domain layer: it knows nothing about Flutter or about how the
/// values are stored on the device.
class AppSettings {
  const AppSettings({
    required this.designLanguage,
    required this.themeMode,
    required this.brand,
    required this.language,
    required this.hasCompletedOnboarding,
  });

  /// What a brand new install starts with.
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

  /// False until the user finishes (or skips) the introduction.
  final bool hasCompletedOnboarding;

  /// Returns a copy with only the given fields changed.
  AppSettings copyWith({
    DesignLanguagePreference? designLanguage,
    AppThemeMode? themeMode,
    DSBrand? brand,
    AppLanguage? language,
    bool? hasCompletedOnboarding,
  }) {
    return AppSettings(
      designLanguage: designLanguage ?? this.designLanguage,
      themeMode: themeMode ?? this.themeMode,
      brand: brand ?? this.brand,
      language: language ?? this.language,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  // Two settings objects with the same values are equal. Riverpod relies on
  // this to skip rebuilds when nothing really changed.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.designLanguage == designLanguage &&
        other.themeMode == themeMode &&
        other.brand == brand &&
        other.language == language &&
        other.hasCompletedOnboarding == hasCompletedOnboarding;
  }

  @override
  int get hashCode => Object.hash(
    designLanguage,
    themeMode,
    brand,
    language,
    hasCompletedOnboarding,
  );

  @override
  String toString() {
    return 'AppSettings(designLanguage: ${designLanguage.name}, '
        'themeMode: ${themeMode.name}, brand: ${brand.name}, '
        'language: ${language.name}, '
        'hasCompletedOnboarding: $hasCompletedOnboarding)';
  }
}
