import 'package:design_system_flutter/app/application/app_providers.dart';
import 'package:design_system_flutter/app/router/app_router.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/l10n/generated/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The root of the app.
///
/// It watches the settings and rebuilds the whole app when they change, which
/// is how switching design language, theme, brand or locale takes effect
/// immediately.
class AuroraApp extends ConsumerWidget {
  const AuroraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final designLanguage = ref.watch(designLanguageProvider);
    final brand = ref.watch(settingsProvider).brand;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

    // "System" has to be turned into a real brightness before we can build the
    // colours, so we ask the platform what it is currently using.
    final Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
      case ThemeMode.dark:
        brightness = Brightness.dark;
      case ThemeMode.system:
        brightness = MediaQuery.platformBrightnessOf(context);
    }

    final ds = DSThemeData.resolve(
      designLanguage: designLanguage,
      brightness: brightness,
      brand: brand,
    );

    // DSTheme goes outside the app so that dialogs, sheets and toasts -- which
    // are drawn in the root overlay -- can still read the tokens.
    return DSTheme(
      data: ds,
      child: designLanguage.isCupertino
          ? _buildCupertinoApp(ds, router, locale)
          : _buildMaterialApp(ds, router, locale),
    );
  }

  Widget _buildMaterialApp(DSThemeData ds, GoRouter router, Locale? locale) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: DSMaterialTheme.from(ds),
      routerConfig: router,
      locale: locale,
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      scrollBehavior: const _AppScrollBehavior(),
    );
  }

  Widget _buildCupertinoApp(DSThemeData ds, GoRouter router, Locale? locale) {
    return CupertinoApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: DSCupertinoTheme.from(ds),
      routerConfig: router,
      locale: locale,
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      scrollBehavior: const _AppScrollBehavior(),
    );
  }

  /// The first one holds our own translations; the other three translate the
  /// widgets that come with Flutter.
  static const List<LocalizationsDelegate<Object>> _localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

/// Lets every page be dragged with a mouse or a trackpad too, not just with a
/// finger, so the app also feels right on desktop and web.
class _AppScrollBehavior extends CupertinoScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}
