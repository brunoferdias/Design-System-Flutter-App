import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system_flutter/app/app.dart';
import 'package:design_system_flutter/app/application/app_providers.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/data/key_value_store.dart';
import 'package:design_system_flutter/features/settings/data/settings_repository_impl.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:design_system_flutter/l10n/generated/app_localizations.dart';

/// Mounts a single component under a fully configured design system.
///
/// Component tests get the real `DSTheme`, the real localizations and the real
/// platform chrome — the only thing faked is the rest of the app. Anything less
/// and the test would not be exercising what ships.
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

/// Mounts the entire application on top of an in-memory store.
///
/// This is the same widget tree `main()` builds — only the two composition-root
/// overrides differ, which is exactly the point of having a composition root.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  AppSettings settings = AppSettings.defaults,
  bool platformIsApple = false,
  Size surfaceSize = const Size(420, 900),
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));

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
    UncontrolledProviderScope(
      container: container,
      child: const AuroraApp(),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}
