import 'package:design_system_flutter/app/app.dart';
import 'package:design_system_flutter/app/application/app_providers.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/data/key_value_store.dart';
import 'package:design_system_flutter/features/settings/data/settings_repository_impl.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:design_system_flutter/l10n/generated/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpComponent(
  WidgetTester tester,
  Widget child, {
  DesignLanguage designLanguage = DesignLanguage.material,
  Brightness brightness = Brightness.light,
  Locale locale = const Locale('en'),
}) async {
  final DSThemeData ds = DSThemeData.resolve(
    designLanguage: designLanguage,
    brightness: brightness,
    brand: DSBrand.aurora,
  );

  const Iterable<LocalizationsDelegate<Object>> delegates =
      <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  await tester.pumpWidget(
    DSTheme(
      data: ds,
      child: switch (designLanguage) {
        DesignLanguage.material => MaterialApp(
          theme: DSMaterialTheme.from(ds),
          locale: locale,
          localizationsDelegates: delegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: Center(child: child)),
        ),
        DesignLanguage.cupertino => CupertinoApp(
          theme: DSCupertinoTheme.from(ds),
          locale: locale,
          localizationsDelegates: delegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CupertinoPageScaffold(child: Center(child: child)),
        ),
      },
    ),
  );
}

const AppSettings returningUser = AppSettings(
  designLanguage: DesignLanguagePreference.system,
  themeMode: AppThemeMode.system,
  brand: DSBrand.aurora,
  language: AppLanguage.system,
  hasCompletedOnboarding: true,
);

Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  AppSettings settings = returningUser,
  bool platformIsApple = false,
  Size surfaceSize = const Size(420, 900),
}) async {
  tester.view
    ..devicePixelRatio = 1.0
    ..physicalSize = surfaceSize;
  addTearDown(tester.view.reset);

  final SettingsRepositoryImpl repository = SettingsRepositoryImpl(
    InMemoryKeyValueStore(),
  );
  await repository.save(settings);

  final ProviderContainer container = ProviderContainer(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(repository),
      initialSettingsProvider.overrideWithValue(settings),
      platformIsAppleProvider.overrideWithValue(platformIsApple),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const AuroraApp()),
  );
  await tester.pumpAndSettle();
  return container;
}
