import 'package:design_system_flutter/app/application/app_providers.dart';
import 'package:design_system_flutter/app/router/app_router.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:design_system_flutter/l10n/generated/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The root widget.
///
/// Its single responsibility is to turn the user's settings into a resolved
/// [DSThemeData] and then mount *one* of Flutter's two app widgets around it.
/// Everything below this point is design-language agnostic.
final class AuroraApp extends ConsumerWidget {
  const AuroraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignLanguage designLanguage = ref.watch(designLanguageProvider);
    final DSBrand brand = ref.watch(
      settingsProvider.select((AppSettings s) => s.brand),
    );
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final Locale? locale = ref.watch(localeProvider);
    final GoRouter router = ref.watch(routerProvider);

    // Brightness is resolved here rather than delegated to `MaterialApp`'s
    // `theme`/`darkTheme` pair. One resolved theme means `DSTheme` and
    // `ThemeData` can never disagree — and it is the only way to give
    // `CupertinoApp`, which has no `darkTheme`, the same behaviour.
    final Brightness brightness = switch (themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => MediaQuery.platformBrightnessOf(context),
    };

    final DSThemeData ds = DSThemeData.resolve(
      designLanguage: designLanguage,
      brightness: brightness,
      brand: brand,
    );

    return DSTheme(
      data: ds,
      child: switch (designLanguage) {
        DesignLanguage.material => MaterialApp.router(
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: DSMaterialTheme.from(ds),
          routerConfig: router,
          locale: locale,
          localizationsDelegates: _localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          scrollBehavior: const _AppScrollBehavior(),
        ),
        DesignLanguage.cupertino => CupertinoApp.router(
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: DSCupertinoTheme.from(ds),
          routerConfig: router,
          locale: locale,
          localizationsDelegates: _localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          scrollBehavior: const _AppScrollBehavior(),
        ),
      },
    );
  }

  /// The app's own translations plus Flutter's built-in ones.
  ///
  /// Both Material *and* Cupertino delegates are always registered: in
  /// Cupertino mode a Material widget can still surface (the text selection
  /// toolbar, for instance), and a missing delegate only fails at the moment
  /// the user reaches for it.
  static const Iterable<LocalizationsDelegate<Object>>
  _localizationsDelegates = <LocalizationsDelegate<Object>>[
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

/// Allows mouse and trackpad dragging, which Flutter disables by default on
/// desktop and web. Without it, the component gallery cannot be scrolled by
/// dragging in a browser.
final class _AppScrollBehavior extends CupertinoScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}
