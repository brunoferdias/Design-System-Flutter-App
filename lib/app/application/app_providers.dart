import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<bool> platformIsAppleProvider = Provider<bool>(
  (Ref ref) =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS,
  name: 'platformIsApple',
);

final Provider<DesignLanguage> designLanguageProvider =
    Provider<DesignLanguage>(
      (Ref ref) => ref
          .watch(settingsProvider.select((AppSettings s) => s.designLanguage))
          .resolve(platformIsApple: ref.watch(platformIsAppleProvider)),
      name: 'designLanguage',
    );

final Provider<Locale?> localeProvider = Provider<Locale?>((Ref ref) {
  final AppLanguage language = ref.watch(
    settingsProvider.select((AppSettings s) => s.language),
  );
  final String? code = language.languageCode;
  return code == null ? null : Locale(code);
}, name: 'locale');

final Provider<ThemeMode> themeModeProvider = Provider<ThemeMode>((Ref ref) {
  final AppThemeMode mode = ref.watch(
    settingsProvider.select((AppSettings s) => s.themeMode),
  );
  return switch (mode) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}, name: 'themeMode');
