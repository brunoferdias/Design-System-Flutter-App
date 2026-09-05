import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True on iOS and macOS.
///
/// It is a provider so the tests can pretend to be on an Apple device without
/// actually running on one.
final platformIsAppleProvider = Provider<bool>((ref) {
  return defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
});

// The three providers below turn what the user chose in Settings into the
// values the widgets actually need. Keeping the conversion here means no page
// has to repeat it.

/// The look the app is rendering with right now.
final designLanguageProvider = Provider<DesignLanguage>((ref) {
  final preference = ref.watch(settingsProvider).designLanguage;
  final platformIsApple = ref.watch(platformIsAppleProvider);

  return preference.resolve(platformIsApple: platformIsApple);
});

/// The language to render in, or null to follow the phone.
final localeProvider = Provider<Locale?>((ref) {
  final languageCode = ref.watch(settingsProvider).language.languageCode;
  if (languageCode == null) return null;

  return Locale(languageCode);
});

/// Our theme mode translated into the one Flutter understands.
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
