import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system_flutter/app/application/app_providers.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/data/key_value_store.dart';
import 'package:design_system_flutter/features/settings/data/settings_repository_impl.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';

void main() {
  late InMemoryKeyValueStore store;
  late SettingsRepositoryImpl repository;

  ProviderContainer makeContainer({
    AppSettings initial = AppSettings.defaults,
    bool platformIsApple = false,
  }) {
    final ProviderContainer container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(repository),
        initialSettingsProvider.overrideWithValue(initial),
        platformIsAppleProvider.overrideWithValue(platformIsApple),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    store = InMemoryKeyValueStore();
    repository = SettingsRepositoryImpl(store);
  });

  test('starts from the settings loaded at bootstrap', () {
    final ProviderContainer container = makeContainer(
      initial: AppSettings.defaults.copyWith(brand: DSBrand.forest),
    );

    expect(container.read(settingsProvider).brand, DSBrand.forest);
  });

  test('a change is reflected in state and written through to storage', () async {
    final ProviderContainer container = makeContainer();

    container.read(settingsProvider.notifier).setThemeMode(AppThemeMode.dark);

    expect(container.read(settingsProvider).themeMode, AppThemeMode.dark);
    // The write is fire-and-forget, so let the microtask queue drain.
    await Future<void>.delayed(Duration.zero);
    expect(store.readString('settings.themeMode'), 'dark');
  });

  test('setting the same value again does not touch storage', () async {
    final ProviderContainer container = makeContainer();

    container.read(settingsProvider.notifier).setThemeMode(AppThemeMode.system);
    await Future<void>.delayed(Duration.zero);

    expect(store.readString('settings.themeMode'), isNull);
  });

  test('reset returns to the defaults and clears storage', () async {
    final ProviderContainer container = makeContainer(
      initial: AppSettings.defaults.copyWith(
        brand: DSBrand.graphite,
        language: AppLanguage.portuguese,
      ),
    );

    await container.read(settingsProvider.notifier).reset();

    expect(container.read(settingsProvider), AppSettings.defaults);
    expect(store.readString('settings.brand'), isNull);
  });

  group('derived providers', () {
    test('automatic resolves against the injected platform', () {
      expect(
        makeContainer(platformIsApple: true).read(designLanguageProvider),
        DesignLanguage.cupertino,
      );
      expect(
        makeContainer().read(designLanguageProvider),
        DesignLanguage.material,
      );
    });

    test('an explicit design language wins over the platform', () {
      final ProviderContainer container = makeContainer(platformIsApple: true);

      container
          .read(settingsProvider.notifier)
          .setDesignLanguage(DesignLanguagePreference.material);

      expect(container.read(designLanguageProvider), DesignLanguage.material);
    });

    test('the locale is null while following the system', () {
      final ProviderContainer container = makeContainer();
      expect(container.read(localeProvider), isNull);

      container
          .read(settingsProvider.notifier)
          .setLanguage(AppLanguage.portuguese);

      expect(container.read(localeProvider)?.languageCode, 'pt');
    });
  });
}
