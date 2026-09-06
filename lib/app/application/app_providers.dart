import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final platformIsAppleProvider = Provider<bool>((ref) {
  return defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
});

final designLanguageProvider = Provider<DesignLanguage>((ref) {
  final preference = ref.watch(settingsProvider).designLanguage;
  final platformIsApple = ref.watch(platformIsAppleProvider);

  return preference.resolve(platformIsApple: platformIsApple);
});

final localeProvider = Provider<Locale?>((ref) {
  final languageCode = ref.watch(settingsProvider).language.languageCode;
  if (languageCode == null) return null;

  return Locale(languageCode);
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final mode = ref.watch(settingsProvider).themeMode;

  switch (mode) {
    case AppThemeMode.system:
      return ThemeMode.system;
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
  }
});
