import 'package:flutter_test/flutter_test.dart';

import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/settings/data/key_value_store.dart';
import 'package:design_system_flutter/features/settings/data/settings_repository_impl.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';

void main() {
  late InMemoryKeyValueStore store;
  late SettingsRepositoryImpl repository;

  setUp(() {
    store = InMemoryKeyValueStore();
    repository = SettingsRepositoryImpl(store);
  });

  test('an empty store yields the defaults', () async {
    expect(await repository.load(), AppSettings.defaults);
  });

  test('settings survive a save/load round trip', () async {
    const AppSettings settings = AppSettings(
      designLanguage: DesignLanguagePreference.cupertino,
      themeMode: AppThemeMode.dark,
      brand: DSBrand.sunset,
      language: AppLanguage.german,
    );

    await repository.save(settings);

    expect(await repository.load(), settings);
  });

  test('an unrecognised stored value degrades to its default', () async {
    await store.writeString('settings.designLanguage', 'holographic');
    await store.writeString('settings.brand', 'chartreuse');
    await store.writeString('settings.themeMode', 'dark');

    final AppSettings loaded = await repository.load();

    expect(loaded.designLanguage, AppSettings.defaults.designLanguage);
    expect(loaded.brand, AppSettings.defaults.brand);
    // The valid key is still honoured — one bad value does not poison the rest.
    expect(loaded.themeMode, AppThemeMode.dark);
  });

  test('clear forgets every key', () async {
    await repository.save(
      AppSettings.defaults.copyWith(themeMode: AppThemeMode.light),
    );

    await repository.clear();

    expect(await repository.load(), AppSettings.defaults);
    expect(store.readString('settings.themeMode'), isNull);
  });
}
