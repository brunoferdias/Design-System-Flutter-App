import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the app is running on an Apple platform.
///
/// Isolated behind a provider so that "what does *automatic* mean here?" can be
/// answered differently in a test, in a screenshot harness, or on the web —
/// without a single `if (Platform.isIOS)` leaking into the widget tree.
final Provider<bool> platformIsAppleProvider = Provider<bool>(
  (Ref ref) =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS,
  name: 'platformIsApple',
);

/// The design language actually in effect, with [DesignLanguagePreference.system]
/// already resolved.
final Provider<DesignLanguage> designLanguageProvider = Provider<DesignLanguage>(
  (Ref ref) => ref
      .watch(settingsProvider.select((AppSettings s) => s.designLanguage))
      .resolve(platformIsApple: ref.watch(platformIsAppleProvider)),
  name: 'designLanguage',
);

/// The locale to hand to `MaterialApp`/`CupertinoApp`, or `null` to follow the
/// device.
final Provider<Locale?> localeProvider = Provider<Locale?>((Ref ref) {
  final AppLanguage language = ref.watch(
    settingsProvider.select((AppSettings s) => s.language),
  );
  final String? code = language.languageCode;
  return code == null ? null : Locale(code);
}, name: 'locale');

/// The domain's [AppThemeMode] translated into Flutter's [ThemeMode].
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
