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

class AuroraApp extends ConsumerWidget {
  const AuroraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final designLanguage = ref.watch(designLanguageProvider);
    final brand = ref.watch(settingsProvider).brand;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

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

  static const List<LocalizationsDelegate<Object>> _localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

class _AppScrollBehavior extends CupertinoScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}
